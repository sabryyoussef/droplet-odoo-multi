# checklist

## Daily
- [ ] `./scripts/status.sh`
- [ ] `./scripts/verify_ports.sh`
- [ ] `sudo nginx -t`
- [ ] `sudo journalctl -u odoo18 -u odoo19 -n 120 --no-pager`
- [ ] `curl -Ik https://odoo18.freezonermirror.online`
- [ ] `curl -Ik https://odoo19.freezonermirror.online`

## Weekly
- [ ] `./scripts/certbot_dry_run.sh`
- [ ] `./scripts/collect_snapshot.sh`
- [ ] Review `docs/04_SECURITY.md` backlog and update status.

## Before any config change
- [ ] `./scripts/collect_snapshot.sh`
- [ ] Create change record from `changes/TEMPLATE_change_record.md`
- [ ] Validate and reload/restart using runbook

## After any config change
- [ ] `./scripts/status.sh`
- [ ] `./scripts/verify_ports.sh`
- [ ] `sudo nginx -t`
- [ ] Endpoint checks for both domains
- [ ] Update `changes/` with results and rollback notes
