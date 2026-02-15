#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
STAMP="$(date +%F_%H%M%S)"

NGINX_DST="$ROOT_DIR/snapshots/nginx/$STAMP"
SYSTEMD_DST="$ROOT_DIR/snapshots/systemd/$STAMP"
ODOO_DST="$ROOT_DIR/snapshots/odoo-conf/$STAMP"
SYSCTL_DST="$ROOT_DIR/snapshots/sysctl/$STAMP"

mkdir -p "$NGINX_DST" "$SYSTEMD_DST" "$ODOO_DST" "$SYSCTL_DST"

echo "Collecting nginx snapshots..."
sudo cp -a /etc/nginx/sites-available "$NGINX_DST/" 2>/dev/null || true
sudo cp -a /etc/nginx/conf.d "$NGINX_DST/" 2>/dev/null || true

echo "Collecting systemd unit snapshots..."
sudo cp -a /etc/systemd/system/odoo18.service "$SYSTEMD_DST/" 2>/dev/null || true
sudo cp -a /etc/systemd/system/odoo19.service "$SYSTEMD_DST/" 2>/dev/null || true

echo "Collecting odoo conf snapshots..."
sudo cp -a /opt/odoo/conf/odoo18.conf "$ODOO_DST/" 2>/dev/null || true
sudo cp -a /opt/odoo/conf/odoo19.conf "$ODOO_DST/" 2>/dev/null || true

echo "Collecting sysctl snapshot..."
sudo sysctl -a > "$SYSCTL_DST/sysctl-a.txt" 2>/dev/null || true

echo "Normalizing ownership to current user..."
sudo chown -R "$USER":"$USER" "$ROOT_DIR/snapshots"

echo "Snapshot collection complete."
echo "nginx:   $NGINX_DST"
echo "systemd: $SYSTEMD_DST"
echo "odoo:    $ODOO_DST"
echo "sysctl:  $SYSCTL_DST"
