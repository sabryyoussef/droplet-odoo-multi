#!/usr/bin/env bash
set -euo pipefail

echo "Testing nginx configuration..."
sudo nginx -t

echo "Reloading nginx..."
sudo systemctl reload nginx

echo "Nginx reload complete."
