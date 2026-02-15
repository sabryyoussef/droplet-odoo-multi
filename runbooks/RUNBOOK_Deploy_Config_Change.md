# RUNBOOK_Deploy_Config_Change

## Purpose
Safely deploy configuration changes for Odoo/Nginx/systemd with validation and rollback readiness.

## Preconditions
- SSH access with sudo.
- Change documented in `changes/`.
- Maintenance window if impact expected.

## Procedure
1. Capture pre-change snapshot:
```bash
cd ~/droplet-odoo-multi
./scripts/collect_snapshot.sh
```
2. Apply configuration edits.
3. Validate syntax:
```bash
sudo nginx -t
```
4. Reload/restart as needed:
```bash
sudo systemctl daemon-reload
sudo systemctl restart odoo18 odoo19
sudo systemctl reload nginx
```
5. Run health checks:
```bash
./scripts/status.sh
./scripts/verify_ports.sh
curl -Ik https://odoo18.freezonermirror.online
curl -Ik https://odoo19.freezonermirror.online
```
6. Record results in `changes/YYYY-MM-DD_*.md`.

## Rollback
- Restore affected files from latest snapshot under `snapshots/`.
- Re-run validation and service reload/restart commands.
