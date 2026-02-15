# RUNBOOK_N8N_INSTALL_NO_DASHBOARD

## Scope
Install n8n on Ubuntu 24.04 with:
- Node.js 22
- n8n global npm install
- systemd service with memory limits
- Nginx reverse proxy on port `8080`
- UFW rules
- weekly SQLite backup cron

Explicitly excluded in this runbook:
- n8n DataTables dashboard on `3001`

## Pre-flight
```bash
hostnamectl
whoami
sudo -v
curl -4 ifconfig.me
```

## Step 1 - Update OS and install Node.js 22
```bash
sudo apt-get update && sudo apt-get upgrade -y
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt-get install -y nodejs nginx curl git jq openssl
```

Verify:
```bash
node --version
npm --version
```

## Step 2 - Install n8n globally
```bash
sudo npm install -g n8n
```

Verify:
```bash
n8n --version
which n8n
```

## Step 3 - Create n8n directories + env file
```bash
sudo mkdir -p /var/lib/n8n/data /var/lib/n8n/logs /etc/n8n
```

Generate secrets:
```bash
openssl rand -base64 24
openssl rand -hex 16
```

Create env file:
```bash
sudo tee /etc/n8n/n8n.env >/dev/null <<'EOF'
# N8N Environment Configuration

# Core Configuration
N8N_HOST=0.0.0.0
N8N_PORT=5678
N8N_PROTOCOL=http

# Security - Basic Auth
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=n8n_admin
N8N_BASIC_AUTH_PASSWORD=REPLACE_WITH_GENERATED_PASSWORD

# Webhooks - external URL that n8n uses for webhook callbacks
WEBHOOK_URL=http://165.22.54.172:8080/webhook/

# Data & Encryption
N8N_USER_FOLDER=/var/lib/n8n/data
N8N_ENCRYPTION_KEY=REPLACE_WITH_GENERATED_HEX_KEY
N8N_DATABASE_SQLITE_DATABASE=/var/lib/n8n/data/.n8n/database.sqlite

# Timezone
GENERIC_TIMEZONE=UTC
TZ=UTC

# Logging
N8N_LOG_LEVEL=info
N8N_LOG_OUTPUT=file
N8N_LOG_FILE_LOCATION=/var/lib/n8n/logs/n8n.log

# UI & Cookie settings
N8N_DISABLE_UI=false
N8N_SECURE_COOKIE=false

# Performance - use filesystem for binary data
N8N_DEFAULT_BINARY_DATA_MODE=filesystem
N8N_BINARY_DATA_TTL=24
EOF
```

Replace required placeholders in `/etc/n8n/n8n.env`:
- `REPLACE_WITH_GENERATED_PASSWORD`
- `REPLACE_WITH_GENERATED_HEX_KEY`

Secure file:
```bash
sudo chmod 600 /etc/n8n/n8n.env
```

## Step 4 - Create systemd service
```bash
sudo tee /etc/systemd/system/n8n.service >/dev/null <<'EOF'
[Unit]
Description=n8n - Workflow Automation Platform
Documentation=https://docs.n8n.io/
After=network.target

[Service]
Type=simple
User=root
Group=root
WorkingDirectory=/var/lib/n8n
EnvironmentFile=/etc/n8n/n8n.env
ExecStart=/usr/bin/node --max-old-space-size=1536 /usr/bin/n8n start
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal
SyslogIdentifier=n8n
MemoryMax=1.8G
MemoryHigh=1.6G
CPUQuota=200%
PrivateTmp=true
ProtectSystem=false
ProtectHome=false
ReadWritePaths=/var/lib/n8n
NoNewPrivileges=false
LimitNOFILE=65536
TimeoutStartSec=60

[Install]
WantedBy=multi-user.target
EOF
```

Enable service:
```bash
sudo systemctl daemon-reload
sudo systemctl enable n8n
```

## Step 5 - Nginx reverse proxy on 8080
```bash
sudo tee /etc/nginx/sites-available/n8n >/dev/null <<'EOF'
upstream n8n {
    server 127.0.0.1:5678;
}

server {
    listen 8080;
    server_name _;

    location / {
        proxy_pass http://n8n;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_read_timeout 7200s;
        proxy_send_timeout 7200s;
    }
}
EOF

sudo ln -sf /etc/nginx/sites-available/n8n /etc/nginx/sites-enabled/n8n
sudo nginx -t
sudo systemctl reload nginx
```

## Step 6 - UFW firewall
```bash
sudo ufw allow 22/tcp comment 'SSH'
sudo ufw allow 80/tcp comment 'HTTP Nginx'
sudo ufw allow 443/tcp comment 'HTTPS Nginx'
sudo ufw allow 8080/tcp comment 'n8n via Nginx'
sudo ufw allow 5678/tcp comment 'n8n direct'
```

Enable if needed:
```bash
sudo ufw --force enable
sudo ufw status
```

## Step 7 - Start and verify n8n
```bash
sudo systemctl start n8n
sudo systemctl status n8n --no-pager
sudo ss -tlnp | grep 5678
sudo ss -tlnp | grep 8080
curl -s http://127.0.0.1:5678/healthz
curl -s -o /dev/null -w "%{http_code}\n" http://127.0.0.1:8080/
```

Troubleshooting logs:
```bash
sudo journalctl -u n8n -f --no-pager -n 100
sudo tail -n 200 /var/lib/n8n/logs/n8n.log
```

## Step 8 - Create first owner in UI
Open:
- `http://165.22.54.172:8080/`

Use:
- Basic Auth user: `n8n_admin`
- Basic Auth password: value in `/etc/n8n/n8n.env`

Then create first n8n owner account in setup UI.

## Step 9 - Weekly backup cron
```bash
sudo mkdir -p /opt/scripts /opt/backups
sudo tee /opt/scripts/backup_n8n.sh >/dev/null <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

BACKUP_DIR="/opt/backups"
N8N_DB="/var/lib/n8n/data/.n8n/database.sqlite"
mkdir -p "$BACKUP_DIR"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

if [[ -f "$N8N_DB" ]]; then
  cp "$N8N_DB" "$BACKUP_DIR/n8n_${TIMESTAMP}.sqlite"
  find "$BACKUP_DIR" -name "n8n_*.sqlite" -mtime +7 -delete
  echo "n8n backup done: n8n_${TIMESTAMP}.sqlite"
else
  echo "n8n DB not found: $N8N_DB"
  exit 1
fi
EOF

sudo chmod +x /opt/scripts/backup_n8n.sh
( crontab -l 2>/dev/null; echo "0 3 * * 0 /opt/scripts/backup_n8n.sh >> /var/log/n8n-backup.log 2>&1" ) | crontab -
crontab -l | grep n8n
```

## Verification checklist
- [ ] `node --version` shows v22.x
- [ ] `n8n --version` works
- [ ] `/etc/n8n/n8n.env` exists and placeholders replaced
- [ ] `systemctl status n8n` shows active
- [ ] `ss -tlnp | grep 5678` shows n8n
- [ ] `nginx -t` passes
- [ ] `ss -tlnp | grep 8080` shows nginx
- [ ] `curl http://127.0.0.1:5678/healthz` returns `{"status":"ok"}`
- [ ] `http://165.22.54.172:8080/` loads in browser
- [ ] Owner account created
- [ ] `crontab -l | grep n8n` returns backup entry

## Explicit non-goal for now
Do not install `n8n-datatables` (`3001`) in this phase.
