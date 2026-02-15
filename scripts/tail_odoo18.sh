#!/usr/bin/env bash
set -euo pipefail

LOG_FILE="/opt/odoo/logs/odoo18.log"

if [[ ! -f "$LOG_FILE" ]]; then
  echo "Log file not found: $LOG_FILE" >&2
  exit 1
fi

echo "Tailing $LOG_FILE"
sudo tail -n 200 -f "$LOG_FILE"
