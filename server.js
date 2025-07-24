require('dotenv').config();
const express = require('express');
const cors = require('cors');
const twilio = require('twilio');

console.log('🚀 Starting Phone App Server...');
console.log('📅 Timestamp:', new Date().toISOString());
console.log('🌐 Node.js version:', process.version);
console.log('💻 Platform:', process.platform);

const app = express();
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

console.log('⚙️ Express middleware configured');
console.log('📍 PORT from environment:', process.env.PORT);

// 檢查環境變量是否存在
console.log('Environment variables check:');
console.log('TWILIO_ACCOUNT_SID exists:', !!process.env.TWILIO_ACCOUNT_SID);
console.log('TWILIO_AUTH_TOKEN exists:', !!process.env.TWILIO_AUTH_TOKEN);

// 確保環境變量存在
if (!process.env.TWILIO_ACCOUNT_SID || !process.env.TWILIO_AUTH_TOKEN) {
  console.error('Missing required Twilio environment variables');
  console.error('Please set TWILIO_ACCOUNT_SID and TWILIO_AUTH_TOKEN');
  process.exit(1);
}

const client = twilio(process.env.TWILIO_ACCOUNT_SID, process.env.TWILIO_AUTH_TOKEN);

// Health check for Railway (must be before static files)
app.get('/health', (req, res) => {
  console.log('🏥 Health check requested');
  res.status(200).json({ 
    status: 'healthy',
    timestamp: new Date().toISOString(),
    uptime: process.uptime()
  });
});

// API status endpoint
app.get('/api/status', (req, res) => {
  res.json({ 
    status: 'OK', 
    message: 'Phone App Server is running',
    timestamp: new Date().toISOString(),
    uptime: process.uptime()
  });
});

// Simple root endpoint as fallback
app.get('/', (req, res) => {
  res.json({
    message: 'Phone App is running!',
    status: 'OK',
    timestamp: new Date().toISOString(),
    endpoints: {
      health: '/health',
      status: '/api/status',
      call: '/call (POST)'
    }
  });
});

// Serve static files AFTER API routes
app.use(express.static('public'));

app.post('/call', async (req, res) => {
  try {
    const call = await client.calls.create({
      url: 'http://demo.twilio.com/docs/voice.xml',
      to: req.body.to,
      from: process.env.TWILIO_PHONE_NUMBER
    });
    res.json({ success: true, callSid: call.sid });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
});

const PORT = process.env.PORT || 3000;

// Error handling middleware
app.use((err, req, res, next) => {
  console.error('Error:', err.message);
  console.error('Stack:', err.stack);
  res.status(500).json({ 
    success: false, 
    error: 'Internal server error',
    message: process.env.NODE_ENV === 'development' ? err.message : 'Something went wrong'
  });
});

// 404 handler
app.use('*', (req, res) => {
  res.status(404).json({ 
    success: false, 
    error: 'Not found',
    path: req.originalUrl 
  });
});

const server = app.listen(PORT, () => {
  console.log(`\n🚀 Server successfully started!`);
  console.log(`📡 Listening on port ${PORT}`);
  console.log(`🌐 Environment: ${process.env.NODE_ENV || 'development'}`);
  console.log(`⚡ Health check available at: /health`);
  console.log(`📱 Phone app UI available at: /`);
  console.log(`\n✅ Ready to receive requests!\n`);
});

// Graceful shutdown
process.on('SIGTERM', () => {
  console.log('\n🛑 SIGTERM received, shutting down gracefully...');
  server.close(() => {
    console.log('✅ Server closed successfully');
    process.exit(0);
  });
});

process.on('SIGINT', () => {
  console.log('\n🛑 SIGINT received, shutting down gracefully...');
  server.close(() => {
    console.log('✅ Server closed successfully');
    process.exit(0);
  });
});