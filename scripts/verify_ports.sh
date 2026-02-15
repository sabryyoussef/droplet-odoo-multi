#!/usr/bin/env bash
set -euo pipefail

required_ports=(8018 8072 8019 8073 80 443)

echo "== Listening ports (filtered) =="
sudo ss -ltnp | awk 'NR==1 || /:8018|:8072|:8019|:8073|:80 |:443 / {print}'

echo
echo "== Port presence checks =="
for port in "${required_ports[@]}"; do
  if sudo ss -ltn | grep -q ":${port} "; then
    echo "[OK] port ${port} is listening"
  else
    echo "[WARN] port ${port} is NOT listening"
  fi
done
