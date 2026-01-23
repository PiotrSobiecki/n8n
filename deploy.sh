#!/bin/bash

# Deployment script for n8n on Hostinger via SSH
# Usage: ./deploy.sh

echo "🚀 Deploying n8n with Docker..."

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

# Stop existing containers
echo "🛑 Stopping existing containers..."
docker-compose down 2>/dev/null || docker compose down 2>/dev/null

# Pull latest n8n image
echo "📥 Pulling latest n8n image..."
docker pull docker.n8n.io/n8nio/n8n:latest

# Start n8n
echo "▶️  Starting n8n..."
docker-compose up -d || docker compose up -d

# Wait a bit for n8n to start
echo "⏳ Waiting for n8n to start..."
sleep 5

# Check if container is running
if docker ps | grep -q n8n; then
    echo "✅ n8n is running!"
    echo "🌐 Access n8n at: http://localhost:5678"
    echo ""
    echo "📊 Container status:"
    docker ps | grep n8n
else
    echo "❌ Failed to start n8n. Check logs with: docker-compose logs"
    exit 1
fi
