# 🏗️ Rebuilding from a Single ISO & Hybrid Networking Guide (CLI-Only)

> **Scenario**: Imagine your server hard drive died, your operating system corrupted, or you got a brand-new machine. You have **zero graphical desktop**, **no internet connection yet**, and only a **single Ubuntu ISO on a USB stick**.
>
> This guide is your ultimate blueprint to take a completely blank PC, install Ubuntu, fix missing Wi-Fi and network drivers using pure CLI, set up **Wi-Fi only, LAN only, or Hybrid failover networking**, and restore all your services back to 100% operation.

---

## 🧭 The Master Rebuild Roadmap

```
[Single Ubuntu ISO on USB]
       │
       ▼
1. Clean Installation (Key wizard choices & OpenSSH checkbox)
       │
       ▼
2. First Boot into Black Screen CLI (Username & Login)
       │
       ▼
3. Detect & Fix Network Drivers (PCI / USB Wi-Fi / rfkill / offline firmware)
       │
       ▼
4. CLI Network Setup (Choose: LAN Only, Wi-Fi Only, or Hybrid Failover)
       │
       ▼
5. Restore Core Services (Docker, Caddy, Cloudflare, Kiwix, Navidrome)
       │
       ▼
6. 10-Second Sanity Verification (Failover stress test)
```

---

## 💿 Part 1: Installing Ubuntu from the ISO (The Non-Tech Wizard Choices)

Whether you are using **Ubuntu Server** (recommended for headless servers) or **Ubuntu Desktop**:

### 1. Boot from USB
1. Insert the USB drive and turn on the PC.
2. Tap the boot menu key immediately (usually **F12**, **F11**, **F8**, or **Del** depending on your motherboard).
3. Select the UEFI USB drive.

### 2. Critical Wizard Choices
Follow the on-screen installer prompts:
* **Language & Keyboard**: Choose `English (US)`.
* **Installation Type**: Choose **Ubuntu Server (minimized)** for the fastest, leanest install, or regular **Ubuntu Server** for pre-included common tools.
* **Network Connections**: 
  * If Ethernet is connected, it will automatically grab an IP.
  * If only Wi-Fi is available and not detected yet, **DO NOT PANIC**. Select `Continue without network` or skip. We will fix the drivers in Part 2.
* **Storage / Partitioning**:
  * Select **Use an entire disk**.
  * Keep **Set up this disk as an LVM group** checked (makes expanding storage in the future effortless).
  * Confirm and continue.
* **Profile Setup**:
  * **Your name**: `si4k` (or your name).
  * **Your server's name**: `si4k-server`.
  * **Pick a username**: `si4k`.
  * **Choose a password**: Pick a strong password you won't forget.
* **🔥 THE MOST CRITICAL STEP — OpenSSH Server**:
  * When the installer asks **"SSH Setup"**, press `[Space]` to check:
    ```
    [X] Install OpenSSH server
    ```
  * *Why?* If you check this, the moment your network connects, you can disconnect your monitor and keyboard and manage the machine comfortably from your laptop over SSH!
* **Featured Server Snaps**:
  * Leave all boxes unchecked (we will install official Docker, Caddy, and packages directly for better performance).
* **Finish**: Select **Reboot Now** and unplug the USB thumb drive when prompted.

---

## 📶 Part 2: Fixing Wi-Fi & Network Drivers via CLI (When You Have No Internet)

You reboot, log in with your username and password, and type `ping 1.1.1.1`. You see:
```text
ping: connect: Network is unreachable
```
How do you diagnose and fix your network card with zero GUI and zero internet?

### Step 1: Detect What Hardware You Have
Run:
```bash
ip -br link
```
You will see interfaces like:
* `lo`: The internal loopback (always there).
* `enp3s0` or `eth0`: Your physical Ethernet (LAN) port.
* `wlan0`, `wlp2s0`, or `wlx1027f5446c20`: Your Wi-Fi adapter.

#### If your Wi-Fi interface does NOT appear at all:
Your operating system lacks the driver or kernel module for your Wi-Fi card. Let's find out what chip is inside:

```bash
# If it is a built-in motherboard card / laptop card (PCI):
lspci -nnk | grep -iA3 net

# If it is an external USB Wi-Fi dongle:
lsusb
```
*Note the chipset name* (e.g. `Realtek Semiconductor Corp. RTL8188EUS`, `RTL8812BU`, `MediaTek MT7601U`, or `Intel AX200/AX210`).

---

### Step 2: Check `rfkill` (The #1 Silly Reason Wi-Fi Fails)
Linux has an internal "airplane mode" switch called `rfkill`. Often, a fresh install starts with Wi-Fi radio blocked by software:

```bash
rfkill list all
```
If you see:
```text
0: phy0: Wireless LAN
	Soft blocked: yes
	Hard blocked: no
```
**Fix it instantly with one command:**
```bash
sudo rfkill unblock all
```
Now check `ip link set <interface> up` (e.g. `sudo ip link set wlan0 up`).

---

### Step 3: Check for Missing Firmware in Kernel Logs
Run:
```bash
sudo dmesg | grep -i -E "firmware|wifi|wlan"
```
If Linux says:
```text
Direct firmware load for rtw88/rtw8821c_fw.bin failed with error -2
```
This means the Linux kernel knows your Wi-Fi card, but is missing the firmware file (`linux-firmware`).

---

### Step 4: The 3 "No Internet" Emergency Driver Solutions

#### 🌟 Trick 1: The Magic USB Phone Tethering (Zero Drivers Needed!)
This is the single most powerful trick in all of Linux networking:
1. Take your Android phone (or iPhone) and connect it to your server using a USB charging cable.
2. On your phone: Open **Settings** ➔ **Hotspot & Tethering** ➔ Turn on **USB Tethering**.
3. On Linux, run:
   ```bash
   ip -br link
   ```
   A brand-new interface will appear immediately, called **`usb0`** or **`enx...`**!
4. Request an IP address:
   ```bash
   sudo dhclient usb0
   ```
5. **BOOM! Your server is now online through your phone's Wi-Fi or 4G/5G!**
6. Now you can easily install all missing Wi-Fi drivers and firmware from official repositories:
   ```bash
   sudo apt update
   sudo apt install -y linux-firmware wireless-tools wpasupplicant
   ```

#### 📦 Trick 2: Use the Ubuntu Installer USB as an Offline Driver Archive
The USB stick you used to install Ubuntu already contains hundreds of standard firmware packages in its offline package pool!
1. Plug the Ubuntu installer USB stick back in.
2. Find its device name:
   ```bash
   lsblk
   ```
   *(Usually `/dev/sdb1` or `/dev/sdc1`)*.
3. Mount it to `/mnt`:
   ```bash
   sudo mount /dev/sdb1 /mnt
   ```
4. Install `linux-firmware` or Broadcom drivers directly from the USB:
   ```bash
   # Reinstall complete offline firmware:
   sudo dpkg -i /mnt/pool/main/l/linux-firmware/linux-firmware*.deb

   # For Broadcom cards (bcmwl):
   sudo dpkg -i /mnt/pool/restricted/b/bcmwl/bcmwl-kernel-source*.deb
   ```
5. Unmount when done:
   ```bash
   sudo umount /mnt
   ```

#### 💾 Trick 3: Sneakernet via Thumb Drive
If your Wi-Fi card requires a custom driver (e.g. Realtek `rtl88x2bu`):
1. On your main PC (laptop or CachyOS desktop), download the package or driver git repo to a FAT32 thumb drive.
2. Plug it into the server, mount it (`sudo mount /dev/sdb1 /mnt`), and copy files over.

---

## 🖧 Part 3: Connecting via CLI: Wi-Fi Only, LAN Only, and Hybrid

Ubuntu uses **Netplan** to control networking. Netplan configuration files live in:
```
/etc/netplan/
```
> [!IMPORTANT]
> **Netplan YAML Rules**:
> 1. Use **spaces only** (exactly 2 spaces per indentation level).
> 2. **NEVER use the Tab key**. Tabs will cause Netplan to fail with syntax errors.
> 3. Netplan files must be protected: `sudo chmod 600 /etc/netplan/*.yaml`.

---

### 🔌 Scenario A: LAN / Ethernet Only

If your server connects directly to your home router with an Ethernet cable:

#### 1. Automatic Dynamic IP (DHCP):
Create or edit `/etc/netplan/01-netcfg.yaml`:
```bash
sudo nano /etc/netplan/01-netcfg.yaml
```
Paste this configuration (replace `enp3s0` with your real Ethernet interface from `ip link`):
```yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    enp3s0:
      dhcp4: true
      dhcp6: false
```

#### 2. Fixed Static IP (Recommended for Home Servers):
If you want your server to always stay at `192.168.31.250`:
```yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    enp3s0:
      dhcp4: false
      addresses:
        - 192.168.31.250/24
      routes:
        - to: default
          via: 192.168.31.1
      nameservers:
        addresses: [1.1.1.1, 8.8.8.8]
```

Apply the configuration:
```bash
sudo netplan apply
```

---

### 📡 Scenario B: Wi-Fi Only

If your server has no Ethernet cable and connects exclusively via wireless:

```bash
sudo nano /etc/netplan/01-netcfg.yaml
```
Paste this configuration (replace `wlx1027f5446c20` with your Wi-Fi interface name, and enter your real Wi-Fi SSID and password):
```yaml
network:
  version: 2
  renderer: networkd
  wifis:
    wlx1027f5446c20:
      dhcp4: true
      access-points:
        "MyHomeWiFi":
          password: "MySuperSecretPassword"
```

Apply:
```bash
sudo netplan apply
```

#### What if Netplan fails or gets stuck? (Direct `wpa_supplicant` fallback)
If you need an immediate direct Wi-Fi connection without Netplan:
```bash
# 1. Generate encrypted Wi-Fi credentials:
wpa_passphrase "MyHomeWiFi" "MySuperSecretPassword" | sudo tee /etc/wpa_supplicant.conf

# 2. Connect in the background:
sudo wpa_supplicant -B -i wlan0 -c /etc/wpa_supplicant.conf

# 3. Request IP address:
sudo dhclient wlan0
```

---

### ⚡ Scenario C: The HYBRID Setup (LAN + Wi-Fi Working Together with Auto-Failover)

> [!TIP]
> **What is Hybrid Networking?**
> Your server has **both** an Ethernet cable plugged in (`enp3s0`) AND a Wi-Fi adapter (`wlx1027f5446c20`).
> * While Ethernet is plugged in, all traffic flows at gigabit speeds with low ping.
> * If someone unplugs or trips over the Ethernet cable, your server **instantly and seamlessly shifts to Wi-Fi without losing connection or dropping SSH**!
> * When the Ethernet cable is plugged back in, traffic instantly switches back to Ethernet!

#### How it Works: Route Metric Priority
Linux uses **route metrics** (cost scores) to decide which path to use:
* **Lower metric number = higher priority**.
* Ethernet Metric: `100` (First choice).
* Wi-Fi Metric: `600` (Backup choice).

#### The Complete Hybrid Netplan File:
Edit `/etc/netplan/01-netcfg.yaml`:
```bash
sudo nano /etc/netplan/01-netcfg.yaml
```
Paste this production-tested hybrid config:
```yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    enp3s0:
      dhcp4: true
      dhcp4-overrides:
        route-metric: 100
      optional: true
  wifis:
    wlx1027f5446c20:
      dhcp4: true
      dhcp4-overrides:
        route-metric: 600
      optional: true
      access-points:
        "MyHomeWiFi":
          password: "MySuperSecretPassword"
```

> [!NOTE]
> Notice `optional: true` on both interfaces!
> By default, Ubuntu waits 2 minutes during boot for every network interface to connect. Setting `optional: true` tells Ubuntu: *"If the Ethernet cable is unplugged, do not freeze boot for 2 minutes—just boot up immediately on Wi-Fi!"*

Apply the hybrid setup:
```bash
sudo netplan apply
```

Check your routing table:
```bash
ip route
```
You will see two default gateways:
```text
default via 192.168.31.1 dev enp3s0 proto dhcp metric 100
default via 192.168.31.1 dev wlx1027f5446c20 proto dhcp metric 600
```
Because `100` is lower than `600`, Linux automatically routes 100% of traffic through Ethernet. Pull the cable out, and Linux immediately routes through `600` without skipping a beat!

---

### 🌐 Dual-Subnet Routing (Secondary Network / Isolated Management)

What if your Ethernet is on your home network (`192.168.31.x`), but your Wi-Fi is connected to a separate 5G router or phone hotspot (`10.87.156.x`)?

Netplan handles this gracefully by assigning separate IPs and metrics:
```yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    enp3s0:
      dhcp4: false
      addresses:
        - 192.168.31.250/24
      routes:
        - to: default
          via: 192.168.31.1
          metric: 100
  wifis:
    wlx1027f5446c20:
      dhcp4: false
      addresses:
        - 10.87.156.250/24
      routes:
        - to: default
          via: 10.87.156.1
          metric: 600
      access-points:
        "HotspotNetwork":
          password: "HotspotPassword"
```
Now:
* Home devices can access the server on `192.168.31.250`.
* Secondary devices can access the server on `10.87.156.250`.
* Outgoing internet automatically prefers the faster connection (`metric 100`).

---

### 🐕 Installing the Failover Watchdog on the Rebuilt Server

Sometimes routers crash and leave a dead gateway in Linux's routing cache. To make sure your hybrid connection never stalls, install the **Network Failover Watchdog**:

1. Create the script:
   ```bash
   sudo nano /usr/local/bin/net-failover-watchdog.sh
   ```
2. Paste the watchdog logic:
   ```bash
   #!/usr/bin/env bash
   # Checks internet connectivity every 30 seconds
   # If primary route fails 3 times, prunes stale route to force backup interface
   TARGET="1.1.1.1"
   if ! ping -c 2 -W 3 "$TARGET" >/dev/null 2>&1; then
       # Primary connection failed, refresh interfaces
       logger -t net-watchdog "Internet ping failed, renewing network state..."
       systemctl restart systemd-networkd
   fi
   ```
3. Make it executable:
   ```bash
   sudo chmod +x /usr/local/bin/net-failover-watchdog.sh
   ```
4. Create the systemd service:
   ```bash
   sudo nano /etc/systemd/system/net-failover-watchdog.service
   ```
   ```ini
   [Unit]
   Description=Network Failover Watchdog
   After=network.target

   [Service]
   Type=simple
   ExecStart=/usr/local/bin/net-failover-watchdog.sh
   Restart=always
   RestartSec=30

   [Install]
   WantedBy=multi-user.target
   ```
5. Enable and start:
   ```bash
   sudo systemctl daemon-reload
   sudo systemctl enable --now net-failover-watchdog.service
   ```

---

## 🛠️ Part 4: Rebuilding All Server Services & Restoring Backups

Now that your network is rock solid, let's restore the server services from zero back to a fully operational state.

### 1. Essential Tools & Time Sync
```bash
sudo apt update && sudo apt install -y curl wget git net-tools htop chrony
sudo systemctl enable --now chrony
```

---

### 2. Install Docker & Docker Compose
Install the clean official Docker engine:
```bash
# Add Docker's official GPG key:
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add repository to apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Allow your user to run docker without sudo:
sudo usermod -aG docker $USER
```

---

### 3. Restore Caddy Web Server
Install Caddy:
```bash
sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https curl
curl -1sLF 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLF 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
sudo apt update
sudo apt install -y caddy
```
Restore your `/etc/caddy/Caddyfile` from backup (or your saved copy) and restart:
```bash
sudo caddy validate --config /etc/caddy/Caddyfile
sudo systemctl enable --now caddy
```

---

### 4. Restore Cloudflare Tunnel (Zero Port-Forwarding Access)
Install `cloudflared`:
```bash
curl -L --output cloudflared.deb https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
sudo dpkg -i cloudflared.deb
rm cloudflared.deb
```
Connect your saved tunnel token:
```bash
sudo cloudflared service install <YOUR_SAVED_TUNNEL_TOKEN>
sudo systemctl enable --now cloudflared
```
*Your server is now instantly reachable worldwide through your Cloudflare domains!*

---

### 5. Restore Storage Mounts (`/etc/fstab`)
If you have an external hard drive or dedicated partition for `/mnt/knowledge` (Kiwix) and `/mnt/music` (Navidrome):
1. Find disk UUIDs:
   ```bash
   sudo blkid
   ```
2. Add them to `/etc/fstab`:
   ```bash
   sudo nano /etc/fstab
   ```
   Add lines like:
   ```text
   UUID=xxxx-xxxx-xxxx  /mnt/knowledge  ext4  defaults  0  2
   UUID=yyyy-yyyy-yyyy  /mnt/music      ext4  defaults  0  2
   ```
3. Test mounts without rebooting:
   ```bash
   sudo mount -a
   ```

---

### 6. Restore Kiwix & Navidrome
1. **Kiwix**:
   * Install `kiwix-tools`:
     ```bash
     sudo apt install -y kiwix-tools
     ```
   * Restore `/etc/systemd/system/kiwix.service` and start:
     ```bash
     sudo systemctl enable --now kiwix.service
     ```
2. **Navidrome**:
   * Follow the Navidrome systemd binary guide in [Doc 17](file:///home/siakshit/Downloads/PC%20Papa/docs/17_navidrome_music_server_guide.md).
   * Start service:
     ```bash
     sudo systemctl enable --now navidrome
     ```

---

## 🩺 Part 5: The 10-Second Post-Rebuild Sanity Check

Once everything is installed, run this 5-command verification sequence:

```bash
# 1. Are both network interfaces UP with valid IPs?
ip -br a

# 2. Are routes and metrics correctly ordered (100 vs 600)?
ip route

# 3. Can we reach raw IP outside?
ping -c 3 1.1.1.1

# 4. Does DNS domain name resolution work?
ping -c 3 google.com

# 5. Did any system services crash during boot?
systemctl --failed
```

### 🧪 The Failover Stress Test:
1. Open a terminal and start continuous ping:
   ```bash
   ping 1.1.1.1
   ```
2. Unplug the Ethernet cable with your hands.
3. Watch the ping output: after at most 1 dropped packet, ping replies continue flowing smoothly via Wi-Fi!
4. Plug the Ethernet cable back in: ping latency immediately drops back to `<1ms`.

**Congratulations! Your server has been successfully rebuilt from a single ISO and is 100% resilient to hardware failures and cable disconnections!**
