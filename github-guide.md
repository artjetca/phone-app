# 将项目推送到 GitHub 仓库的步骤

## 1. 初始化 Git 仓库

```bash
cd /Users/macbookpro/Desktop/phone-app
git init
```

## 2. 添加所有文件到暂存区

```bash
git add .
```

## 3. 提交更改

```bash
git commit -m "初始化项目"
```

## 4. 在 GitHub 上创建新仓库

1. 登录 GitHub 账号
2. 点击右上角 "+" 图标，选择 "New repository"
3. 填写仓库名称，例如 "phone-app"
4. 不要勾选 "Initialize this repository with a README"
5. 点击 "Create repository"

## 5. 将本地仓库与 GitHub 仓库关联

```bash
git remote add origin https://github.com/artjetca/phone-app.git
```

## 6. 推送代码到 GitHub

```bash
git push -u origin main
```

注意：如果你的默认分支是 master 而不是 main，请使用：

```bash
git push -u origin master
```

## 7. 验证

访问 https://github.com/你的用户名/phone-app 确认代码已成功推送

## 常见问题解决

### 如果遇到身份验证问题

可以使用 GitHub CLI 或设置 SSH 密钥：

#### 使用 GitHub CLI

```bash
# 安装 GitHub CLI
brew install gh

# 登录
gh auth login

# 然后按照提示操作
```

#### 或者设置 SSH 密钥

```bash
# 生成 SSH 密钥
ssh-keygen -t ed25519 -C "你的邮箱@example.com"

# 将 SSH 密钥添加到 ssh-agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# 复制公钥
pbcopy < ~/.ssh/id_ed25519.pub

# 然后在 GitHub 设置中添加 SSH 密钥
# 访问 https://github.com/settings/keys
```

完成以上步骤后，你的项目就成功推送到 GitHub 仓库了！