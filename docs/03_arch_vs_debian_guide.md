# 🔄 Arch Linux vs. Debian/Ubuntu: The Side-by-Side Rosetta Stone

In the Linux world, almost all distributions belong to one of two major families:
1. **The Arch Family** (CachyOS, Arch Linux, EndeavourOS, Manjaro) $\rightarrow$ *Your current OS (CachyOS) is here!*
2. **The Debian Family** (Ubuntu, Debian, Linux Mint, Pop!_OS, Raspberry Pi OS).

If you read a tutorial on the internet written for Ubuntu, how do you translate it to CachyOS/Arch, or vice versa? This guide gives you the exact cheat sheet.

---

## 📦 1. Package Manager Command Translation Table

| What You Want to Do | **Arch / CachyOS Command** | **Debian / Ubuntu Command** |
| :--- | :--- | :--- |
| **Update the whole system** | `sudo pacman -Syu` *(or `yay` / `paru`)* | `sudo apt update && sudo apt upgrade -y` |
| **Install an app** | `sudo pacman -S <package>` | `sudo apt install <package>` |
| **Install community / AUR app** | `yay -S <package>` *(or `paru -S`)* | `sudo add-apt-repository <ppa>` or `.deb` / Flatpak |
| **Uninstall an app** | `sudo pacman -R <package>` | `sudo apt remove <package>` |
| **Uninstall app + its leftover junk** | `sudo pacman -Rns <package>` | `sudo apt purge --autoremove <package>` |
| **Search for an app** | `pacman -Ss <keyword>` | `apt search <keyword>` |
| **Clean package cache (Free space)**| `sudo paccache -r` | `sudo apt clean && sudo apt autoclean` |
| **Remove orphaned dependencies** | `sudo pacman -Rns $(pacman -Qtdq)` | `sudo apt autoremove` |

---

## 🗂️ 2. Where Files Live: Directory Comparison

| File / Purpose | **Arch / CachyOS Location** | **Debian / Ubuntu Location** |
| :--- | :--- | :--- |
| **Downloaded Package Cache** | `/var/cache/pacman/pkg/` | `/var/cache/apt/archives/` |
| **Server Mirrors List** | `/etc/pacman.d/mirrorlist` | `/etc/apt/sources.list` & `/etc/apt/sources.list.d/` |
| **Package Manager Config** | `/etc/pacman.conf` | `/etc/apt/apt.conf` |
| **Network Configuration** | `/etc/NetworkManager/` | `/etc/netplan/` or `/etc/network/interfaces` |
| **System Services** | `/etc/systemd/system/` | `/etc/systemd/system/` *(Identical!)* |
| **User Binaries in PATH** | `~/.local/bin/` | `~/.local/bin/` *(Identical!)* |

---

## ⚙️ 3. Service Management (`systemctl`): Identical on Both!

Because modern Linux distributions all use **systemd**, managing background services like Docker, PostgreSQL, and Bluetooth is **100% identical** across both Arch and Ubuntu!

| Action | Command (Both Arch & Ubuntu) |
| :--- | :--- |
| **Start a service right now** | `sudo systemctl start <service>` |
| **Stop a service right now** | `sudo systemctl stop <service>` |
| **Restart a service** | `sudo systemctl restart <service>` |
| **Check if it is running** | `sudo systemctl status <service>` |
| **Make it autostart on PC boot** | `sudo systemctl enable <service>` |
| **Stop it from autostarting on boot** | `sudo systemctl disable <service>` |
| **Reload systemd after editing a service**| `sudo systemctl daemon-reload` |

---

## 🛠️ 4. Installing Common Developer Stacks on Both

### Docker:
* **Arch / CachyOS**:
  ```bash
  sudo pacman -S docker docker-compose
  sudo systemctl enable --now docker.socket
  sudo usermod -aG docker $USER
  ```
* **Debian / Ubuntu**:
  ```bash
  sudo apt install -y docker.io docker-compose-v2
  sudo systemctl enable --now docker
  sudo usermod -aG docker $USER
  ```

---

### Python & Virtual Environments:
* **Arch / CachyOS**:
  ```bash
  sudo pacman -S python python-pip uv
  ```
* **Debian / Ubuntu**:
  ```bash
  sudo apt install -y python3 python3-pip python3-venv
  ```

---

### Node.js & NPM:
* **Arch / CachyOS**:
  ```bash
  sudo pacman -S nodejs npm
  ```
* **Debian / Ubuntu**:
  ```bash
  sudo apt install -y nodejs npm
  ```

---

## 💡 Summary
* Whenever an internet guide tells you to run `sudo apt install xyz`, you can almost always run `sudo pacman -S xyz` or `yay -S xyz` on CachyOS!
* Commands starting with `systemctl`, `docker`, `git`, `python`, `npm`, and `bash` work **identically** on every Linux system in the world.
