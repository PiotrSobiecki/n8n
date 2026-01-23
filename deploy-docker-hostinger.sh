#!/bin/bash

# Docker deployment script for n8n on Hostinger
# Run this on the Hostinger server via SSH

echo "🐳 Deploying n8n with Docker on Hostinger..."

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed."
    echo ""
    echo "Checking if Docker can be installed without sudo..."
    
    # Try to install Docker without sudo (if user is in docker group)
    if groups | grep -q docker; then
        echo "✅ User is in docker group, Docker should work"
    else
        echo "⚠️  Docker requires sudo or docker group membership"
        echo "Please contact Hostinger support to install Docker"
        echo "Or use Node.js installation instead (see INSTALL-NODE.md)"
        exit 1
    fi
fi

# Check if Docker Compose is available
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo "⚠️  Docker Compose not found, but we'll try docker compose (new syntax)"
fi

# Navigate to n8n directory
cd ~/n8n || {
    echo "❌ n8n directory not found. Cloning repository..."
    git clone https://github.com/PiotrSobiecki/n8n.git ~/n8n
    cd ~/n8n
}

# Stop existing containers
echo "🛑 Stopping existing containers..."
docker-compose down 2>/dev/null || docker compose down 2>/dev/null || echo "No existing containers"

# Pull latest n8n image
echo "📥 Pulling latest n8n image..."
docker pull docker.n8n.io/n8nio/n8n:latest

# Update docker-compose.yml with your domain (if needed)
echo "📝 Checking docker-compose.yml..."
if [ -f docker-compose.yml ]; then
    echo "✅ docker-compose.yml found"
    # You can edit WEBHOOK_URL here if needed
    # sed -i 's|WEBHOOK_URL=.*|WEBHOOK_URL=https://your-domain.com/|' docker-compose.yml
else
    echo "❌ docker-compose.yml not found!"
    exit 1
fi

# Start n8n
echo "▶️  Starting n8n with Docker Compose..."
if command -v docker-compose &> /dev/null; then
    docker-compose up -d
else
    docker compose up -d
fi

# Wait a bit for n8n to start
echo "⏳ Waiting for n8n to start..."
sleep 5

# Check if container is running
if docker ps | grep -q n8n; then
    echo "✅ n8n is running!"
    echo ""
    echo "📊 Container status:"
    docker ps | grep n8n
    echo ""
    echo "🌐 n8n should be accessible on port 5678"
    echo "📋 To view logs: docker-compose logs -f"
    echo "🛑 To stop: docker-compose down"
else
    echo "❌ Failed to start n8n. Check logs with:"
    echo "   docker-compose logs"
    exit 1
fi
