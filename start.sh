#!/bin/sh
set -e

# Start n8n in the background
n8n start &

# Start nginx in the foreground
nginx -g 'daemon off;'
