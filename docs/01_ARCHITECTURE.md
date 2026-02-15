# 01_ARCHITECTURE

## Topology
- Single DigitalOcean droplet hosts two Odoo instances.
- Nginx terminates TLS and reverse proxies each domain to its Odoo backend.
- Separate HTTP and longpoll/websocket ports per Odoo instance.

## Domain to backend mapping
- `odoo18.freezonermirror.online`
  - app upstream: `127.0.0.1:8018`
  - websocket/longpoll upstream: `127.0.0.1:8072`
- `odoo19.freezonermirror.online`
  - app upstream: `127.0.0.1:8019`
  - websocket/longpoll upstream: `127.0.0.1:8073`

## Process model
- `odoo18.service` runs Odoo 18 using venv Python + `odoo-bin -c /opt/odoo/conf/odoo18.conf`.
- `odoo19.service` runs Odoo 19 using venv Python + `odoo-bin -c /opt/odoo/conf/odoo19.conf`.
- Nginx handles external traffic on `:443` and proxies to local ports.

## TLS
- Certificates managed by Certbot (`--nginx`).
- Renewal verification via `certbot renew --dry-run`.

## Supporting controls
- Scanner path blocks (`.git`, `.env`, swagger/api-docs/server-status paths).
- Login/auth rate limiting on `/web/login` and `/web/session/authenticate`.
- Log rotation for `/opt/odoo/logs/*.log`.
- Sysctl tuning baseline:
  - `vm.swappiness=10`
  - `fs.file-max=2097152`
  - `net.core.somaxconn=4096`
