# 🌟 PC Papa: The Complete Beginner & Non-Tech Master Guide

Welcome to the **PC Papa** documentation center! If you are not a developer, Linux engineer, or tech guru, this guide was written specifically for you.

Linux is not difficult—it is just unfamiliar. Once you know what the symbols mean and where things live, it is actually simpler and more reliable than Windows or macOS.

---

## 🧭 Your Documentation Library

Explore the guides below based on what you want to understand or fix:

### 1. 🚩 [Command Flags & Symbols Dictionary](file:///home/siakshit/Downloads/PC%20Papa/docs/01_command_flags_dictionary.md)
* Learn how to read any Linux command like an English sentence.
* Understand scary flags: `-rf`, `-y`, `-h`, `-a`, `-v`, `--force`.
* Demystify symbols: `sudo`, pipes `|`, redirects `>`, and `>/dev/null 2>&1`.

### 2. 🐕 [How Watchdogs Work & How to Fix Them](file:///home/siakshit/Downloads/PC%20Papa/docs/02_how_watchdogs_work.md)
* The Night Security Guard analogy.
* How the **5-minute database & Docker sleeper** works.
* How the **3-minute OmniRoute & Claude lifecycle manager** works.
* How to customize the timeout (change 5 minutes to 15 minutes).
* What to do if a service or watchdog gets stuck.

### 3. 🔄 [Arch Linux vs. Debian/Ubuntu Rosetta Stone](file:///home/siakshit/Downloads/PC%20Papa/docs/03_arch_vs_debian_guide.md)
* Side-by-side command translation table (`pacman` vs `apt`).
* How to follow Ubuntu internet tutorials on CachyOS / Arch Linux.
* Where files and package caches live on both systems.
* How `systemctl` works identically across all modern Linux systems.

### 4. 📜 [Bash Scripting 101 for Absolute Beginners](file:///home/siakshit/Downloads/PC%20Papa/docs/04_bash_scripting_basics.md)
* What is a `.sh` script? (The kitchen recipe analogy).
* The shebang (`#!/usr/bin/env bash`).
* Storing variables, making if/else decisions, and capturing outputs.
* What `chmod +x` does and how to run scripts.
* The golden debugging trick: `bash -x script.sh`.

### 5. 🐍 [Python on Linux: The Human Guide](file:///home/siakshit/Downloads/PC%20Papa/docs/05_python_cheatsheet.md)
* Why virtual environments exist (the plastic sandbox analogy).
* How to fix the famous `error: externally-managed-environment`.
* Using `uv` (the ultra-fast modern Python tool).
* Common Python errors (`ModuleNotFoundError`, `SyntaxError`) and fixes.

### 6. 🗺️ [The Linux Filesystem Map: Where Everything Lives](file:///home/siakshit/Downloads/PC%20Papa/docs/06_linux_filesystem_paths.md)
* The master tree starting at `/` (root).
* The tilde `~` shortcut for your home folder.
* What hidden dotfiles (`.config`, `.cache`, `.local`) do.
* Absolute paths vs Relative paths (`./` and `../`).
* Permissions and ownership (`chmod` vs `chown`).

### 7. 📦 [AppImages, Flatpaks & Portable Apps](file:///home/siakshit/Downloads/PC%20Papa/docs/08_appimage_and_portable_apps.md)
* How to run `.AppImage` files and fix `libfuse.so.2` errors with `--appimage-extract-and-run`.
* Adding AppImages to your KDE desktop menu.
* Using Flatpaks and portable tarballs completely offline.

### 8. 🐕 [All Active Watchdogs on Your Machine](file:///home/siakshit/Downloads/PC%20Papa/docs/09_all_system_watchdogs_guide.md)
* Complete guide to all 4 watchdogs on your PC (`net-failover-watchdog`, `kuk-dashboard-watchdog`, `dev-services-sleeper`, `omniroute-manager`).
* How to check their logs, restart, or disable them.

### 9. 🏜️ [The Offline Linux Survival Bible (No Internet, No AI)](file:///home/siakshit/Downloads/PC%20Papa/docs/07_offline_survival_guide.md)
* How to diagnose and fix any Linux problem without internet or AI.
* Using the offline encyclopedia (`man`, `apropos`).
* Reinstalling and downgrading packages from offline cache (`/var/cache/pacman/pkg`).
* Reading crash flight recorder logs (`journalctl -b -1 -p err`).
* Offline local ad-hoc Wi-Fi hotspot and file sharing.

### 10. 🛑 [Reading Terminal Errors & Warnings (Without Panicking)](file:///home/siakshit/Downloads/PC%20Papa/docs/10_reading_terminal_errors_and_warnings.md)
* The difference between Warnings (safe to ignore) and Errors (must fix).
* The "Bottom-Up" rule: where to look in 100 lines of scary red text.
* The Top 10 most common Linux error messages decoded (`Permission denied`, `EADDRINUSE`, `ECONNREFUSED`, `No space left`).
* How to read a Stack Trace like a crime scene investigator.

### 11. 🔐 [SSH Complete Guide & Error Decoder](file:///home/siakshit/Downloads/PC%20Papa/docs/11_ssh_guide_and_errors.md)
* The Lock & Key analogy (`id_ed25519` vs `id_ed25519.pub`).
* Connecting by hostname (`si4k@si4k-server.local`) vs public IP.
* Fixing `Connection timed out`, `Host key verification failed`, and `Permissions are too open`.
* Instant file copying with `scp` and `rsync`.

### 12. 📶 [CLI-Only Wi-Fi & Networking Guide (Arch & Debian)](file:///home/siakshit/Downloads/PC%20Papa/docs/12_cli_wifi_and_networking_arch_debian.md)
* Scanning and connecting to Wi-Fi with `nmcli` (works on Arch & Ubuntu).
* Minimalist Arch Wi-Fi with `iwctl` (`iwd`).
* Testing connectivity with the 2-step ping test (raw IP vs DNS).
* Turning your PC into an instant Wi-Fi hotspot with `nmcli`.

### 13. ⚙️ [Managing Daemons & Background Services](file:///home/siakshit/Downloads/PC%20Papa/docs/13_managing_daemons_and_services.md)
* The Butler analogy: what is a daemon?
* Controlling services with `systemctl` (start, stop, restart, enable, disable).
* Reading live logs with `journalctl -u <service> -f`.
* Inside `si4k-server.local`: Caddy, Cloudflared tunnel, Kiwix, Navidrome, Docker.
* How to create your own systemd daemon in 3 minutes.

### 14. 🛡️ [Caddy Web Server & Reverse Proxy Guide](file:///home/siakshit/Downloads/PC%20Papa/docs/14_caddy_reverse_proxy_guide.md)
* The Hotel Receptionist analogy: what is a reverse proxy?
* Inside your server's Caddyfile (`si4k-server.local` routing `/wiki*` to port 8080).
* Adding new routes for music or search.
* Testing syntax (`caddy validate`) and reloading with zero downtime (`systemctl reload caddy`).

### 15. ☁️ [Cloudflare Tunnels: Remote Access Without Port Forwarding](file:///home/siakshit/Downloads/PC%20Papa/docs/15_cloudflare_tunnels_guide.md)
* How Cloudflare Tunnels connect your server securely to the world with zero open router ports.
* Why dynamic IPs no longer break your connection.
* Checking tunnel logs and fixing reconnect loops.
* How to point custom public domain names to local server ports.

### 16. 📚 [Kiwix: Offline Knowledge & Wikipedia Server](file:///home/siakshit/Downloads/PC%20Papa/docs/16_kiwix_offline_knowledge_server.md)
* Hosting offline Wikipedia, WikiHow, and GeeksforGeeks (`.zim` archives).
* How `kiwix.service` and `library.xml` work.
* How to add new `.zim` books with `kiwix-manage`.
* Rebuilding a corrupted XML index in 1 line.

### 17. 🎵 [Navidrome: Your Self-Hosted Personal Spotify](file:///home/siakshit/Downloads/PC%20Papa/docs/17_navidrome_music_server_guide.md)
* Navidrome architecture: `/mnt/music`, `/var/lib/navidrome`, and port `4533`.
* Adding music with `rsync` or `scp` and triggering scans.
* Best mobile & desktop apps (Symfonium, Substreamer, Feishin, Amperfy).
* Troubleshooting permissions and password resets.

### 18. 🏰 [Home Server Maintenance, Backups & Health Routine](file:///home/siakshit/Downloads/PC%20Papa/docs/18_home_server_maintenance_and_backup.md)
* The 10-second server health check command.
* Safe Debian/Ubuntu server update routine.
* Docker container maintenance (`si4k-search`).
* Timekeeping with `chrony` (and why time drift breaks SSL/tunnels).
* 1-Click remote backup command to save all server configs to your PC.

### 19. 🏗️ [Rebuilding from a Single ISO & Hybrid Networking Guide](file:///home/siakshit/Downloads/PC%20Papa/docs/19_rebuilding_from_iso_and_hybrid_networking.md)
* Step-by-step rebuild of an entire server from a single Ubuntu ISO on a USB stick.
* Fixing missing Wi-Fi and network drivers via pure CLI (detecting hardware, unblocking `rfkill`, USB phone tethering trick, offline installer pool).
* Setting up connections via **Wi-Fi only**, **LAN only**, and **Hybrid (Route Metric Failover & Dual Subnets)**.
* Restoring Docker, Caddy, Cloudflare tunnels, Kiwix, Navidrome, and watchdog scripts from zero.
* 10-second sanity verification and failover stress test.

### 20. 🛠️ [The Non-Tech Human Repair & Fix Manual](file:///home/siakshit/Downloads/PC%20Papa/REPAIR_AND_FIXES.md)
* Instant copy-paste fixes for:
  * "Database is locked" (`db.lck`).
  * "PGP signature / corrupted package" errors.
  * "Downloads are slow / 404 mirror errors".
  * Frozen desktop / disappearing taskbars (restart without rebooting).
  * Bluetooth won't connect / No sound in headphones.
  * Wi-Fi connected but "No Internet".
  * Docker "port already in use" errors.
  * What to do if an update breaks your PC (Boot into CachyOS Snapshots).

---

## 🚨 The 1-Click "Panic Button"

If anything feels sluggish, updates are failing, or disk space vanished, open your terminal and run:

```bash
~/Downloads/PC\ Papa/fix-my-pc.sh
```

It automatically unlocks databases, cleans temporary caches, limits log sizes, checks service health, and displays your system vitals!

---

## 🛡️ The 4 Golden Rules of Linux Safety

1. **Never use `sudo` inside your home folder (`~`)**: Regular user files never need administrator privileges. Only use `sudo` for system updates, package installations, and hardware configs.
2. **Never run `rm -rf /` or delete folders starting with `/` unless you know what it is**: Deleting files in your home folder is safe; deleting folders outside `/home` can break your system.
3. **If your desktop freezes, do NOT yank the power cord**: Press `Alt + Space`, open `konsole`, and run `kquitapp6 plasmashell && kstart plasmashell`. It restarts the screen in 2 seconds.
4. **CachyOS has automatic snapshots**: If a system update ever breaks something, reboot, select **CachyOS Snapshots** at the boot screen, and you are immediately back in business!
