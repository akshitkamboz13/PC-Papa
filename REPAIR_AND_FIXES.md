# 🛠️ CachyOS & Arch Linux — Human Non-Tech Repair & Fix Manual

A plain-English, copy-paste troubleshooting guide for **CachyOS**, **Arch Linux**, **Docker/Composers**, **Desktop Compositor**, and the **PC Papa Watchdogs**.

Whenever anything feels broken, slow, stuck, or won't boot, find your problem in the table of contents below and paste the exact command to fix it.

---

## 📑 Table of Contents

1. [🚨 The 1-Click "Panic Button" (Fixes 80% of issues)](#1--the-1-click-panic-button-fixes-80-of-issues)
2. [📦 Package Manager & Update Fixes (Pacman, Yay, Paru)](#2--package-manager--update-fixes-pacman-yay-paru)
   * [Fix 1: "Database is locked" (error: failed to lock database)](#fix-1-database-is-locked-error-failed-to-lock-database)
   * [Fix 2: "Corrupted package / PGP signature error"](#fix-2-corrupted-package--pgp-signature-error)
   * [Fix 3: "Downloads are super slow or failing (404 errors)"](#fix-3-downloads-are-super-slow-or-failing-404-errors)
   * [Fix 4: "Truncated zstd input / download-XXXXXX errors"](#fix-4-truncated-zstd-input--download-xxxxxx-errors)
   * [Fix 5: "Conflicting packages / unresolvable dependencies"](#fix-5-conflicting-packages--unresolvable-dependencies)
3. [🐳 Docker & Container "Composers" Repair](#3--docker--container-composers-repair)
   * [Fix 1: "Port is already allocated" (e.g., port 5678 or 3000 busy)](#fix-1-port-is-already-allocated-eg-port-5678-or-3000-busy)
   * [Fix 2: Quick Cheat Sheet for Docker Compose](#fix-2-quick-cheat-sheet-for-docker-compose)
   * [Fix 3: Docker is eating too much disk space](#fix-3-docker-is-eating-too-much-disk-space)
   * [Fix 4: n8n container is not starting](#fix-4-n8n-container-is-not-starting)
4. [🖥️ Desktop, Screen & Compositor (KDE Plasma 6 / Wayland)](#4-️-desktop-screen--compositor-kde-plasma-6--wayland)
   * [Fix 1: Frozen desktop, taskbar disappeared, or black screen](#fix-1-frozen-desktop-taskbar-disappeared-or-black-screen)
   * [Fix 2: App is frozen or won't close](#fix-2-app-is-frozen-or-wont-close)
5. [🔊 Audio, Mic & Bluetooth Fixes (PipeWire)](#5--audio-mic--bluetooth-fixes-pipewire)
   * [Fix 1: No sound / Audio playing through wrong speakers](#fix-1-no-sound--audio-playing-through-wrong-speakers)
   * [Fix 2: Bluetooth headphones won't connect or sound choppy](#fix-2-bluetooth-headphones-wont-connect-or-sound-choppy)
6. [🌐 Internet, WiFi & DNS Fixes](#6--internet-wifi--dns-fixes)
   * [Fix 1: Wi-Fi connected but says "No Internet"](#fix-1-wi-fi-connected-but-says-no-internet)
   * [Fix 2: Websites won't load (DNS problem)](#fix-2-websites-wont-load-dns-problem)
7. [💾 Storage Emergency: Disk is 100% Full](#7--storage-emergency-disk-is-100-full)
8. [🔄 Boot Rescue: When an Update Breaks Your PC](#8--boot-rescue-when-an-update-breaks-your-pc)
9. [🐕 PC Papa Watchdog & Lifecycle Troubleshooting](#9--pc-papa-watchdog--lifecycle-troubleshooting)

---

## 1. 🚨 The 1-Click "Panic Button" (Fixes 80% of issues)

If your computer feels laggy, package updates fail, or disk space suddenly vanished, run the included **PC Papa Doctor**:

```bash
~/Downloads/PC\ Papa/fix-my-pc.sh
```

**What it automatically does for you:**
* Unlocks stuck pacman databases.
* Deletes broken/aborted package downloads.
* Cleans system logs older than 3 days.
* Cleans safe package and build caches (`paru`, `yay`, `pip`, `npm`).
* Checks for failed background services.
* Displays a clean health summary of your RAM and Disk.

---

## 2. 📦 Package Manager & Update Fixes (Pacman, Yay, Paru)

### Fix 1: "Database is locked" (error: failed to lock database)
* **Why it happens**: An update was interrupted, cancelled, or the terminal was closed while pacman was running.
* **The Fix**:
  ```bash
  sudo rm -f /var/lib/pacman/db.lck
  ```

---

### Fix 2: "Corrupted package / PGP signature error"
* **Why it happens**: Security keys used to verify packages expired or haven't updated yet.
* **The Fix**: Refresh both Arch and CachyOS security keyrings:
  ```bash
  sudo pacman -Sy archlinux-keyring cachyos-keyring
  sudo pacman -Syu
  ```

---

### Fix 3: "Downloads are super slow or failing (404 errors)"
* **Why it happens**: Your mirror servers are outdated or having server downtime.
* **The Fix**: Automatically test and rank the fastest mirrors for your location:
  ```bash
  sudo cachyos-rate-mirrors
  sudo pacman -Syyu
  ```

---

### Fix 4: "Truncated zstd input / download-XXXXXX errors"
* **Why it happens**: Package downloads were aborted in the middle of downloading.
* **The Fix**: Delete the broken temporary files:
  ```bash
  sudo rm -f /var/cache/pacman/pkg/download-* /var/cache/pacman/pkg/*.part
  ```

---

### Fix 5: "Conflicting packages / unresolvable dependencies"
* **Rule of thumb**:
  1. If pacman asks: `:: Replace package-A with package-B? [Y/n]` $\rightarrow$ Press **`y`** (Arch maintainers renamed or upgraded the package).
  2. If it complains about orphaned (leftover unused) packages, clean them safely with:
     ```bash
     sudo pacman -Rns $(pacman -Qtdq)
     ```
     *(If it returns "no targets specified", your system is already clean!)*

---

## 3. 🐳 Docker & Container "Composers" Repair

### Fix 1: "Port is already allocated" (e.g., port 5678 or 3000 busy)
* **Why it happens**: A background container or process didn't exit cleanly and is still holding the port.
* **The Fix**:
  ```bash
  # See what is using the port (e.g. port 5678):
  sudo fuser 5678/tcp

  # Kill whatever is holding port 5678:
  sudo fuser -k 5678/tcp

  # Or stop all running containers safely:
  docker stop $(docker ps -q)
  ```

---

### Fix 2: Quick Cheat Sheet for Docker Compose
When working on web apps or multi-container projects:
* **Start project in background**: `docker compose up -d`
* **Stop project**: `docker compose down`
* **Rebuild after making code changes**: `docker compose up -d --build`
* **View live logs**: `docker compose logs -f`
* **Check running containers**: `docker compose ps`

---

### Fix 3: Docker is eating too much disk space
* **The Fix**:
  ```bash
  # Safely delete unused images, stopped containers, and cache:
  docker system prune -a
  ```

---

### Fix 4: n8n container is not starting
* **The Fix**:
  ```bash
  # Check live error logs:
  n8n logs

  # Force a clean restart:
  n8n restart
  ```

---

## 4. 🖥️ Desktop, Screen & Compositor (KDE Plasma 6 / Wayland)

### Fix 1: Frozen desktop, taskbar disappeared, or black screen
* **Why it happens**: The Wayland display compositor or KDE Plasma shell crashed. You do **NOT** need to force power off your PC!
* **The Fix**:
  1. Press **`Alt + Space`** (KRunner search bar).
  2. Type **`konsole`** and press **Enter**.
  3. Run this command to cleanly restart the entire desktop interface:
     ```bash
     kquitapp6 plasmashell && kstart plasmashell
     ```
  *If KRunner doesn't open:* Press **`Ctrl + Alt + F3`** to drop into a text terminal, log in with your username & password, and run:
  ```bash
  systemctl --user restart plasma-plasmashell
  ```
  *(Press `Ctrl + Alt + F2` or `Ctrl + Alt + F1` to return to your desktop!)*

---

### Fix 2: App is frozen or won't close
* **The Fix**:
  * Press **`Ctrl + Alt + Esc`**: Your cursor turns into a skull/crosshair. Click the frozen window to instantly close it!
  * Or in terminal:
    ```bash
    killall -9 <app-name>
    # Example: killall -9 brave
    ```

---

## 5. 🔊 Audio, Mic & Bluetooth Fixes (PipeWire)

### Fix 1: No sound / Audio playing through wrong speakers
* **Why it happens**: PipeWire audio daemon got confused during a sleep/wake cycle or USB unplug.
* **The Fix**: Restart the audio engine (takes 1 second, zero reboot needed):
  ```bash
  systemctl --user restart pipewire pipewire-pulse wireplumber
  ```

---

### Fix 2: Bluetooth headphones won't connect or sound choppy
* **The Fix**:
  ```bash
  sudo systemctl restart bluetooth
  ```

---

## 6. 🌐 Internet, WiFi & DNS Fixes

### Fix 1: Wi-Fi connected but says "No Internet"
* **The Fix**: Restart the network connection manager:
  ```bash
  sudo systemctl restart NetworkManager
  ```

---

### Fix 2: Websites won't load (DNS problem)
* **The Fix**: Flush your DNS cache and restart the resolver:
  ```bash
  sudo resolvectl flush-caches
  sudo systemctl restart systemd-resolved
  ```

---

## 7. 💾 Storage Emergency: Disk is 100% Full

If your drive hits 100%, KDE Plasma won't be able to write session files and you might get locked out of logging in.

### Emergency Recovery Commands:
If you are locked out, press **`Ctrl + Alt + F3`**, log in, and run these in order:
```bash
# 1. Clean pacman package cache (frees 10–30 GB):
sudo rm -rf /var/cache/pacman/pkg/*

# 2. Shrink system logs to 100 MB:
sudo journalctl --vacuum-size=100M

# 3. Clean user cache:
rm -rf ~/.cache/*

# 4. Reboot:
sudo reboot
```

---

## 8. 🔄 Boot Rescue: When an Update Breaks Your PC

CachyOS includes an automatic snapshot system using **Btrfs** and **Snapper**.

If a bad system update ever prevents your PC from booting into the desktop:

1. **Reboot your computer**.
2. At the boot menu (GRUB or systemd-boot), you will see an entry named:
   * **`CachyOS Snapshots`** or **`Previous Snapshots`**.
3. Select the most recent working snapshot (e.g., from yesterday or 1 hour ago) and press Enter.
4. Your computer will boot into that exact working state as if nothing happened!
5. Once inside the desktop, open **CachyOS Hello** (or run `snapper-rollback`) to make that snapshot permanent.

> 💡 **Total Drive Failure or Starting Completely from Scratch?**
> If your hard drive completely died, or you want to rebuild an entire headless Ubuntu server from a single ISO on a USB stick with CLI-only Wi-Fi and hybrid networking, follow **[`19_rebuilding_from_iso_and_hybrid_networking.md`](file:///home/siakshit/Downloads/PC%20Papa/docs/19_rebuilding_from_iso_and_hybrid_networking.md)**.

---

## 9. 🐕 PC Papa Watchdog & Lifecycle Troubleshooting

### OmniRoute won't start when running Claude
* **Check status**:
  ```bash
  omniroute-manager status
  ```
* **If port 20128 is stuck**:
  ```bash
  # Kill any stale OmniRoute instances:
  pkill -f "omniroute.mjs"
  # Start fresh:
  omniroute-manager ensure-started
  ```

### Database sleeping too quickly or won't stay awake
* **Remember**: Databases auto-sleep after **5 minutes of 0 active connections**.
* If you are developing locally, starting your backend server (`npm run dev`, `python manage.py runserver`) opens an active connection pool. As long as that dev server is running, the database **will not sleep**.
* The 5-minute countdown only starts after you close your dev server.

### Manually wake up or sleep any service anytime:
```bash
# Start on demand:
sudo systemctl start docker postgresql mongodb ollama

# Stop manually:
sudo systemctl stop docker postgresql mongodb ollama
```
