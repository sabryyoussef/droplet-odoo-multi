# 05_BACKUP_RESTORE

## Scope
This document covers filesystem/config backups for runtime continuity and recovery of reverse proxy/service configuration.

## What to back up
- Odoo configs: `/opt/odoo/conf/`
- Systemd units: `/etc/systemd/system/odoo18.service`, `/etc/systemd/system/odoo19.service`
- Nginx config: `/etc/nginx/sites-available`, `/etc/nginx/conf.d`
- TLS metadata as needed: `/etc/letsencrypt/` (root-only, secure handling)
- Odoo logs (short retention): `/opt/odoo/logs/`
- This ops repo itself (`droplet-odoo-multi`)

## Snapshot collection
```bash
./scripts/collect_snapshot.sh
```

## Restore principles
1. Restore config files from latest known-good snapshot.
2. Validate syntax before service restart:
   - `sudo nginx -t`
3. Restart only required services, then verify:
   - `sudo systemctl restart odoo18 odoo19`
   - `sudo systemctl reload nginx`
4. Validate endpoint reachability and logs.

## Post-restore validation
```bash
./scripts/status.sh
./scripts/verify_ports.sh
curl -Ik https://odoo18.freezonermirror.online
curl -Ik https://odoo19.freezonermirror.online
sudo journalctl -u nginx -u odoo18 -u odoo19 -n 120 --no-pager
```

## Backup cadence (minimum)
- Before every config change.
- Daily at low traffic period.
- Before package upgrades and cert renewals if manual intervention is planned.
