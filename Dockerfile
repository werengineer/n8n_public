FROM node:18-alpine

# Install required system dependencies
RUN apk add --update --no-cache \
    git \
    python3 \
    make \
    g++ \
    tzdata \
    && npm install -g n8n \
    && npm install -g npm@latest

# Set timezone
ENV TZ=Asia/Kolkata

# Create app directory
WORKDIR /data

# Set n8n configuration
ENV N8N_HOST=0.0.0.0
ENV N8N_PORT=5678
ENV N8N_PROTOCOL=http
ENV N8N_EDITOR_BASE_URL=http://localhost:5678
ENV EXECUTIONS_PROCESS=main
ENV N8N_DIAGNOSTICS_ENABLED=false
ENV N8N_PUBLIC_API_DISABLED=false
ENV N8N_BASIC_AUTH_ACTIVE=true
ENV N8N_BASIC_AUTH_USER=admin
ENV N8N_BASIC_AUTH_PASSWORD=your-secure-password

# Expose the port n8n runs on
EXPOSE 5678

# Start n8n
CMD ["n8n", "start"]
