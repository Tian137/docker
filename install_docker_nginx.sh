#!/bin/bash

set -e

# 安装 Docker
if ! command -v docker &>/dev/null; then
    echo "正在安装 Docker ..."
    sudo apt update
    sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io
    sudo systemctl enable docker
    sudo systemctl start docker
else
    echo "Docker 已经安装"
fi

# 安装 Docker Compose 插件（新版）
if ! docker compose version &>/dev/null; then
    echo "正在安装 Docker Compose 插件 ..."
    sudo apt-get update
    sudo apt-get install -y docker-compose-plugin
else
    echo "Docker Compose 已经安装"
fi

# 运行 nginx 容器
if ! docker ps -a | grep -q mynginx; then
    echo "正在启动 nginx 容器 ..."
    sudo docker run -d --name mynginx -p 8080:80 nginx
else
    echo "nginx 容器已经存在"
    sudo docker start mynginx || true
fi

echo "全部完成！请访问 http://你的服务器IP:8080 查看 Nginx 欢迎页。"
