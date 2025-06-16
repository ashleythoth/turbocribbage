#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# === Set Docker version string ===
VERSION_STRING="5:26.1.4-1~ubuntu.24.04~noble"

echo "🔄 Updating package list..."
sudo apt-get update

echo "📦 Installing base dependencies..."
sudo apt-get install -y ca-certificates curl gnupg

echo "📁 Creating Docker keyring directory..."
sudo install -m 0755 -d /etc/apt/keyrings

echo "🔑 Downloading Docker GPG key..."
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc

echo "🔓 Setting key permissions..."
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo "➕ Adding Docker APT repository..."
ARCH=$(dpkg --print-architecture)
CODENAME=$(source /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")

echo "deb [arch=$ARCH signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $CODENAME stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "🔄 Updating package list with Docker repo..."
sudo apt-get update

echo "🐳 Installing Docker Engine and tools (version: $VERSION_STRING)..."
sudo apt-get install -y \
  docker-ce=$VERSION_STRING \
  docker-ce-cli=$VERSION_STRING \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin

echo "✅ Docker Engine and Compose Plugin installed."
docker --version
docker compose version

echo "🧹 Removing any old standalone docker-compose..."
sudo rm -f /usr/local/bin/docker-compose

echo "⬇️ Installing standalone docker-compose v1.26.2..."
sudo curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" \
  -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

echo "⬇️ Adding user to docker group..."
sudo usermod -aG docker $USER


echo "✅ Legacy docker-compose installed:"
docker-compose --version

echo "✅ Installing LAMP Server"
sudo apt install -y lamp-server^

echo "✅ Installing PHPMyAdmin"
# Preseed answers to suppress interactive prompts
echo 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2' | sudo debconf-set-selections
echo 'phpmyadmin phpmyadmin/dbconfig-install boolean true' | sudo debconf-set-selections
echo 'phpmyadmin phpmyadmin/mysql/admin-user string root' | sudo debconf-set-selections
echo 'phpmyadmin phpmyadmin/mysql/admin-pass password rootpassword' | sudo debconf-set-selections
echo 'phpmyadmin phpmyadmin/mysql/app-pass password apppassword' | sudo debconf-set-selections
echo 'phpmyadmin phpmyadmin/app-password-confirm password apppassword' | sudo debconf-set-selections

# Install phpMyAdmin
sudo apt-get update
sudo apt-get install -y phpmyadmin

echo "✅ Installing zip/unzip"
sudo apt install -y zip unzip

echo "✅ Installing CertBOT Prereqs"
sudo apt install -y python3 python3-dev python3-venv libaugeas-dev gcc

echo "✅ Installing CertBOT"
sudo python3 -m venv /opt/certbot/
sudo /opt/certbot/bin/pip install --upgrade pip
sudo /opt/certbot/bin/pip install certbot certbot-apache
sudo ln -s /opt/certbot/bin/certbot /usr/bin/certbot

echo "✅ Installing screen"
sudo apt install -y screen