#!/usr/bin/env bash
# ==============================================================================
# PC Papa — 1-Click System Doctor & Self-Healing Repair Tool
# Designed for everyday humans to safely fix common Arch & CachyOS issues
# ==============================================================================

set -e

# Color helpers
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
CYAN="\033[1;36m"
RED="\033[1;31m"
RESET="\033[0m"

header() {
  echo -e "\n${CYAN}════════════════════════════════════════════════════════════════════════════${RESET}"
  echo -e " ${GREEN}🩺  PC PAPA DOCTOR:${RESET} $1"
  echo -e "${CYAN}════════════════════════════════════════════════════════════════════════════${RESET}\n"
}

step() {
  echo -e "${YELLOW}➜${RESET} $1..."
}

ok() {
  echo -e "  ${GREEN}✔${RESET} $1"
}

header "Starting System Health & Auto-Repair Routine"

# 1. Check and Remove Stuck Pacman Database Locks
step "Checking for stuck package manager locks"
if [ -f /var/lib/pacman/db.lck ]; then
  echo -e "  ${RED}⚠ Found stuck pacman lock file (/var/lib/pacman/db.lck)!${RESET}"
  echo "  Removing lock file so package updates can work again..."
  sudo rm -f /var/lib/pacman/db.lck
  ok "Pacman database unlocked!"
else
  ok "No stuck pacman lock found."
fi

# 2. Clean Corrupted Temporary Pacman Download Fragments
step "Cleaning corrupted or aborted download fragments"
sudo rm -f /var/cache/pacman/pkg/download-* /var/cache/pacman/pkg/*.part 2>/dev/null || true
ok "Corrupted package download fragments cleaned."

# 3. Clean Huge System Journal Logs (Limit to last 3 days)
step "Trimming old system logs (journalctl) to keep drive healthy"
sudo journalctl --vacuum-time=3d >/dev/null 2>&1 || true
ok "System logs vacuumed to 3 days."

# 4. Clean Safe Package Caches (Keep installed versions, delete junk)
step "Pruning old uninstalled packages from Pacman cache"
sudo paccache -r >/dev/null 2>&1 || true
ok "Pacman cache pruned."

# 5. Clean Paru and Yay Build Clones
step "Cleaning leftover AUR build clones (Paru/Yay)"
rm -rf ~/.cache/paru/clone/* 2>/dev/null || true
rm -rf ~/.cache/yay/* 2>/dev/null || true
ok "AUR build caches cleared."

# 6. Clean Python & npm Temporary Caches
step "Cleaning developer package caches (pip, uv, npm)"
uv cache clean >/dev/null 2>&1 || true
pip cache purge >/dev/null 2>&1 || true
npm cache clean --force >/dev/null 2>&1 || true
ok "Dev package caches cleaned."

# 7. Check for Failed System Services
header "Checking Background System Services"
FAILED_SERVICES=$(systemctl --failed --no-legend --no-pager | awk '{print $2}' || true)
if [ -n "$FAILED_SERVICES" ]; then
  echo -e "  ${RED}Notice: The following services have failed:${RESET}"
  echo "$FAILED_SERVICES"
  echo "  Tip: You can restart any service with: sudo systemctl restart <service-name>"
else
  ok "All core systemd background services are running normally!"
fi

# 8. Check Docker Status & Clean Stuck Dangling Resources
if command -v docker >/dev/null 2>&1 && systemctl is-active --quiet docker; then
  step "Docker is running: cleaning dangling stopped containers & unused networks"
  docker container prune -f >/dev/null 2>&1 || true
  docker network prune -f >/dev/null 2>&1 || true
  ok "Docker cleaned up."
fi

# 9. Final System Vital Signs
header "Current System Vital Signs"
echo -e "${CYAN}Disk Space Available:${RESET}"
df -h / | awk 'NR==2 {print "  Total: "$2" | Used: "$3" | Available: "$4" ("$5" used)"}'

echo ""
echo -e "${CYAN}Memory Status:${RESET}"
free -h | awk 'NR==1 {print "  "$1, $2, $3, $6} NR==2 {print "  RAM: Total: "$2" | Used: "$3" | Available: "$7} NR==3 {print "  Swap: Total: "$2" | Used: "$3" | Free: "$4}'

echo ""
echo -e "${CYAN}OmniRoute Lifecycle Watchdog:${RESET}"
if [ -f ~/.local/bin/omniroute-manager ]; then
  ~/.local/bin/omniroute-manager status | sed 's/^/  /'
fi

echo ""
echo -e "${GREEN}========================================================================${RESET}"
echo -e "${GREEN}  🎉 All checks and auto-repairs finished successfully!${RESET}"
echo -e "${GREEN}========================================================================${RESET}\n"
