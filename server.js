#!/usr/bin/env node

/**
 * Server entry point for n8n on Hostinger
 * This file is required by Hostinger to recognize the project as a Node.js application
 */

// Import n8n
const { start } = require('n8n');

// Get port from environment variable (Hostinger assigns this automatically)
const port = process.env.PORT || process.env.N8N_PORT || 5678;
const host = process.env.N8N_HOST || '0.0.0.0';

// Start n8n
start({
  port: parseInt(port, 10),
  host: host,
  protocol: process.env.N8N_PROTOCOL || 'https',
}).catch((error) => {
  console.error('Error starting n8n:', error);
  process.exit(1);
});
