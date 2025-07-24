#!/bin/bash

# 确保在正确的目录中
cd /Users/macbookpro/Desktop/phone-app || exit

# 初始化Git仓库
echo "正在初始化Git仓库..."
git init

# 添加.gitignore文件
echo "node_modules/" > .gitignore
echo "dist/" >> .gitignore
echo ".env" >> .gitignore
echo ".DS_Store" >> .gitignore

# 添加所有文件
echo "添加文件到暂存区..."
git add .

# 提交更改
echo "提交更改..."
git commit -m "初始化电话应用项目"

# 添加远程仓库
echo "添加远程仓库..."
git remote add origin "https://github.com/artjetca/phone-app.git"

# 推送到GitHub
echo "推送到GitHub..."
default_branch=$(git symbolic-ref --short HEAD 2>/dev/null || echo "main")
git push -u origin "$default_branch"

echo "完成！你的代码已推送到GitHub仓库: https://github.com/artjetca/phone-app"
echo "如果遇到身份验证问题，请按照github-guide.md中的说明进行操作"