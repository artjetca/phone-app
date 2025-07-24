# Phone App

一个基于 Twilio API 的电话应用，可部署到 Railway 平台。

## 安装步骤

1. 进入项目目录：
   ```
   cd /Users/macbookpro/Desktop/phone-app
   ```

2. 安装依赖：
   ```
   npm install
   ```

3. 配置环境变量：
   编辑 `.env` 文件，填入你的 Twilio 凭据

4. 启动开发服务器：
   ```
   npm run dev
   ```

## 部署到 Railway

1. 将项目推送到 GitHub 仓库
2. 在 Railway 平台上导入该仓库
3. 在 Railway 中设置环境变量（与 .env 文件中相同）
4. 部署应用

## 注意事项

- 确保在项目根目录下运行命令
- 需要有效的 Twilio 账号和凭据