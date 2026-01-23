#!/usr/bin/env node

/**
 * Express.js server wrapper for n8n on Hostinger
 * Hostinger requires Express.js framework, so we create an Express server
 * that proxies all requests to n8n running in the background
 */

const express = require('express');
const { createProxyMiddleware } = require('http-proxy-middleware');
const { spawn } = require('child_process');

const app = express();
const PORT = process.env.PORT || 3000;
const N8N_PORT = process.env.N8N_PORT || 5678;
const N8N_HOST = process.env.N8N_HOST || '127.0.0.1';

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({ 
    status: 'ok', 
    service: 'n8n-wrapper',
    n8n_port: N8N_PORT 
  });
});

// Start n8n as background process
console.log('Starting n8n in background...');
const n8nProcess = spawn('npx', ['n8n', 'start', '--port', N8N_PORT.toString(), '--host', N8N_HOST], {
  env: {
    ...process.env,
    N8N_PORT: N8N_PORT.toString(),
    N8N_HOST: N8N_HOST,
    N8N_PROTOCOL: process.env.N8N_PROTOCOL || 'https',
  },
  stdio: 'inherit',
  shell: true
});

n8nProcess.on('error', (error) => {
  console.error('Failed to start n8n:', error);
});

n8nProcess.on('exit', (code) => {
  console.log(`n8n process exited with code ${code}`);
  if (code !== 0 && code !== null) {
    process.exit(code);
  }
});

// Wait a bit for n8n to start
setTimeout(() => {
  // Proxy all requests to n8n
  app.use('/', createProxyMiddleware({
    target: `http://${N8N_HOST}:${N8N_PORT}`,
    changeOrigin: true,
    ws: true, // Enable websocket proxying
    logLevel: 'info',
    onError: (err, req, res) => {
      console.error('Proxy error:', err.message);
      if (!res.headersSent) {
        res.status(502).json({ 
          error: 'n8n service unavailable',
          message: 'Waiting for n8n to start...'
        });
      }
    }
  }));

  // Start Express server
  app.listen(PORT, '0.0.0.0', () => {
    console.log(`Express server running on port ${PORT}`);
    console.log(`Proxying requests to n8n on http://${N8N_HOST}:${N8N_PORT}`);
    console.log(`Access n8n at http://localhost:${PORT}`);
  });
}, 3000); // Wait 3 seconds for n8n to start

// Graceful shutdown
process.on('SIGTERM', () => {
  console.log('SIGTERM received, shutting down gracefully');
  n8nProcess.kill('SIGTERM');
  process.exit(0);
});

process.on('SIGINT', () => {
  console.log('SIGINT received, shutting down gracefully');
  n8nProcess.kill('SIGTERM');
  process.exit(0);
});
