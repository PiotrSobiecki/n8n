#!/usr/bin/env node

/**
 * n8n server entry point
 * Simple wrapper to start n8n with proper configuration
 */

const { exec } = require('child_process');

const port = process.env.PORT || process.env.N8N_PORT || 5678;
const host = process.env.N8N_HOST || '0.0.0.0';

console.log(`Starting n8n on ${host}:${port}...`);
console.log(`Access n8n at: http://localhost:${port}`);

// Start n8n directly (n8n uses environment variables, not CLI flags)
const n8n = exec(`npx n8n start`, {
  env: {
    ...process.env,
    N8N_PORT: port.toString(),
    N8N_HOST: host,
    N8N_PROTOCOL: process.env.N8N_PROTOCOL || 'http',
  }
});

n8n.stdout.on('data', (data) => {
  process.stdout.write(data);
});

n8n.stderr.on('data', (data) => {
  process.stderr.write(data);
});

n8n.on('close', (code) => {
  console.log(`\nn8n process exited with code ${code}`);
  process.exit(code);
});

n8n.on('error', (error) => {
  console.error('Failed to start n8n:', error);
  process.exit(1);
});
