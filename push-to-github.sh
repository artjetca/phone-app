#!/bin/bash

# 确保在正确的目录中
cd /Users/macbookpro/Desktop/phone-app || exit

# 初始化 Git 仓库
echo "正在初始化 Git 仓库..."
git init

# 添加所有文件
echo "添加文件到暂存区..."
git add .

# 提交更改
echo "提交更改..."
read -p "请输入提交信息 (默认: '初始化项目'): " commit_message
commit_message=${commit_message:-"初始化项目"}
git commit -m "$commit_message"

# 添加远程仓库
echo "添加远程仓库..."
echo "使用仓库: https://github.com/artjetca/phone-app.git"
git remote add origin https://github.com/artjetca/phone-app.git

# 推送到 GitHub
echo "推送到 GitHub..."
default_branch=$(git symbolic-ref --short HEAD)
git push -u origin "$default_branch"

echo "完成！你的代码已推送到 GitHub 仓库: https://github.com/artjetca/phone-app"