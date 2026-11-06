# 🛡️ Caddy Web Server & Reverse Proxy Guide

**Caddy** is an enterprise-grade, blazing-fast modern web server written in Go. 

Unlike traditional web servers (like Apache or Nginx) that require hundreds of lines of confusing XML or complex configuration, Caddy uses a human-readable **`Caddyfile`** and **automatically manages SSL certificates (HTTPS)** with zero manual configuration.

---

## 🔀 1. What is a "Reverse Proxy"? (The Hotel Receptionist Analogy)

Imagine you own a hotel with 4 specialized staff members:
* **Kiwix** (The Librarian) sits in Room 8080.
* **Navidrome** (The Musician) sits in Room 4533.
* **si4k-search** (The Detective) sits in Room 3000.

Guests do not want to memorize room numbers (`:8080`, `:4533`, `:3000`). They want to walk to the **Front Desk (Port 80/443)** and ask:
* *"Take me to the library"* $\rightarrow$ Receptionist routes them to Room 8080.
* *"Take me to the music"* $\rightarrow$ Receptionist routes them to Room 4533.

**Caddy is that Front Desk Receptionist!** It listens on port 80/443 and routes visitors to the right internal application behind the scenes.

---

## 📜 2. How Caddy is Set Up on Your Server (`si4k-server`)

On your server, Caddy's configuration file lives at:
```bash
/etc/caddy/Caddyfile
```

### Your Active Caddyfile Configuration:
```caddy
si4k-server.local {

    # 1. When someone visits /wiki, route them to Kiwix (port 8080):
    handle_path /wiki* {
        reverse_proxy localhost:8080
    }

    # 2. For everything else, show a welcome message:
    handle {
        respond "Welcome to Si4k Hub!" 200
    }
}
```

---

## 🛠️ 3. How to Add New Services to Caddy

Want to access **Navidrome Music** through Caddy as well?

1. Open the Caddyfile on your server:
   ```bash
   sudo nano /etc/caddy/Caddyfile
   ```
2. Add a new route inside the `si4k-server.local` block:
   ```caddy
   si4k-server.local {

       handle_path /wiki* {
           reverse_proxy localhost:8080
       }

       handle_path /music* {
           reverse_proxy localhost:4533
       }

       handle_path /search* {
           reverse_proxy localhost:3000
       }

       handle {
           respond "Welcome to Si4k Hub!" 200
       }
   }
   ```
3. Save and exit (`Ctrl + O`, `Enter`, `Ctrl + X`).

---

## 🧪 4. Testing & Reloading Caddy (Zero Downtime)

### Step 1: Validate Your Caddyfile (Check for Typos)
Always test your file before applying it so your server never crashes:
```bash
caddy validate --config /etc/caddy/Caddyfile
```
*(If it says `Valid configuration`, your syntax is 100% correct!)*

### Step 2: Reload Caddy (Without Dropping Connections)
Unlike other servers, you do not need to restart Caddy. You can reload it in 1 millisecond:
```bash
sudo systemctl reload caddy
```

---

## 🛑 5. Common Caddy Errors & Instant Fixes

### Error 1: `failed to obtain certificate` / `acme error`
* **Why it happens**: You put a real domain name (like `mysite.com`) in Caddyfile, but your router's port 80/443 is not open to the internet. Caddy cannot prove to Let's Encrypt that you own the domain.
* **The Fix**:
  * For local home network names (like `si4k-server.local`), Caddy automatically uses its internal trusted CA.
  * For public internet domains, use **Cloudflare Tunnels** (`cloudflared`) instead of exposing router ports!

---

### Error 2: `bind: address already in use` (Port 80 or 443 busy)
* **Why it happens**: Another web server (like Apache, Nginx, or a rogue Docker container) is already holding port 80.
* **The Fix**:
  ```bash
  # Find what is holding port 80:
  sudo fuser 80/tcp
  # Kill it so Caddy can bind to it:
  sudo fuser -k 80/tcp
  sudo systemctl restart caddy
  ```

---

### Error 3: `502 Bad Gateway`
* **What it means**: Caddy is running fine, but the app it is trying to forward to (e.g. Kiwix on port 8080) is stopped or crashed!
* **The Fix**: Check the backend service:
  ```bash
  systemctl status kiwix   # or navidrome, docker
  ```
