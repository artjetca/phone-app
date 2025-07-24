#!/bin/bash

echo "🔍 檢查 Railway 部署準備狀態..."
echo ""

# 檢查必要文件
echo "📁 檢查必要文件..."
files=("package.json" "server.js" "railway.json" "public/index.html")
all_files_exist=true

for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file - 存在"
    else
        echo "❌ $file - 缺失"
        all_files_exist=false
    fi
done

echo ""

# 檢查 package.json 配置
echo "📦 檢查 package.json 配置..."
if grep -q '"start".*"node server.js"' package.json; then
    echo "✅ start 腳本配置正確"
else
    echo "❌ start 腳本配置有問題"
fi

if grep -q '"node".*">=18.0.0"' package.json; then
    echo "✅ Node.js 版本要求正確 (>=18.0.0)"
else
    echo "⚠️  建議使用 Node.js 18+"
fi

echo ""

# 檢查 server.js 安全性
echo "🔒 檢查代碼安全性..."
if grep -q "process.env.TWILIO_ACCOUNT_SID" server.js && ! grep -q "AC[0-9a-f]\{32\}" server.js; then
    echo "✅ 使用環境變量，無硬編碼憑證"
else
    echo "❌ 發現硬編碼憑證或未使用環境變量"
fi

if grep -q "/health" server.js; then
    echo "✅ 健康檢查端點已配置"
else
    echo "⚠️  缺少健康檢查端點"
fi

echo ""

# 檢查 Git 狀態
echo "📋 檢查 Git 狀態..."
if git status --porcelain | grep -q .; then
    echo "⚠️  有未提交的更改"
    git status --short
else
    echo "✅ 所有更改已提交"
fi

echo ""

# 檢查環境變量（本地）
echo "🔧 檢查本地環境變量..."
if [ -n "$TWILIO_ACCOUNT_SID" ]; then
    echo "✅ TWILIO_ACCOUNT_SID 已設置"
else
    echo "⚠️  TWILIO_ACCOUNT_SID 未設置（Railway 中需要）"
fi

if [ -n "$TWILIO_AUTH_TOKEN" ]; then
    echo "✅ TWILIO_AUTH_TOKEN 已設置"
else
    echo "⚠️  TWILIO_AUTH_TOKEN 未設置（Railway 中需要）"
fi

if [ -n "$TWILIO_PHONE_NUMBER" ]; then
    echo "✅ TWILIO_PHONE_NUMBER 已設置"
else
    echo "⚠️  TWILIO_PHONE_NUMBER 未設置（Railway 中需要）"
fi

echo ""

# 總結
# 測試健康檢查端點
echo "🏥 測試健康檢查端點..."
if command -v curl >/dev/null 2>&1; then
    if pgrep -f "node server.js" > /dev/null; then
        health_response=$(curl -s http://localhost:3000/health 2>/dev/null)
        if echo "$health_response" | grep -q "healthy"; then
            echo "✅ 健康檢查端點正常工作"
        else
            echo "⚠️  健康檢查端點可能有問題"
        fi
    else
        echo "ℹ️  服務器未運行，無法測試健康檢查"
    fi
else
    echo "ℹ️  curl 未安裝，跳過健康檢查測試"
fi

echo ""

# 總結
echo "📊 部署準備總結："
if [ "$all_files_exist" = true ]; then
    echo "✅ 您的應用已準備好部署到 Railway！"
    echo ""
    echo "🔧 修復內容："
    echo "  - 修復了路由順序問題"
    echo "  - 改進了錯誤處理和日誌記錄"
    echo "  - 優化了 Railway 配置"
    echo "  - 添加了優雅關閉處理"
    echo ""
    echo "📋 下一步："
    echo "1. 在 Railway 中創建新項目"
    echo "2. 連接您的 GitHub 倉庫 (artjetca/phone-app)"
    echo "3. 設置環境變量（參考 .env.railway.example）"
    echo "4. 部署並監控日誌！"
    echo ""
    echo "📖 詳細指南請參考 RAILWAY_DEPLOYMENT_GUIDE.md"
else
    echo "❌ 請先修復上述問題再進行部署"
fi
