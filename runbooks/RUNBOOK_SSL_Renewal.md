# RUNBOOK_SSL_Renewal

## Purpose
Validate and maintain TLS certificate renewals for both Odoo domains.

## Dry-run validation
```bash
./scripts/certbot_dry_run.sh
```

## Inspect certificate state
```bash
sudo certbot certificates
```

## If renewal fails
1. Check Nginx syntax and reload state:
```bash
sudo nginx -t
sudo systemctl status nginx --no-pager
```
2. Check Certbot logs:
```bash
sudo tail -n 200 /var/log/letsencrypt/letsencrypt.log
sudo journalctl -u certbot -n 200 --no-pager
```
3. Verify DNS points to current droplet and server blocks match domains.
4. Retry dry run:
```bash
sudo certbot renew --dry-run -v
```

## Post-renew verification
```bash
curl -Ik https://odoo18.freezonermirror.online
curl -Ik https://odoo19.freezonermirror.online
```
- Confirm browser lock icon for both domains.
