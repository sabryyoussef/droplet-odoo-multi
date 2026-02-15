# 2026-02-15_plan_n8n_install_no_dashboard

## Metadata
- Date: 2026-02-15
- Change ID: CHG-2026-02-15-N8N-PLAN
- Operator: ops planning
- Environment: production droplet

## Summary
- Added implementation runbook for n8n installation on Ubuntu 24.04.
- Scope excludes DataTables dashboard (`3001`) in this phase.

## Added artifacts
- `runbooks/RUNBOOK_N8N_INSTALL_NO_DASHBOARD.md`
- Updated references in:
  - `README.md`
  - `docs/00_INDEX.md`
  - `inventory/checklist.md`

## Execution intent
- Execute runbook in phased checkpoints.
- Verify each phase before proceeding.
- Keep Odoo services unaffected during n8n rollout.

## Risk notes
- Port usage changes (`8080`, `5678`) must be validated against existing services.
- Basic auth and encryption key values must not be committed.

## Next action
- Start Step 1 from `runbooks/RUNBOOK_N8N_INSTALL_NO_DASHBOARD.md` when approved.
