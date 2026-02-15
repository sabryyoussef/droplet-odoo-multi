# 02_ACCESS_GUIDE

## Access modes
- Primary: SSH terminal access as an administrative user with sudo.
- Secondary: VS Code Remote SSH for file browsing/editing.
- Web browser: only for Odoo UI smoke check and SSL lock verification.

## SSH first-session checks
```bash
hostnamectl
whoami
id
sudo -v
```

## Service checks
```bash
sudo systemctl status odoo18 odoo19 nginx --no-pager
sudo journalctl -u odoo18 -u odoo19 -n 120 --no-pager
```

## Path checks
```bash
ls -l /etc/systemd/system/odoo18.service /etc/systemd/system/odoo19.service
ls -l /opt/odoo/conf/odoo18.conf /opt/odoo/conf/odoo19.conf
ls -l /etc/nginx/sites-available /etc/nginx/conf.d
```

## Principle of operation
- Run all changes as commands or scripts stored in this repo.
- Record every substantial change in `changes/`.
- Capture snapshots with `./scripts/collect_snapshot.sh` before and after risky changes.
