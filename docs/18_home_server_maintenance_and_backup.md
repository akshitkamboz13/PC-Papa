# 🏰 Home Server Maintenance, Backups & Health Routine

Your home server (**`si4k-server.local`**) is running an optimized stack with Caddy, Cloudflare Tunnels, Kiwix, Navidrome, and Docker containers using **under 1 GB of RAM**.

This guide provides the simple, non-technical maintenance procedures to keep your server running 24/7 without crashes, storage leaks, or data loss.

---

## 🩺 1. The 10-Second Daily Server Health Check

Whenever you log in via SSH, run this single command line to see everything at a glance:

```bash
ssh si4k@si4k-server.local "uptime && free -h && df -h / /mnt/music /mnt/knowledge && systemctl --failed"
```

### What a Healthy Server Looks Like:
* **`load average`**: Should be below `1.0` (indicates CPU is calm and cool).
* **`Mem`**: Used should be around `~900 MB – 1.5 GB` (leaving 5+ GB available).
* **`Swap`**: Used should be `0 B`.
* **`df -h`**: Root drive `/` should have over **50+ GB free**.
* **`systemctl --failed`**: Should output `0 loaded units listed` (all background services are happy).

---

## 🔄 2. Safe Server Update Routine (Once Every 1–2 Months)

Your server runs Debian/Ubuntu. To keep security patches up to date without breaking your running services:

```bash
# 1. Update package lists:
sudo apt update

# 2. Upgrade installed packages safely:
sudo apt upgrade -y

# 3. Clean out old uninstalled packages:
sudo apt autoremove -y
sudo apt clean
```

---

## 🐳 3. Managing Docker Containers on the Server

Your server has **`si4k-search`** running in Docker on port `3000`:

```bash
# Check running containers:
docker ps

# View live logs of your search container:
docker logs -f si4k-search

# Restart container:
docker restart si4k-search

# Clean old dangling container build junk:
docker system prune -f
```

---

## ⏰ 4. Clock & Time Synchronization (`chrony`)

Your server runs **`chrony.service`** for microsecond-accurate timekeeping:

### Why time matters:
* Cloudflare Tunnels and HTTPS certificates **strictly reject connections** if your server's clock drifts by more than 30–60 seconds!
* To verify your server clock is in sync:
  ```bash
  chronyc tracking
  ```
  *(Look for: `Leap status: Normal`, `RMS offset: < 0.005 seconds`).*
* To force an immediate time sync:
  ```bash
  sudo chronyc makestep
  ```

---

## 💾 5. The 1-Click Server Backup Command

Your server's entire configuration (Caddy routes, Cloudflare tokens, Navidrome playlists, Kiwix index) is tiny (under 50 MB). 

Run this command from your main PC to back up all server configs into a clean timestamped `.tar.gz` archive on your computer:

```bash
mkdir -p ~/Downloads/Server_Backups
ssh si4k@si4k-server.local "sudo tar -czf - \
  /etc/caddy/Caddyfile \
  /etc/cloudflared/token \
  /etc/navidrome/navidrome.toml \
  /var/lib/navidrome/navidrome.db \
  /mnt/knowledge/Metadata/library.xml 2>/dev/null" > ~/Downloads/Server_Backups/si4k_server_backup_$(date +%F).tar.gz

echo "Backup saved to ~/Downloads/Server_Backups!"
```

---

## 🔄 6. Safe Remote Reboot & Recovery

If you ever need to reboot the server remotely:

```bash
# 1. Issue clean reboot:
sudo systemctl reboot
```
* Your SSH terminal will close.
* Wait **45 to 60 seconds**.
* Reconnect:
  ```bash
  ssh si4k@si4k-server.local
  ```
* Because all services (`caddy`, `cloudflared`, `kiwix`, `navidrome`, `docker`) are set to `systemctl enable`, they will automatically boot back up with zero manual intervention!
