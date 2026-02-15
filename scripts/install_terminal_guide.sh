#!/usr/bin/env bash
set -euo pipefail

BANNER_FILE="/etc/profile.d/odoo_ops_guide.sh"

sudo tee "$BANNER_FILE" >/dev/null <<'EOF'
#!/usr/bin/env bash

if [[ $- == *i* ]]; then
  echo
  echo "============================================================"
  echo " ODOO DROPLET OPS GUIDE"
  echo "============================================================"
  echo " Repo:      /root/droplet-odoo-multi"
  echo " GitHub:    https://github.com/sabryyoussef/droplet-odoo-multi"
  echo " Odoo 18:   https://odoo18.freezonermirror.online"
  echo " Odoo 19:   https://odoo19.freezonermirror.online"
  echo
  echo " Quick Commands:"
  echo "   cd /root/droplet-odoo-multi"
  echo "   ./scripts/status.sh"
  echo "   ./scripts/verify_ports.sh"
  echo "   ./scripts/nginx_test_reload.sh"
  echo "   ./scripts/certbot_dry_run.sh"
  echo "   ./scripts/collect_snapshot.sh"
  echo
  echo " Key Docs:"
  echo "   docs/00_INDEX.md"
  echo "   docs/03_OPERATIONS.md"
  echo "   docs/06_TROUBLESHOOTING.md"
  echo "============================================================"
  echo
fi
EOF

sudo chmod 0644 "$BANNER_FILE"
echo "Installed terminal startup guide at $BANNER_FILE"
echo "Open a new SSH session (or run: source /etc/profile) to see it."
