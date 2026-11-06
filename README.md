# 🚀 PC Papa — Linux System Optimization, Watchdogs & Non-Tech Guide

A complete, self-contained suite for system optimization, RAM saving, automated background watchdogs, and plain-English Linux guides for **CachyOS / Arch Linux** and **Debian / Ubuntu**.

---

## 🧭 Start Here

* 🌟 **New to Linux or non-technical?** Read **[`NON_TECH_BEGINNER_GUIDE.md`](file:///home/siakshit/Downloads/PC%20Papa/NON_TECH_BEGINNER_GUIDE.md)**!
* 🛠️ **Something broken or need a quick fix?** Check **[`REPAIR_AND_FIXES.md`](file:///home/siakshit/Downloads/PC%20Papa/REPAIR_AND_FIXES.md)**!
* 📊 **Deep technical details on RAM, ZRAM & Storage?** Read **[`GUIDE.md`](file:///home/siakshit/Downloads/PC%20Papa/GUIDE.md)**!
* 🩺 **Run 1-Click System Doctor**: `./fix-my-pc.sh`

---

## 📚 Complete Non-Tech Documentation Library (`docs/`)

1. **[`01_command_flags_dictionary.md`](file:///home/siakshit/Downloads/PC%20Papa/docs/01_command_flags_dictionary.md)**: Command anatomy, reading commands like sentences, and scary flags (`-rf`, `-y`, `-h`, `sudo`, `|`, `>`) decoded.
2. **[`02_how_watchdogs_work.md`](file:///home/siakshit/Downloads/PC%20Papa/docs/02_how_watchdogs_work.md)**: How automated watchdogs guard your RAM, how the 5-min database sleeper and 3-min Claude manager work, and how to tweak timeouts.
3. **[`03_arch_vs_debian_guide.md`](file:///home/siakshit/Downloads/PC%20Papa/docs/03_arch_vs_debian_guide.md)**: Side-by-side command translation (`pacman` vs `apt`), file paths, and service management.
4. **[`04_bash_scripting_basics.md`](file:///home/siakshit/Downloads/PC%20Papa/docs/04_bash_scripting_basics.md)**: How `.sh` scripts work, variables, if/else, permissions (`chmod +x`), and debugging (`bash -x`).
5. **[`05_python_cheatsheet.md`](file:///home/siakshit/Downloads/PC%20Papa/docs/05_python_cheatsheet.md)**: Virtual environments, fixing `externally-managed-environment`, using `uv`, and common error fixes.
6. **[`06_linux_filesystem_paths.md`](file:///home/siakshit/Downloads/PC%20Papa/docs/06_linux_filesystem_paths.md)**: The root tree `/`, home `~`, hidden dotfiles, paths (`./`, `../`), and permissions (`chmod`, `chown`).
7. **[`07_offline_survival_guide.md`](file:///home/siakshit/Downloads/PC%20Papa/docs/07_offline_survival_guide.md)**: The No-Internet No-AI Survival Bible: offline manuals (`man`, `apropos`), offline package cache reinstalls (`pacman -U`), crash flight recorders (`journalctl -b -1`), and offline hot-spots.
8. **[`08_appimage_and_portable_apps.md`](file:///home/siakshit/Downloads/PC%20Papa/docs/08_appimage_and_portable_apps.md)**: Portable apps on Linux, fixing `libfuse.so.2` errors with `--appimage-extract-and-run`, KDE menu integration, and Flatpaks offline.
9. **[`09_all_system_watchdogs_guide.md`](file:///home/siakshit/Downloads/PC%20Papa/docs/09_all_system_watchdogs_guide.md)**: Detailed breakdown and fixes for all 4 watchdogs on your system (`net-failover-watchdog`, `kuk-dashboard-watchdog`, `dev-services-sleeper`, `omniroute-manager`).
10. **[`10_reading_terminal_errors_and_warnings.md`](file:///home/siakshit/Downloads/PC%20Papa/docs/10_reading_terminal_errors_and_warnings.md)**: Decoding scary terminal errors, Warnings vs. Errors, the "Bottom-Up" rule, stack traces, and top 10 error solutions.
11. **[`11_ssh_guide_and_errors.md`](file:///home/siakshit/Downloads/PC%20Papa/docs/11_ssh_guide_and_errors.md)**: Complete guide to SSH, keys (`id_ed25519`), shortcuts, scp/rsync, and fixing SSH errors (`timed out`, `host key verification failed`).
12. **[`12_cli_wifi_and_networking_arch_debian.md`](file:///home/siakshit/Downloads/PC%20Papa/docs/12_cli_wifi_and_networking_arch_debian.md)**: Connecting to Wi-Fi and managing networks via CLI on Arch and Debian using `nmcli`, `iwctl`, and Netplan.
13. **[`13_managing_daemons_and_services.md`](file:///home/siakshit/Downloads/PC%20Papa/docs/13_managing_daemons_and_services.md)**: Controlling background services with `systemctl`, reading logs with `journalctl`, and the `si4k-server` architecture.
14. **[`14_caddy_reverse_proxy_guide.md`](file:///home/siakshit/Downloads/PC%20Papa/docs/14_caddy_reverse_proxy_guide.md)**: The Receptionist analogy, Caddyfile configuration, routing `/wiki*`, zero-downtime reloads (`systemctl reload caddy`), and error fixes.
15. **[`15_cloudflare_tunnels_guide.md`](file:///home/siakshit/Downloads/PC%20Papa/docs/15_cloudflare_tunnels_guide.md)**: Secure remote access without open ports or dynamic DNS, `cloudflared` daemon logs, and mapping custom domains.
16. **[`16_kiwix_offline_knowledge_server.md`](file:///home/siakshit/Downloads/PC%20Papa/docs/16_kiwix_offline_knowledge_server.md)**: Offline Wikipedia and ZIM reader, `library.xml` indexing with `kiwix-manage`, and troubleshooting.
17. **[`17_navidrome_music_server_guide.md`](file:///home/siakshit/Downloads/PC%20Papa/docs/17_navidrome_music_server_guide.md)**: Your self-hosted personal Spotify, music syncing with `rsync`, mobile streaming apps (Symfonium, Substreamer, Feishin).
18. **[`18_home_server_maintenance_and_backup.md`](file:///home/siakshit/Downloads/PC%20Papa/docs/18_home_server_maintenance_and_backup.md)**: 10-second server health check, safe update routines, time sync with `chrony`, and 1-click full server backup.
19. **[`19_rebuilding_from_iso_and_hybrid_networking.md`](file:///home/siakshit/Downloads/PC%20Papa/docs/19_rebuilding_from_iso_and_hybrid_networking.md)**: Rebuilding an entire server from a single Ubuntu ISO, fixing Wi-Fi drivers with CLI only (rfkill, phone tethering, offline USB pool), and setting up Wi-Fi, LAN, and Hybrid failover networking.
20. **[`20_gitlab_on_laptop_guide.md`](file:///home/siakshit/Downloads/PC%20Papa/docs/20_gitlab_on_laptop_guide.md)**: Running lightweight GitLab CE on an 8 GB laptop with on-demand controls (`gitlab start` / `stop` / `status` / `logs` / `password`), Puma tuning, and freed RAM when stopped.

---

## ⚡ Quick Start / Reinstall

```bash
cd ~/Downloads/PC\ Papa
./install.sh
```
To enable the 5-minute database & Docker sleeper timer:
```bash
sudo ~/.local/bin/setup-on-demand-services.sh
```
