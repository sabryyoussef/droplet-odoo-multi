# 04_SECURITY

## Current baseline
- TLS certificates installed via Certbot with Nginx integration.
- Scanner/noise path blocking in Nginx (`.git`, `.env`, swagger/api-docs/server-status patterns).
- Rate limiting applied to authentication endpoints:
  - `/web/login`
  - `/web/session/authenticate`
- Log rotation in place for `/opt/odoo/logs/*.log`.

## Validation commands
```bash
sudo nginx -t
sudo nginx -T | grep -Ei 'limit_req|server-status|swagger|\.git|\.env|api-docs'
sudo certbot certificates
sudo certbot renew --dry-run
```

## Hardening backlog (next actions)
1. Disable DB manager in Odoo where possible (`list_db = False` and related controls).
2. Restrict `/web/database/*` by allowlist IP or full block at Nginx.
3. Verify `proxy_mode = True` in both Odoo configs and validate forwarded headers behavior.
4. Enforce firewall strategy:
   - Public: `22`, `80`, `443` only.
   - Internal-only bind/deny external for `8018`, `8019`, `8072`, `8073`.
5. Optional Fail2ban:
   - Nginx auth path jail and/or Odoo log-based jail.

## Minimal firewall intent
- Odoo internal ports are not internet-exposed.
- Nginx remains the only public ingress for applications.
- SSH access restricted by trusted source IP where operationally feasible.
