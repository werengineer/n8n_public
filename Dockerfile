FROM node:22-alpine

# Install required system dependencies
RUN apk add --update --no-cache \
    git \
    python3 \
    make \
    g++ \
    tzdata \
    nginx \
    && npm install -g n8n \
    && npm install -g npm@latest

# Set timezone
ENV TZ=Asia/Kolkata

# Create app directory
WORKDIR /data

# Set n8n configuration
ENV N8N_HOST=0.0.0.0
ENV N8N_PORT=8080
ENV N8N_PROTOCOL=https
ENV N8N_EDITOR_BASE_URL=https://n8n-public-230877802260.europe-west1.run.app
ENV WEBHOOK_URL=https://n8n-public-230877802260.europe-west1.run.app
ENV EXECUTIONS_PROCESS=main
ENV N8N_DIAGNOSTICS_ENABLED=false
ENV N8N_PUBLIC_API_DISABLED=false
ENV N8N_BASIC_AUTH_ACTIVE=true
ENV N8N_BASIC_AUTH_USER=info@weareengineer.com
ENV N8N_BASIC_AUTH_PASSWORD=Wae_n8n123
ENV N8N_PATH=/data
ENV N8N_CONFIG_FILES=/data/config

# Create necessary directories
RUN mkdir -p /data/.n8n

# Add health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=60s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:8080/healthz || exit 1

# Expose the port n8n runs on
EXPOSE 8080

# Install curl for health checks
RUN apk add --no-cache curl

# Configure nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Add a simple health check endpoint
RUN echo 'const express = require("express"); const app = express(); app.get("/healthz", (req, res) => res.send("OK")); app.listen(8081);' > /health.js

# Start script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Expose port for nginx
EXPOSE 80

# Start nginx and n8n
CMD ["/start.sh"]
