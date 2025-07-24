require('dotenv').config();
const express = require('express');
const cors = require('cors');
const twilio = require('twilio');

const app = express();
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static('public'));

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

// Health check endpoint
app.get('/', (req, res) => {
  res.json({ 
    status: 'OK', 
    message: 'Phone App Server is running',
    timestamp: new Date().toISOString()
  });
});

// Health check for Railway
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'healthy' });
});

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
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});