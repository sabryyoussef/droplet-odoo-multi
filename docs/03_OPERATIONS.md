# 03_OPERATIONS

## Daily operations
1. Check service health.
2. Verify listening ports.
3. Validate Nginx syntax.
4. Validate Certbot renewal path.
5. Review recent logs for warnings/errors.

```bash
./scripts/status.sh
./scripts/verify_ports.sh
sudo nginx -t
./scripts/certbot_dry_run.sh
sudo journalctl -u odoo18 -u odoo19 -n 120 --no-pager
```

## Safe config change flow
1. Snapshot current state: `./scripts/collect_snapshot.sh`
2. Edit config files.
3. Validate syntax (`nginx -t`, optional Odoo config sanity checks).
4. Reload or restart only required services.
5. Verify endpoints and logs.
6. Record change in `changes/`.

## Restart flow
```bash
sudo systemctl daemon-reload
sudo systemctl restart odoo18 odoo19
sudo systemctl reload nginx
./scripts/status.sh
```

## UI/SSL verification (allowed web usage)
- Open:
  - `https://odoo18.freezonermirror.online`
  - `https://odoo19.freezonermirror.online`
- Confirm page load and browser lock icon is valid.
