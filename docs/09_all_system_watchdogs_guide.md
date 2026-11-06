# 🐕 All Active System Watchdogs on Your PC: The Master Fix Guide

Your PC has several custom automated background watchdogs actively monitoring networks, web dashboards, databases, and AI services.

This guide lists **every single watchdog running on your system**, what it does, why it exists, where its files live, and how to fix, restart, or disable it.

---

## 🗺️ Master Watchdog Registry

| Watchdog Name | Scope | What It Does | Status on Your PC |
| :--- | :--- | :--- | :--- |
| **`net-failover-watchdog`** | System (`systemd`) | Health-aware network interface failover daemon | 🟢 Active (Running) |
| **`kuk-dashboard-watchdog`** | User (`systemd --user`) | Opens university dashboard once per day | 🟢 Active (Scheduled Timer) |
| **`dev-services-sleeper`** | System (`systemd`) | Auto-stops Docker, Postgres, Mongo, Ollama after 5m idle | 🟢 Active (PC Papa) |
| **`omniroute-manager`** | User Session | Auto-starts & stops OmniRoute 3m after Claude exits | 🟢 Active (PC Papa) |
| **`net-watchdog.service`** | System (`systemd`) | Old/legacy network performance monitor | ⚪ Disabled / Inactive |

---

## 1. 🌐 `net-failover-watchdog.service` (Network Failover Daemon)

* **Source**: Developed by Akshit (`https://github.com/Akshitkamboz13/net-failover-watchdog`)
* **Unit File**: `/usr/lib/systemd/system/net-failover-watchdog.service`
* **Executable**: `bash /usr/bin/net-failover-watchdog`

### What it does:
Monitors network connectivity on interfaces like `wlan0` (Wi-Fi) and Ethernet. If a network connection hangs or has a broken default gateway, it automatically prunes stale routing table entries so your PC can switch to a working internet path without getting stuck.

### Common Signs & Diagnostic Commands:
* **Check live status**:
  ```bash
  systemctl status net-failover-watchdog
  ```
* **View live log activity**:
  ```bash
  sudo journalctl -u net-failover-watchdog -f
  ```
* **How to restart it if Wi-Fi gets stuck**:
  ```bash
  sudo systemctl restart net-failover-watchdog
  ```
* **How to stop / disable it**:
  ```bash
  sudo systemctl stop net-failover-watchdog
  sudo systemctl disable net-failover-watchdog
  ```

---

## 2. 🎓 `kuk-dashboard-watchdog` (Daily Dashboard Opener)

* **Unit Files**:
  * `~/.config/systemd/user/kuk-dashboard-watchdog.service`
  * `~/.config/systemd/user/kuk-dashboard-watchdog.timer`
* **Executable**: `~/.local/bin/kuk-dashboard-watchdog`
* **State File**: `~/.local/state/kuk-dashboard-watchdog/last-opened`

### What it does:
Checks once per day if the **KUK Online Dashboard** (`https://ol.kukonline.in/dashboard`) was opened. If today's date is not recorded in the state file, it automatically launches Brave Browser to the dashboard, and then writes today's date so it doesn't open again until tomorrow.

### How to Fix / Control It:
* **"It didn't open today, how do I trigger it?"**:
  Delete the state file and run it manually:
  ```bash
  rm -f ~/.local/state/kuk-dashboard-watchdog/last-opened
  ~/.local/bin/kuk-dashboard-watchdog
  ```
* **"It keeps opening when I don't want it to"**:
  Write today's date into the state file to tell it you are done for the day:
  ```bash
  date +%F > ~/.local/state/kuk-dashboard-watchdog/last-opened
  ```
* **How to disable it permanently**:
  ```bash
  systemctl --user stop kuk-dashboard-watchdog.timer
  systemctl --user disable kuk-dashboard-watchdog.timer
  ```

---

## 3. 🗄️ `dev-services-sleeper` (The 5-Minute Database & Docker Guard)

* **Created by**: PC Papa
* **Unit Files**:
  * `/etc/systemd/system/dev-services-sleeper.service`
  * `/etc/systemd/system/dev-services-sleeper.timer`
* **Executable**: `~/.local/bin/dev-services-sleeper.sh`
* **State Directory**: `/tmp/dev-services-idle/`

### What it does:
Runs every 60 seconds. Checks if Docker has 0 containers, Postgres has 0 connections, MongoDB has 0 connections, and Ollama has 0 models loaded. If any service is inactive for 5 consecutive checks (5 minutes), it runs `systemctl stop <service>` to return hundreds of megabytes of RAM to your system.

### How to Fix / Control It:
* **Check when it last ran**:
  ```bash
  systemctl list-timers dev-services-sleeper.timer
  ```
* **View the idle counters right now**:
  ```bash
  cat /tmp/dev-services-idle/*.idle
  ```
* **"I am running a local project, why did the database turn off?"**:
  * If your backend server (e.g. Node, Python) is running, its connection pool keeps the database awake.
  * If the database turned off, your backend server wasn't actively connected. Start the database manually with:
    ```bash
    sudo systemctl start postgresql mongodb docker
    ```
* **How to pause or disable this watchdog**:
  ```bash
  sudo systemctl stop dev-services-sleeper.timer
  sudo systemctl disable dev-services-sleeper.timer
  ```

---

## 4. 🤖 `omniroute-manager` (The 3-Minute Claude Lifecycle Controller)

* **Created by**: PC Papa
* **Executable**: `~/.local/bin/omniroute-manager`
* **Session Directory**: `/tmp/omniroute-sessions/`
* **Timer PID File**: `/tmp/omniroute-timer.pid`

### What it does:
Wraps `claude-cli` (and `claude`) and `claude-gui`. When you start Claude, it boots OmniRoute in the background on port `20128`. When all Claude windows and terminals are closed, it starts a 3-minute sleep timer. If you don't reopen Claude within 3 minutes, it stops OmniRoute to free ~650 MB of memory.

### How to Fix / Control It:
* **Check watchdog status**:
  ```bash
  omniroute-manager status
  ```
* **Force kill OmniRoute immediately**:
  ```bash
  omniroute-manager stop
  # Or force-kill:
  pkill -9 -f "omniroute.mjs"
  ```
* **Reset all sessions if stuck**:
  ```bash
  rm -f /tmp/omniroute-timer.pid /tmp/omniroute-sessions/*
  ```

---

## 5. ⚪ `net-watchdog.service` (Inactive Legacy Service)

* **Location**: `/etc/systemd/system/net-watchdog.service`
* **Status**: Inactive / Disabled.
* **Note**: This was an earlier prototype network watchdog that was replaced by `net-failover-watchdog.service`. It is safely disabled and consumes 0 resources.

---

## 💡 Summary: One Master Command to Check All Watchdogs

Copy and paste this one line in your terminal to view the health of all 4 watchdogs at once:

```bash
echo "=== SYSTEM WATCHDOGS ===" && systemctl status net-failover-watchdog dev-services-sleeper.timer --no-pager | grep -E "●|○|Active:" && echo "=== USER WATCHDOGS ===" && systemctl --user status kuk-dashboard-watchdog.timer --no-pager | grep -E "●|○|Active:" && ~/.local/bin/omniroute-manager status
```
