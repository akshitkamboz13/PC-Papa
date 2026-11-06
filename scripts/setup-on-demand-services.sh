#!/usr/bin/env bash
# Installer for Dev Services On-Demand & 5-minute Auto-Shutdown

set -e

if [ "$EUID" -ne 0 ]; then
  echo "Please run this setup script with sudo:"
  echo "  sudo ./scripts/setup-on-demand-services.sh"
  exit 1
fi

echo "==> 1. Setting up Dev Services Idle Sleeper (5-minute auto-stop)..."

cat << 'EOF' > /etc/systemd/system/dev-services-sleeper.service
[Unit]
Description=Dev Services Auto Idle Sleeper
After=network.target

[Service]
Type=oneshot
ExecStart=/home/siakshit/.local/bin/dev-services-sleeper.sh
EOF

cat << 'EOF' > /etc/systemd/system/dev-services-sleeper.timer
[Unit]
Description=Run Dev Services Auto Idle Sleeper every minute

[Timer]
OnBootSec=1min
OnUnitActiveSec=1min
AccuracySec=10s

[Install]
WantedBy=timers.target
EOF

echo "==> 2. Setting up Docker on-demand socket activation..."
systemctl enable docker.socket
systemctl disable docker.service

echo "==> 3. Enabling Dev Services Idle Sleeper Timer..."
systemctl daemon-reload
systemctl enable --now dev-services-sleeper.timer

echo ""
echo "=== SETUP COMPLETE ==="
echo "• Docker is now socket-activated on demand."
echo "• Idle monitor runs every minute."
echo "• If Docker, Postgres, Mongo, or Ollama have 0 connections / 0 containers for 5 mins, they auto-stop."
echo "• Use 'n8n start' anytime to spin up Docker + n8n together."
