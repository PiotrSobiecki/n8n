#!/bin/bash

# Deployment script for n8n on Hostinger via SSH
# Usage: ./deploy-hostinger.sh

echo "🚀 Deploying n8n to Hostinger..."

# Configuration
SSH_USER="u586234842"
SSH_HOST="46.202.142.124"
SSH_PORT="65002"
DEPLOY_DIR="~/n8n"

# Clone or update repository
echo "📥 Cloning/updating repository..."
ssh -p $SSH_PORT $SSH_USER@$SSH_HOST << 'ENDSSH'
cd ~/n8n 2>/dev/null || mkdir -p ~/n8n && cd ~/n8n

if [ -d ".git" ]; then
    echo "Updating existing repository..."
    git pull origin main
else
    echo "Cloning repository..."
    git clone https://github.com/PiotrSobiecki/n8n.git .
fi

# Install dependencies
echo "📦 Installing dependencies..."
npm install

# Check if PM2 is installed
if command -v pm2 &> /dev/null; then
    echo "🔄 Restarting with PM2..."
    pm2 restart n8n || pm2 start server.js --name n8n
    pm2 save
else
    echo "⚠️  PM2 not found. Installing PM2..."
    npm install -g pm2
    pm2 start server.js --name n8n
    pm2 save
    pm2 startup
fi

echo "✅ Deployment complete!"
echo "📊 Status:"
pm2 status

ENDSSH

echo "✅ Done! n8n should be running on Hostinger."
