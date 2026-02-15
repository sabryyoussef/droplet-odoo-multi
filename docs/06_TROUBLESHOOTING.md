# 06_TROUBLESHOOTING

## 502 Bad Gateway diagnosis
1. Check backend services:
```bash
sudo systemctl status odoo18 odoo19 --no-pager
```
2. Confirm backend ports are listening:
```bash
./scripts/verify_ports.sh
```
3. Review Nginx + Odoo logs:
```bash
sudo journalctl -u nginx -u odoo18 -u odoo19 -n 200 --no-pager
```
4. Validate Nginx config and upstream targets:
```bash
sudo nginx -t
sudo nginx -T | grep -E '8018|8019|8072|8073|upstream|server_name'
```

## Port collision diagnosis
- Symptom: Odoo service fails to start; `Address already in use`.
```bash
sudo ss -ltnp | grep -E ':8018|:8019|:8072|:8073'
sudo lsof -iTCP -sTCP:LISTEN -P -n | grep -E '8018|8019|8072|8073'
sudo journalctl -u odoo18 -u odoo19 -n 200 --no-pager
```
- Resolution: stop conflicting process, correct config, restart target Odoo service.

## SSL renewal issues
1. Test renewal path:
```bash
./scripts/certbot_dry_run.sh
```
2. Inspect Certbot logs:
```bash
sudo journalctl -u certbot -n 200 --no-pager
sudo tail -n 200 /var/log/letsencrypt/letsencrypt.log
```
3. Validate domain DNS and Nginx server_name routing.
4. Re-run with verbose mode if needed:
```bash
sudo certbot renew --dry-run -v
```

## Websocket / longpoll issues
- Symptom: chat/notifications/live updates unstable while main UI loads.

Checks:
```bash
sudo nginx -T | grep -Ei 'websocket|upgrade|connection|8072|8073|longpoll'
./scripts/verify_ports.sh
sudo journalctl -u nginx -u odoo18 -u odoo19 -n 200 --no-pager
```

Expected:
- Odoo18 websocket/longpoll target reachable on `127.0.0.1:8072`.
- Odoo19 websocket/longpoll target reachable on `127.0.0.1:8073`.
- Nginx forwards `Upgrade` and `Connection` headers correctly.

## Fast rollback pattern
1. Restore last known-good files from `snapshots/`.
2. `sudo nginx -t`
3. `sudo systemctl restart odoo18 odoo19`
4. `sudo systemctl reload nginx`
5. Verify endpoints and logs.
