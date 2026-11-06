#!/usr/bin/env bash
# Master Installer for PC Papa Tools & Watchdogs

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="$HOME/.local/bin"
APPS_DIR="$HOME/.local/share/applications"
AUTOSTART_FILE="$HOME/.config/autostart/omniroute.desktop"

mkdir -p "$BIN_DIR" "$APPS_DIR"

echo "==> 1. Installing CLI utilities and watchdogs into $BIN_DIR..."
cp "$SCRIPT_DIR/scripts/n8n.sh" "$BIN_DIR/n8n"
cp "$SCRIPT_DIR/scripts/gitlab.sh" "$BIN_DIR/gitlab"
cp "$SCRIPT_DIR/scripts/omniroute-manager.sh" "$BIN_DIR/omniroute-manager"
cp "$SCRIPT_DIR/scripts/claude-cli.sh" "$BIN_DIR/claude-cli"
cp "$SCRIPT_DIR/scripts/claude-gui.sh" "$BIN_DIR/claude-gui"
cp "$SCRIPT_DIR/scripts/dev-services-sleeper.sh" "$BIN_DIR/dev-services-sleeper.sh"
cp "$SCRIPT_DIR/scripts/setup-on-demand-services.sh" "$BIN_DIR/setup-on-demand-services.sh"
cp "$SCRIPT_DIR/fix-my-pc.sh" "$BIN_DIR/fix-my-pc"

ln -sf "$BIN_DIR/claude-cli" "$BIN_DIR/claude"
chmod +x "$BIN_DIR"/*

echo "==> 2. Installing Claude GUI desktop application..."
cat << 'EOF' > "$APPS_DIR/claude-gui.desktop"
[Desktop Entry]
Name=Claude (GUI)
Comment=Claude AI with OmniRoute On-Demand
Exec=/home/siakshit/.local/bin/claude-gui
Icon=brave
Terminal=false
Type=Application
Categories=Development;Utility;
EOF

echo "==> 3. Disabling OmniRoute 24/7 Autostart..."
if [ -f "$AUTOSTART_FILE" ]; then
  sed -i 's/^Hidden=false/Hidden=true/' "$AUTOSTART_FILE" 2>/dev/null || true
  sed -i 's/^X-GNOME-Autostart-enabled=true/X-GNOME-Autostart-enabled=false/' "$AUTOSTART_FILE" 2>/dev/null || true
fi

echo ""
echo "=========================================================="
echo "  PC PAPA INSTALLATION COMPLETE!"
echo "=========================================================="
echo ""
echo "Next step: To enable the 5-minute system-wide service sleeper timer,"
echo "run the following command with sudo:"
echo ""
echo "  sudo $BIN_DIR/setup-on-demand-services.sh"
echo ""
echo "Commands now available in your terminal:"
echo "  • n8n start / stop / status / logs"
echo "  • gitlab start / stop / status / logs / password"
echo "  • claude-cli (or simply 'claude')"
echo "  • claude-gui"
echo "  • omniroute-manager status"
echo ""
