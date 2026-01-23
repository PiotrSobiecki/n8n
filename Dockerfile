FROM docker.n8n.io/n8nio/n8n:latest

# Set working directory
WORKDIR /home/node

# Expose n8n port
EXPOSE 5678

# Use the default n8n entrypoint
# n8n will start automatically when container runs
