# CHANGE RECORD TEMPLATE

## Metadata
- Date:
- Change ID:
- Operator:
- Environment: production droplet

## Summary
- What changed:
- Why changed:

## Scope
- Services impacted:
- Files impacted:

## Pre-checks
- [ ] Snapshot captured (`./scripts/collect_snapshot.sh`)
- [ ] Baseline status healthy (`./scripts/status.sh`)

## Execution steps
1.
2.
3.

## Validation
- [ ] `./scripts/status.sh`
- [ ] `./scripts/verify_ports.sh`
- [ ] `sudo nginx -t`
- [ ] Endpoint checks successful

## Result
- Outcome:
- Incident observed (if any):

## Rollback
- Trigger condition:
- Rollback steps:
- Rollback status:

## Follow-ups
- Action items:
- Owner:
- Due date:
