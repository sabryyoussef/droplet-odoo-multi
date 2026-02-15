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

## n8n implementation (no dashboard)
- [ ] Follow `runbooks/RUNBOOK_N8N_INSTALL_NO_DASHBOARD.md` Step 1-3
- [ ] Follow `runbooks/RUNBOOK_N8N_INSTALL_NO_DASHBOARD.md` Step 4-6
- [ ] Follow `runbooks/RUNBOOK_N8N_INSTALL_NO_DASHBOARD.md` Step 7-9
- [ ] Confirm `http://165.22.54.172:8080/` reachable and owner account created

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
