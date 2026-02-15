# 2026-02-15_multi_instance_setup

## Metadata
- Date: 2026-02-15
- Change ID: CHG-2026-02-15-ODOO-MULTI-BASELINE
- Operator: documented baseline
- Environment: production droplet

## Summary
- Captured and standardized existing Odoo18 + Odoo19 multi-instance setup behind Nginx with SSL.
- Created terminal-first operations repository and runbooks.

## Scope
- Services impacted: `odoo18`, `odoo19`, `nginx`, `certbot`
- Configuration references:
  - `/etc/systemd/system/odoo18.service`
  - `/etc/systemd/system/odoo19.service`
  - `/opt/odoo/conf/odoo18.conf`
  - `/opt/odoo/conf/odoo19.conf`
  - `/etc/nginx/sites-available`
  - `/etc/nginx/conf.d`

## Baseline state confirmed
- Domains:
  - `odoo18.freezonermirror.online`
  - `odoo19.freezonermirror.online`
- Ports:
  - Odoo18 `8018` + `8072`
  - Odoo19 `8019` + `8073`
- SSL:
  - Certbot Nginx integration in place.
  - `certbot renew --dry-run` successful.
- Security:
  - Scanner path blocks and auth endpoint rate limits in place.

## Validation commands
```bash
./scripts/status.sh
./scripts/verify_ports.sh
sudo nginx -t
./scripts/certbot_dry_run.sh
```

## Result
- Outcome: successful baseline documentation and ops repo initialization.
- Follow-up: continue hardening backlog in `docs/04_SECURITY.md`.
