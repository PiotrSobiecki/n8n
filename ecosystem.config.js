// PM2 configuration (jeśli Hostinger wspiera PM2)
module.exports = {
  apps: [{
    name: 'n8n',
    script: 'npx',
    args: 'n8n start',
    instances: 1,
    autorestart: true,
    watch: false,
    max_memory_restart: '1G',
    env: {
      NODE_ENV: 'production',
      N8N_HOST: '0.0.0.0',
      N8N_PORT: process.env.PORT || 5678
    }
  }]
};
