# ODOO_MULTI_INSTANCE_SETUP

## Operational log (captured state as of 2026-02-15)

### Objective
Run Odoo 18 and Odoo 19 on one droplet behind Nginx with SSL and basic hardening.

### Implemented state
- Domains configured:
  - `odoo18.freezonermirror.online`
  - `odoo19.freezonermirror.online`
- Odoo backend ports:
  - Odoo18 HTTP `8018`, longpoll/websocket `8072`
  - Odoo19 HTTP `8019`, longpoll/websocket `8073`
- Systemd services:
  - `/etc/systemd/system/odoo18.service`
  - `/etc/systemd/system/odoo19.service`
- Odoo configs:
  - `/opt/odoo/conf/odoo18.conf`
  - `/opt/odoo/conf/odoo19.conf`
- Runtime model:
  - `ExecStart` uses virtualenv Python + `odoo-bin` + `-c <conf-file>`
- Nginx reverse proxy:
  - Upstreams to `8018` and `8019`
  - Websocket/longpoll routing to `8072` and `8073`
- TLS:
  - Certificates issued with `certbot --nginx`
  - Renewal validation: `certbot renew --dry-run` passes
- Security controls:
  - Block scanner/noise paths (`.git`, `.env`, swagger/api-docs/server-status)
  - Rate limit on `/web/login` and `/web/session/authenticate`
- Log management:
  - `/etc/logrotate.d/odoo` rotates `/opt/odoo/logs/*.log`
- Sysctl tuning:
  - `vm.swappiness=10`
  - `fs.file-max=2097152`
  - `net.core.somaxconn=4096`

## Baseline verification commands
```bash
sudo systemctl status odoo18 odoo19 nginx --no-pager
sudo ss -ltnp | grep -E ':8018|:8019|:8072|:8073|:443|:80'
sudo nginx -t
sudo certbot renew --dry-run
curl -Ik https://odoo18.freezonermirror.online
curl -Ik https://odoo19.freezonermirror.online
```

## Notes
- This file stores the current known-good operational baseline.
- Append future updates as dated sections below.

## Update log
### 2026-02-15
- Baseline documented and aligned to inventory + scripts in this repo.
