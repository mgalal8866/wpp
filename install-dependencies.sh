#!/bin/sh

# Set non-interactive mode to prevent prompts during installation
export DEBIAN_FRONTEND=noninteractive

echo "🔄 Updating package list..."
apt-get update

echo "📦 Installing required dependencies..."
apt-get install -y \
    libxshmfence-dev libgbm-dev wget unzip fontconfig locales gconf-service \
    libasound2 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 libexpat1 \
    libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 \
    libgtk-3-0 libnspr4 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 \
    libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 \
    libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 \
    ca-certificates fonts-liberation libappindicator1 libnss3 lsb-release \
    xdg-utils libvips-dev

echo "🌍 Downloading Google Chrome..."
wget -c https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

echo "🔄 Updating package list again..."
apt-get update

echo "📦 Installing additional dependencies for Chrome..."
apt-get install -y libappindicator1

echo "🖥 Installing Google Chrome..."
dpkg -i google-chrome-stable_current_amd64.deb || apt-get install -fy

# Clean up
echo "🧹 Cleaning up..."
apt-get clean
rm -rf /var/lib/apt/lists/*
rm -f google-chrome-stable_current_amd64.deb

echo "✅ Dependencies and Google Chrome installed successfully!"
