# ⚙️ Managing Daemons & Background Services (Arch & Debian)

In Linux, background applications that run quietly without opening a graphical window are called **Daemons** (or **Services**).

Whether you are running a web server, a database, an automated watchdog, or a music streamer, **`systemd`** is the master conductor that starts, monitors, and restarts them.

---

## 🎩 1. What is a Daemon? (The Butler Analogy)

Think of a daemon like a private butler in a hotel:
* You don't see the butler standing on the stage.
* The butler waits quietly in the back room until a bell rings (like an incoming web request or a timer).
* If the butler trips or faints, the hotel manager (`systemd`) immediately helps him back up and puts him back to work!

In Linux, daemon names often end in **`d`**:
* `sshd` = **SSH** **D**aemon
* `dockerd` = **Docker** **D**aemon
* `systemd` = **System** **D**aemon

---

## 🎛️ 2. The Universal Service Cheat Sheet (`systemctl`)

These commands work **identically** on Arch Linux, CachyOS, Debian, Ubuntu, and Fedora:

| What You Want to Do | The Command |
| :--- | :--- |
| **See all currently running services** | `systemctl list-units --type=service --state=running` |
| **Check if a specific service is alive** | `systemctl status <service>` |
| **Start a service right now** | `sudo systemctl start <service>` |
| **Stop a service right now** | `sudo systemctl stop <service>` |
| **Restart a service** | `sudo systemctl restart <service>` |
| **Make it autostart every time PC boots**| `sudo systemctl enable <service>` |
| **Stop it from autostarting on boot** | `sudo systemctl disable <service>` |
| **Start AND enable in one command** | `sudo systemctl enable --now <service>` |

---

## 📜 3. How to Read Live Service Logs (`journalctl`)

If a service fails or behaves weirdly, do not guess what happened—ask systemd to show you its diary:

```bash
# View the last 50 lines of logs for a service:
sudo journalctl -u <service-name> -n 50 --no-pager

# Stream logs live in real-time as they happen (like a ticker tape):
sudo journalctl -u <service-name> -f
# (Press Ctrl + C to exit)

# Show only ERROR logs for a service:
sudo journalctl -u <service-name> -p err
```

---

## 🏰 4. Real-World Case Study: What is Running on `si4k-server.local`?

When we inspected your home server (`si4k@si4k-server.local`), we discovered a beautifully optimized stack using **only 925 MB of RAM**! Here is what each running service does:

```text
                               Internet
                                  │
                       ┌──────────▼──────────┐
                       │ Cloudflare Tunnel   │  (cloudflared.service)
                       │ Secure remote access│
                       └──────────┬──────────┘
                                  │
                       ┌──────────▼──────────┐
                       │ Caddy Web Server    │  (caddy.service)
                       │ HTTPS Reverse Proxy │
                       └────┬────────────┬───┘
                            │            │
            ┌───────────────▼──┐      ┌──▼───────────────┐
            │ Navidrome Music  │      │ Kiwix ZIM Server │  (kiwix.service)
            │ Port 4533        │      │ Offline Wiki/Docs│
            └──────────────────┘      └──────────────────┘
```

1. **`caddy.service`**: Fast, modern web server and reverse proxy that automatically handles local SSL certificates.
2. **`cloudflared.service`**: Cloudflare Tunnel client. This is how you access your server from anywhere in the world **without needing a static public IP or open port 22 on your router**!
3. **`kiwix.service` & `kiwix-watcher.service`**: Offline knowledge engine. Hosts your offline WikiHow and GeeksforGeeks `.zim` archives over your local network.
4. **`navidrome.service`**: Your personal Spotify-like self-hosted music streaming server.
5. **`docker.service`**: Runs container `si4k-search` (healthy on port 3000).
6. **`ssh.service`**: Allows you to log in remotely from your PC.

---

## 🛠️ 5. How to Create Your Own Systemd Daemon in 3 Minutes

Want to make any script run automatically on boot as a background service?

### Step 1: Create a Service Unit File
```bash
sudo nano /etc/systemd/system/myservice.service
```

### Step 2: Paste this Template
```ini
[Unit]
Description=My Custom Background Tool
After=network.target

[Service]
Type=simple
User=siakshit
ExecStart=/home/siakshit/.local/bin/myscript.sh
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
```

### Step 3: Tell Systemd to Load It
```bash
# 1. Reload systemd so it notices your new file:
sudo systemctl daemon-reload

# 2. Start and enable it:
sudo systemctl enable --now myservice.service

# 3. Verify it is running:
systemctl status myservice.service
```

That's it! Your script is now an enterprise-grade Linux daemon with automatic crash recovery.
