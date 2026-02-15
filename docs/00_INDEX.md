# 00_INDEX

## Quick links
- Architecture: `docs/01_ARCHITECTURE.md`
- Access guide: `docs/02_ACCESS_GUIDE.md`
- Operations: `docs/03_OPERATIONS.md`
- Security baseline/backlog: `docs/04_SECURITY.md`
- Backup & restore: `docs/05_BACKUP_RESTORE.md`
- Troubleshooting: `docs/06_TROUBLESHOOTING.md`
- n8n install (no dashboard): `runbooks/RUNBOOK_N8N_INSTALL_NO_DASHBOARD.md`

## Endpoints
- Odoo 18: `https://odoo18.freezonermirror.online`
- Odoo 19: `https://odoo19.freezonermirror.online`

## Ports
- Odoo 18 HTTP: `8018`
- Odoo 18 longpoll/websocket: `8072`
- Odoo 19 HTTP: `8019`
- Odoo 19 longpoll/websocket: `8073`

## Service and config locations
- Systemd units:
  - `/etc/systemd/system/odoo18.service`
  - `/etc/systemd/system/odoo19.service`
- Odoo configs:
  - `/opt/odoo/conf/odoo18.conf`
  - `/opt/odoo/conf/odoo19.conf`
- Nginx config roots:
  - `/etc/nginx/sites-available`
  - `/etc/nginx/conf.d`
- Logrotate:
  - `/etc/logrotate.d/odoo`

## Daily checks (terminal-first)
```bash
./scripts/status.sh
./scripts/verify_ports.sh
sudo journalctl -u odoo18 -u odoo19 -n 80 --no-pager
sudo nginx -t
sudo certbot renew --dry-run
```

## Evidence storage
- Command outputs: `docs/logs-and-evidence/command-outputs/`
- Screenshots (UI/SSL lock checks only): `docs/logs-and-evidence/screenshots/`
