# 🔧 Railway 部署故障排除指南

## 🚨 常見部署失敗原因

### 1. Healthcheck Failure (健康檢查失敗)
**症狀：** 部署在 "Network + Healthcheck" 階段失敗
**原因：** 
- 應用沒有正確啟動
- 健康檢查端點無法訪問
- 端口綁定問題

**解決方案：**
- ✅ 已修復：簡化了 Railway 配置
- ✅ 已修復：移除了自定義健康檢查配置
- ✅ 已修復：添加了詳細的啟動日誌

### 2. 環境變量問題
**症狀：** 應用啟動後立即退出
**檢查：** 在 Railway Variables 標籤中確認：
```
TWILIO_ACCOUNT_SID=你的_Account_SID
TWILIO_AUTH_TOKEN=你的_Auth_Token
TWILIO_PHONE_NUMBER=你的_電話號碼
```

### 3. 端口綁定問題
**症狀：** 應用無法接收請求
**解決：** ✅ 已修復 - 移除了硬編碼的主機綁定

## 🔍 調試步驟

### 步驟 1: 檢查部署日誌
1. 在 Railway 控制台點擊失敗的部署
2. 查看 "View logs" 獲取詳細錯誤信息
3. 尋找以下關鍵信息：
   - `🚀 Starting Phone App Server...`
   - `Environment variables check:`
   - `🚀 Server successfully started!`

### 步驟 2: 驗證環境變量
確保在 Railway Variables 中設置了：
- `TWILIO_ACCOUNT_SID` (必需)
- `TWILIO_AUTH_TOKEN` (必需)  
- `TWILIO_PHONE_NUMBER` (必需)

### 步驟 3: 測試端點
部署成功後測試：
- `GET /health` - 健康檢查
- `GET /` - 根端點
- `GET /api/status` - 狀態檢查

## 🛠️ 最新修復 (2025-07-24)

### 修復內容：
1. **簡化 Railway 配置** - 移除了可能導致問題的高級配置
2. **改進啟動日誌** - 添加了詳細的調試信息
3. **優化端點路由** - 確保健康檢查端點優先級
4. **添加回退端點** - 創建了簡單的根端點作為備用

### 配置變更：
```json
// railway.json - 簡化版本
{
  "$schema": "https://railway.app/railway.schema.json",
  "build": {
    "builder": "NIXPACKS"
  },
  "deploy": {
    "startCommand": "npm start"
  }
}
```

## 📊 部署成功指標

### 成功的日誌應該包含：
```
🚀 Starting Phone App Server...
📅 Timestamp: [時間戳]
🌐 Node.js version: [版本]
💻 Platform: linux
⚙️ Express middleware configured
📍 PORT from environment: [端口號]
Environment variables check:
TWILIO_ACCOUNT_SID exists: true
TWILIO_AUTH_TOKEN exists: true
🚀 Server successfully started!
📡 Listening on port [端口號]
✅ Ready to receive requests!
```

### 健康檢查響應：
```json
{
  "status": "healthy",
  "timestamp": "2025-07-24T...",
  "uptime": 123.456
}
```

## 🆘 如果仍然失敗

### 1. 檢查 Twilio 憑證
- 登錄 [Twilio Console](https://console.twilio.com/)
- 驗證 Account SID 和 Auth Token
- 確認電話號碼格式正確 (+1xxxxxxxxxx)

### 2. 重新部署
- 在 Railway 中點擊 "Redeploy"
- 或推送新的提交觸發重新部署

### 3. 聯繫支持
如果問題持續存在，請提供：
- Railway 部署日誌的完整輸出
- 環境變量配置截圖（隱藏敏感值）
- 錯誤信息的詳細描述

## 📝 部署檢查清單

- [ ] 所有環境變量已設置
- [ ] Twilio 憑證有效
- [ ] 最新代碼已推送到 GitHub
- [ ] Railway 項目已連接到正確的倉庫
- [ ] 部署日誌顯示成功啟動
- [ ] 健康檢查端點響應正常
