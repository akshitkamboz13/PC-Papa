# ☁️ Cloudflare Tunnels: Remote Access Without Port Forwarding

A **Cloudflare Tunnel (`cloudflared`)** is a secure, encrypted outbound tunnel that connects your home server directly to Cloudflare's global edge network.

It lets you access your home server (websites, dashboards, SSH, media) from **anywhere in the world on any device**, even if you have a dynamic IP, strict firewall, or Carrier-Grade NAT (CGNAT)!

---

## 🛡️ 1. Why Cloudflare Tunnels are a Superpower

### The Old Dangerous Way (Port Forwarding):
* You had to open Port 80, 443, or 22 on your home Wi-Fi router.
* Your home public IP address was exposed to everyone on the internet.
* Botnets, port scanners, and hackers could constantly attack your home router.
* If your ISP changed your home IP (BSNL, Airtel, Jio), your connection broke!

### The Cloudflare Tunnel Way (What Your Server Uses!):
```text
[Phone / Laptop Anywhere in World] 
          │
          ▼
   [Cloudflare Edge] (DDoS Protection & SSL)
          ▲
          │ (Encrypted Outbound Tunnel)
[si4k-server: cloudflared.service]
          │
          ├── Caddy (Port 80)
          ├── Kiwix (Port 8080)
          └── Navidrome (Port 4533)
```
* **Zero Open Ports**: Your router's firewall stays completely closed.
* **Hidden IP**: Nobody on the internet ever sees your home IP address.
* **Immune to Dynamic IPs**: Even if your router reboots and changes IP every hour, the tunnel automatically reconnects in 1 second!

---

## ⚙️ 2. How `cloudflared` is Configured on Your Server

On `si4k-server`, Cloudflare Tunnel runs as a systemd background service:

* **Service File**: `/etc/systemd/system/cloudflared.service`
* **Token Authentication File**: `/etc/cloudflared/token`
* **Command**:
  ```bash
  /usr/bin/cloudflared --no-autoupdate tunnel run --token-file /etc/cloudflared/token
  ```

---

## 🩺 3. How to Check Tunnel Health & Live Logs

If you ever wonder *"Is my tunnel connected to Cloudflare right now?"*, run these commands on `si4k-server`:

### Check if the daemon is active:
```bash
systemctl status cloudflared
```
*(Look for: `Active: active (running)`).*

### Stream live connection logs:
```bash
sudo journalctl -u cloudflared -f
```
**Healthy log lines look like this:**
```text
Registered tunnel connection connIndex=0 location=DEL
Registered tunnel connection connIndex=1 location=BOM
Connection established
```
*(Locations like `DEL` = Delhi, `BOM` = Mumbai indicate your server is connected to the nearest Cloudflare data center!).*

---

## 🛠️ 4. How to Fix Tunnel Issues

### Issue 1: "Tunnel is in a reconnect loop / disconnects"
* **Why**: Wi-Fi dropped or router changed IP.
* **The Fix**: Restart the tunnel daemon:
  ```bash
  sudo systemctl restart cloudflared
  ```

### Issue 2: "Authentication error / Invalid token"
* **Why**: The tunnel was deleted or recreated in the Cloudflare Zero Trust dashboard.
* **The Fix**:
  1. Go to your Cloudflare Zero Trust Dashboard $\rightarrow$ **Networks** $\rightarrow$ **Tunnels**.
  2. Copy the tunnel token.
  3. Update the token file on your server:
     ```bash
     echo "YOUR_NEW_TOKEN_HERE" | sudo tee /etc/cloudflared/token
     sudo systemctl restart cloudflared
     ```

---

## 🌐 5. How to Route a New Domain to a Local Port

Whenever you want to add a new public website (e.g. `music.yourdomain.com` $\rightarrow$ Navidrome):

1. Open **Cloudflare Zero Trust Dashboard** in your browser.
2. Go to **Networks** $\rightarrow$ **Tunnels** $\rightarrow$ Click your active tunnel $\rightarrow$ **Configure**.
3. Under **Public Hostname**, click **Add a public hostname**:
   * **Subdomain**: `music`
   * **Domain**: `yourdomain.com`
   * **Type**: `HTTP`
   * **URL**: `localhost:4533` (or `localhost:80` for Caddy)
4. Click **Save Hostname**.

Within 30 seconds, `https://music.yourdomain.com` will be live with a free SSL certificate worldwide!
