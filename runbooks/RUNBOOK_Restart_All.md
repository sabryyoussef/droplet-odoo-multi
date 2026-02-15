# RUNBOOK_Restart_All

## Purpose
Perform a coordinated restart of Odoo18, Odoo19, and Nginx.

## Commands
```bash
sudo systemctl daemon-reload
sudo systemctl restart odoo18
sudo systemctl restart odoo19
sudo systemctl reload nginx
```

## Validation
```bash
./scripts/status.sh
./scripts/verify_ports.sh
sudo journalctl -u odoo18 -u odoo19 -u nginx -n 120 --no-pager
curl -Ik https://odoo18.freezonermirror.online
curl -Ik https://odoo19.freezonermirror.online
```

## Rollback note
- If restart introduces outage, restore last known-good config from `snapshots/`, then repeat restart and validation.
