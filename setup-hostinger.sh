#!/bin/bash

# Setup script for n8n on Hostinger (without sudo)
# Run this script on the Hostinger server via SSH

echo "🚀 Setting up n8n on Hostinger..."

# Step 1: Install NVM (Node Version Manager) - no sudo needed
echo "📦 Installing NVM..."
if [ ! -d "$HOME/.nvm" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
else
    echo "NVM already installed"
fi

# Load NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Step 2: Install Node.js LTS
echo "📦 Installing Node.js LTS..."
nvm install --lts
nvm use --lts
nvm alias default node

# Step 3: Verify installation
echo "✅ Verifying installation..."
node --version
npm --version

# Step 4: Add NVM to .bashrc for persistence
echo "📝 Adding NVM to .bashrc..."
if ! grep -q "NVM_DIR" ~/.bashrc; then
    echo '' >> ~/.bashrc
    echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bashrc
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.bashrc
    echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> ~/.bashrc
fi

# Step 5: Install n8n dependencies
echo "📦 Installing n8n dependencies..."
cd ~/n8n
npm install

# Step 6: Install PM2 globally (for process management)
echo "📦 Installing PM2..."
npm install -g pm2

echo "✅ Setup complete!"
echo ""
echo "To start n8n, run:"
echo "  cd ~/n8n"
echo "  pm2 start server.js --name n8n"
echo "  pm2 save"
