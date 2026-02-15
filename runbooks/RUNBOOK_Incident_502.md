# RUNBOOK_Incident_502

## Trigger
Public Odoo endpoint returns `502 Bad Gateway`.

## Immediate triage
```bash
./scripts/status.sh
./scripts/verify_ports.sh
sudo journalctl -u nginx -u odoo18 -u odoo19 -n 250 --no-pager
```

## Deep checks
```bash
sudo nginx -t
sudo nginx -T | grep -E 'upstream|server_name|8018|8019|8072|8073'
sudo systemctl status odoo18 odoo19 nginx --no-pager
```

## Recovery actions
1. Restart only failed backend service:
```bash
sudo systemctl restart odoo18
# or
sudo systemctl restart odoo19
```
2. If Nginx config changed recently, rollback from `snapshots/nginx`.
3. Reload Nginx:
```bash
sudo systemctl reload nginx
```
4. Validate endpoint:
```bash
curl -Ik https://odoo18.freezonermirror.online
curl -Ik https://odoo19.freezonermirror.online
```

## Closure
- Capture timeline, root cause, and corrective action in `changes/`.
