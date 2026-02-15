# droplet-odoo-multi

Terminal-first ops repository for a single DigitalOcean droplet running Odoo 18 and Odoo 19 behind Nginx + SSL.

## Operating model
- Primary control plane: SSH terminal commands.
- Allowed web checks only: verify Odoo UI loads and browser SSL lock is valid.
- Optional: VS Code Remote SSH for browsing/editing files, but all critical actions remain script/CLI based.

## Repo layout
- `docs/` architecture, access, operations, security, backup, troubleshooting.
- `runbooks/` step-by-step procedures for common operations and incidents.
- `inventory/` single source of truth for domains, ports, paths, and service names.
- `snapshots/` captured server configuration artifacts.
- `scripts/` idempotent operational scripts.
- `changes/` change history records.

## Quick start
```bash
cd droplet-odoo-multi
chmod +x scripts/*.sh
./scripts/status.sh
./scripts/verify_ports.sh
```

## Common workflows
```bash
# Validate and reload nginx safely
./scripts/nginx_test_reload.sh

# Test certbot renewal path
./scripts/certbot_dry_run.sh

# Capture current server config snapshots
./scripts/collect_snapshot.sh
```

## Planned expansions
- n8n install plan (without dashboard): `runbooks/RUNBOOK_N8N_INSTALL_NO_DASHBOARD.md`

## Script permissions
```bash
chmod +x scripts/status.sh \
  scripts/verify_ports.sh \
  scripts/tail_odoo18.sh \
  scripts/tail_odoo19.sh \
  scripts/nginx_test_reload.sh \
  scripts/certbot_dry_run.sh \
  scripts/collect_snapshot.sh
```

## Notes
- Never commit real secrets to this repository.
- Keep secret values only in `inventory/secrets.template.yml` as a local template, then copy to a private non-repo file on the server.
