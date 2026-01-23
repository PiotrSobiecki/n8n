#!/usr/bin/env node

/**
 * Server entry point for n8n on Hostinger
 * Simple wrapper to start n8n
 */

const { exec } = require('child_process');

const port = process.env.PORT || process.env.N8N_PORT || 5678;
const host = process.env.N8N_HOST || '0.0.0.0';

console.log(`Starting n8n on ${host}:${port}...`);

// Start n8n using npx
const n8n = exec(`npx n8n start --port ${port} --host ${host}`, {
  env: {
    ...process.env,
    N8N_PORT: port.toString(),
    N8N_HOST: host,
    N8N_PROTOCOL: process.env.N8N_PROTOCOL || 'https',
  }
});

n8n.stdout.on('data', (data) => {
  console.log(data.toString());
});

n8n.stderr.on('data', (data) => {
  console.error(data.toString());
});

n8n.on('close', (code) => {
  console.log(`n8n process exited with code ${code}`);
  process.exit(code);
});

n8n.on('error', (error) => {
  console.error('Failed to start n8n:', error);
  process.exit(1);
});
