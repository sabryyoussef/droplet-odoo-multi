#!/usr/bin/env bash
set -euo pipefail

echo "Running certbot renew --dry-run..."
sudo certbot renew --dry-run

echo "Certbot dry run completed."
