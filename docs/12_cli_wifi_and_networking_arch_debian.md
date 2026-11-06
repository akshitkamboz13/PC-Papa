# 📶 CLI-Only Wi-Fi & Networking Guide (Arch & Debian/Ubuntu)

If you are stuck in a black-and-white text terminal without a graphical desktop, or you are managing a headless home server over SSH, how do you scan, connect to Wi-Fi, and manage networks using **only the command line**?

Here is the complete guide for both **Arch Linux / CachyOS** and **Debian / Ubuntu**.

---

## 🌟 1. The Universal Champion: `nmcli` (Works on BOTH Arch & Debian)

Almost all modern Linux distributions (CachyOS, Ubuntu, Arch, Fedora) use **NetworkManager**. Its official terminal tool is **`nmcli`** (NetworkManager Command Line Interface).

### 🔍 Step 1: Scan for Available Wi-Fi Networks
```bash
nmcli dev wifi list
```
*(Shows a table of all nearby Wi-Fi names (SSIDs), signal bars `▂▄▆█`, channels, and security types).*

### 🔗 Step 2: Connect to a Wi-Fi Network
```bash
nmcli dev wifi connect "MyHomeWiFi" password "MySecretPassword"
```
*(Replace `MyHomeWiFi` and `MySecretPassword` with your real network credentials. Within 2 seconds, you are connected and online!)*

### 🔒 Connecting to a Hidden Wi-Fi Network:
```bash
nmcli dev wifi connect "HiddenNetworkName" password "Password123" hidden yes
```

---

## 🎛️ 2. Everyday Wi-Fi Controls with `nmcli`

### Turn Wi-Fi Hardware Radio On / Off:
```bash
nmcli radio wifi off    # Airplane mode for Wi-Fi
nmcli radio wifi on     # Turn Wi-Fi back on
```

### See All Saved Wi-Fi Networks:
```bash
nmcli connection show
```

### Forget / Delete a Saved Wi-Fi Network:
```bash
nmcli connection delete "OldCoffeeShopWiFi"
```

### Disconnect from Current Wi-Fi:
```bash
nmcli dev disconnect wlan0
```

---

## ⚡ 3. Arch Linux Minimalist Tool: `iwctl` (`iwd`)

Some minimal Arch Linux installs use **`iwd`** instead of NetworkManager. Its interactive CLI is **`iwctl`**:

```bash
# 1. Start the interactive tool:
iwctl

# 2. Inside the [iwd]# prompt, scan for networks:
station wlan0 scan
station wlan0 get-networks

# 3. Connect to your Wi-Fi:
station wlan0 connect "MyHomeWiFi"
# (It will prompt you cleanly for the passphrase)

# 4. Exit back to regular bash:
exit
```

---

## 🐧 4. Debian / Ubuntu Server Tool: `netplan`

On Ubuntu Server and Debian, networks are often configured using YAML files located inside `/etc/netplan/`:

1. View your network file:
   ```bash
   cat /etc/netplan/*.yaml
   ```
2. A typical Wi-Fi configuration looks like this:
   ```yaml
   network:
     version: 2
     wifis:
       wlan0:
         dhcp4: true
         access-points:
           "MyHomeWiFi":
             password: "MySecretPassword"
   ```
3. Apply the changes immediately:
   ```bash
   sudo netplan apply
   ```

---

## 🩺 5. Diagnosing Network Issues via CLI

### 1. What is my IP address?
```bash
ip -br addr
# or:
ip a
```
* Look for `wlan0` (Wi-Fi) or `eth0` / `enp3s0` (Ethernet).
* Your local IP looks like `192.168.x.x` or `10.x.x.x`.

### 2. What is my router's IP? (Default Gateway)
```bash
ip route | grep default
```
*(Example: `default via 192.168.31.1 dev wlan0` $\rightarrow$ Your router is at `192.168.31.1`).*

### 3. Is my internet working? (The 2-Step Ping Test)
* **Step A: Test raw internet connectivity (by IP)**:
  ```bash
  ping -c 3 1.1.1.1
  ```
  *If this works:* Your internet wire/Wi-Fi is 100% fine.
* **Step B: Test domain name lookup (DNS)**:
  ```bash
  ping -c 3 google.com
  ```
  *If Step A works but Step B fails:* Your Wi-Fi is working, but your **DNS is broken**!

### How to fix broken DNS in 5 seconds:
```bash
sudo systemctl restart systemd-resolved
sudo resolvectl flush-caches
```

---

## 📱 6. Turn Your PC into an Instant Wi-Fi Hotspot via CLI

Need to share internet from your Ethernet to your phone, or create an offline local network?
```bash
# Create and start a hotspot named "MyHotspot" with password "12345678":
nmcli device wifi hotspot ssid "MyHotspot" password "12345678"

# Stop the hotspot:
nmcli connection down "Hotspot"
```
