#!/bin/bash

# Script untuk instalasi Docker dan Docker Compose v2 di Ubuntu 24.04
# Author: Auto-generated for z0nk
# Date: 2025-10-05

set -e  # Exit on error

echo "Docker & Docker Compose v2 Installation Check"
echo "Ubuntu 24.04 LTS (Noble Numbat)"
echo ""

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    echo "⚠️  Jangan jalankan script ini sebagai root!"
    echo "   Gunakan: bash install-docker.sh"
    exit 1
fi

# Check if Docker is already installed
if command_exists docker; then
    echo "✅ Docker sudah terinstall!"
    echo "Docker version:"
    docker --version
    echo ""

    # Check Docker service status
    if systemctl is-active --quiet docker; then
        echo "✅ Docker service sedang berjalan"
    else
        echo "⚠️  Docker service tidak berjalan, mencoba menjalankan..."
        sudo systemctl start docker || echo "Gagal menjalankan Docker service"
    fi
    echo ""
else
    echo "❌ Docker belum terinstall"
    echo ""
fi

# Check if Docker Compose is already installed
if command_exists docker-compose || docker compose version >/dev/null 2>&1; then
    echo "✅ Docker Compose sudah terinstall!"
    echo "Docker Compose version:"
    if command_exists docker-compose; then
        docker-compose --version
    else
        docker compose version
    fi
    echo ""
else
    echo "❌ Docker Compose belum terinstall"
    echo ""
fi

# If both are installed, show summary and exit
if command_exists docker && (command_exists docker-compose || docker compose version >/dev/null 2>&1); then
    echo "🎉 Docker dan Docker Compose sudah terinstall dengan baik!"
    echo ""
    echo "🧪 Test Docker dengan:"
    echo "   docker run hello-world"
    echo ""
    echo "🧪 Test Docker Compose dengan:"
    echo "   docker compose version"
    echo ""
    echo "📋 Untuk reinstall atau update, hapus instalasi yang ada terlebih dahulu:"
    echo "   sudo apt-get remove docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin"
    exit 0
fi

echo "📦 Memulai instalasi Docker dan Docker Compose v2..."
echo ""

echo "📦 Step 1: Update package list dan install dependencies..."
sudo apt-get update
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

echo ""
echo "🔑 Step 2: Menambahkan Docker GPG key..."
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo ""
echo "📋 Step 3: Setup Docker repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo ""
echo "🔄 Step 4: Update package list dengan repository Docker..."
sudo apt-get update

echo ""
echo "🐳 Step 5: Install Docker Engine, CLI, Containerd, dan Docker Compose v2..."
sudo apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

echo ""
echo "👤 Step 6: Menambahkan user '$USER' ke grup docker..."
sudo usermod -aG docker $USER

echo ""
echo "🚀 Step 7: Enable dan start Docker service..."
sudo systemctl enable docker
sudo systemctl start docker

echo ""
echo "✅ Step 8: Verifikasi instalasi..."
echo ""
echo "Docker version:"
sudo docker --version

echo ""
echo "Docker Compose version:"
sudo docker compose version

echo ""
echo "Docker service status:"
sudo systemctl status docker --no-pager | head -5

echo ""
echo "✅ Instalasi berhasil!"
echo ""
echo "⚠️  PENTING:"
echo "   Untuk menggunakan Docker tanpa sudo, logout dan login kembali"
echo "   atau jalankan: newgrp docker"
echo ""
echo "🧪 Test Docker dengan:"
echo "   docker run hello-world"
echo ""
echo "🧪 Test Docker Compose dengan:"
echo "   docker compose version"
echo ""