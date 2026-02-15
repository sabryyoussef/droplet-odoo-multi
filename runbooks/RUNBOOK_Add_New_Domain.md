# RUNBOOK_Add_New_Domain

## Purpose
Add a new domain/subdomain to an existing Odoo instance behind Nginx with TLS.

## Procedure
1. DNS
- Create/verify `A` record to droplet public IP.

2. Nginx server block update
- Add `server_name` for new domain in the proper vhost.
- Ensure proxy routing matches target Odoo and longpoll/websocket port.

3. Validate Nginx
```bash
sudo nginx -t
sudo systemctl reload nginx
```

4. Issue/expand certificate
```bash
sudo certbot --nginx -d NEW_DOMAIN
```

5. Validate
```bash
curl -Ik https://NEW_DOMAIN
sudo certbot renew --dry-run
```

## Rollback
- Remove failing `server_name` edits.
- Restore previous known-good Nginx config from `snapshots/nginx`.
- `sudo nginx -t && sudo systemctl reload nginx`.
