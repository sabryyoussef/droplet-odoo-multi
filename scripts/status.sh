#!/usr/bin/env bash
set -euo pipefail

echo "== Service status =="
sudo systemctl --no-pager --full status odoo18 odoo19 nginx | sed -n '1,120p'

echo
echo "== Active state summary =="
sudo systemctl is-active odoo18 odoo19 nginx || true

echo
echo "== certbot timer =="
sudo systemctl is-enabled certbot.timer 2>/dev/null || true
sudo systemctl is-active certbot.timer 2>/dev/null || true
