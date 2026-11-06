# 🏜️ The Offline Linux Survival Bible (No Internet, No AI)

Imagine a scenario where **there is no internet and no AI available**. A package update broke a driver, a service won't start, or your PC freezes. 

How do you survive, diagnose, and fix your computer using **only what is already on your machine**?

Linux was specifically designed to be 100% self-sufficient offline. Here is the master survival handbook.

---

## 📚 1. The Built-In Offline Encyclopedia (The "man" System)

Linux stores thousands of pages of full official documentation right inside your hard drive. You do not need Google, StackOverflow, or ChatGPT.

### How to use the offline manual:
* **`man <command>`**: Opens the full instruction manual.
  * Example: `man pacman`, `man docker`, `man systemctl`.
  * **Navigation**:
    * Press **`Space`** to scroll down one page.
    * Press **`b`** to scroll up.
    * Type **`/keyword`** and press Enter to search inside the manual! Press **`n`** for next match.
    * Press **`q`** to quit.

### "I don't know the command name!" (`apropos`):
If you forget the name of a tool, ask Linux to search all offline manuals for a keyword:
```bash
# Find every offline tool related to "partition":
apropos partition

# Find every offline tool related to "network":
apropos network
```

### The Quick Summary (`--help` or `-h`):
For a fast cheat sheet without opening the manual:
```bash
docker --help
tar --help
```

---

## 📦 2. Reinstalling & Downgrading Packages Without Internet

If an update breaks your software while offline, how do you fix it without being able to download anything?

### On Arch / CachyOS:
Your computer keeps every package you have ever installed inside `/var/cache/pacman/pkg/`!
```bash
# 1. Search your offline cache for previous versions of a package:
ls -la /var/cache/pacman/pkg/linux*
ls -la /var/cache/pacman/pkg/mesa*

# 2. Reinstall or downgrade directly from your offline cache:
sudo pacman -U /var/cache/pacman/pkg/<package_name>.pkg.tar.zst
# Example:
# sudo pacman -U /var/cache/pacman/pkg/mesa-24.1.0-1-x86_64.pkg.tar.zst
```

### On Debian / Ubuntu:
Your offline package store lives in `/var/cache/apt/archives/`:
```bash
sudo dpkg -i /var/cache/apt/archives/<package_name>.deb
```

---

## 🔄 3. Emergency Boot & System Rollback (Zero Internet Needed)

If an update broke your PC and it won't even boot into the desktop:

### Method A: Btrfs Snapshots (CachyOS / Arch)
1. Turn on your PC.
2. At the boot menu, highlight **`CachyOS Snapshots`** and press Enter.
3. Pick a snapshot timestamped before the problem happened.
4. Your PC boots into that exact previous working state!
5. Once inside, open terminal and make it permanent:
   ```bash
   sudo snapper-rollback
   ```

### Method B: Recovery Terminal (TTY / Emergency Mode)
If your screen goes black or the desktop freezes:
1. Press **`Ctrl + Alt + F3`** (or `F4` / `F5`).
2. You will get a black text login screen.
3. Type your username, press Enter, type your password.
4. You now have full terminal access to repair files, inspect logs, or restart services!
5. When done, press **`Ctrl + Alt + F2`** (or `F1`) to return to your graphical desktop.

---

## 🔍 4. Diagnosing Why Your PC Crashed (Reading Offline Flight Recorder)

Linux records every boot and error to an offline flight recorder called **systemd journal**.

### Find out why your PC crashed on the last boot:
```bash
# Show errors from the PREVIOUS boot (before crash/reboot):
journalctl -b -1 -p err

# Show live system errors right now:
journalctl -p err -e
```
* `-b -1`: Boot minus 1 (the boot that just crashed).
* `-p err`: Show **only** Priority: Error (filters out harmless chatter).
* `-e`: Jump immediately to the end (most recent events).

### Check if your PC ran out of RAM (OOM Killer):
```bash
dmesg -T | grep -i oom
```
If your PC froze and closed an app, this command reveals if the Linux Out-Of-Memory killer sacrificed it to protect the operating system.

---

## 💾 5. Offline Hardware Health Diagnostics

### 1. Test Hard Drive Health (SMART Status):
```bash
# Check NVMe SSD health and wear level:
sudo nvme smart-log /dev/nvme0

# Or with smartctl:
sudo smartctl -H /dev/nvme0n1
```
*(Look for: `PASSED` or `percentage_used`).*

### 2. Check CPU Temperature & Overheating:
```bash
sensors
```
*(Shows CPU temperature in Celsius. If temperatures exceed 90°C–95°C, thermal throttling is slowing your PC down).*

### 3. Check Battery Health & Capacity:
```bash
upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -E "state|percentage|capacity"
```

---

## 📡 6. Offline Local Networking (File Sharing Without Internet)

If the global internet is completely down, you can still connect your PC directly to phones, laptops, or routers offline:

### Turn your PC into an Offline Wi-Fi Hotspot:
```bash
nmcli device wifi hotspot ssid "OfflineNetwork" password "12345678"
```
Any phone or laptop can now connect to your PC's Wi-Fi network to transfer files!

### Share files offline with python in 1 second:
Inside any folder you want to share:
```bash
python3 -m http.server 8000
```
Open a browser on any connected device and go to `http://<your-pc-ip>:8000` to download files directly!

---

## 💡 The Offline Survival Philosophy
1. **Do not panic**: Almost every problem on Linux leaves an exact footprint in `journalctl -p err`.
2. **Offline packages exist**: Your `/var/cache/` has previous versions of your software ready to reinstall with `pacman -U`.
3. **The manual is inside your machine**: `man <tool>` works forever, anywhere, without Wi-Fi.
