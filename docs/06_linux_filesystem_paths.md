# 🗺️ The Linux Filesystem Map: Where Everything Lives

In Windows, your hard drive is split into lettered drives like `C:\` and `D:\`.

In Linux, **everything starts from a single master root tree**, written simply as a forward slash: **`/`**.

Every single hard drive, USB flash drive, file, folder, and running process branches out from that single `/`. Here is the complete map decoded in plain English.

---

## 🌳 1. The Master Tree Breakdown

```text
/ (Root Directory)
├── home/          🏠 Where human users live (/home/siakshit)
├── etc/           ⚙️ System settings and configuration files
├── var/           📊 Variable data (system logs, databases, package caches)
├── opt/           🏢 Large standalone third-party apps (Chrome, Resolve, CUDA)
├── usr/           🧰 Operating system software, libraries, and desktop apps
├── tmp/           🗑️ Temporary scratchpad (emptied every reboot!)
├── run/           ⚡ Fast in-memory temporary runtime sockets & locks
└── boot/          🚀 Linux kernel & EFI startup files
```

---

## 🏠 2. Your Home Folder: `~` (Tilde)

In Linux, the tilde character **`~`** is a universal shortcut for **your personal home directory**:
* On your machine: `~` = `/home/siakshit`
* `~/Downloads` = `/home/siakshit/Downloads`
* `~/Desktop` = `/home/siakshit/Desktop`

### The Golden Rule of Safety:
* You have full permission to create, delete, and edit files inside `~` without `sudo`.
* Anything **outside** `~` (like `/etc/` or `/var/` or `/usr/`) belongs to the operating system. Modifying those requires `sudo` because an accidental mistake can affect the whole system.

---

## 🕵️ 3. What Are "Hidden" Dotfiles? (e.g. `.config`, `.cache`)

If a file or folder name starts with a period (`.`), Linux makes it **invisible by default**:
* In terminal: `ls` hides them. `ls -a` reveals them.
* In Dolphin file manager: Press **`Ctrl + H`** to toggle showing hidden files.

### The Big Three Hidden Folders:
1. **`~/.config/`**: Where applications save your settings, preferences, and window layouts.
2. **`~/.cache/`**: Temporary downloaded files, thumbnails, and build cache. If you delete files here, apps will simply recreate them when needed.
3. **`~/.local/`**:
   * `~/.local/bin/`: Your personal command bin! Any script placed here can be run by name from the terminal.
   * `~/.local/share/Trash/`: Your Recycle Bin / Trash can.
   * `~/.local/share/applications/`: Desktop launcher icons (`.desktop` files) for your app menu.

---

## 📍 4. Absolute Paths vs. Relative Paths

### Absolute Paths (Starts with `/`):
Like giving someone a full postal address with Country, State, Street, and House Number:
* Example: `/home/siakshit/Downloads/PC Papa/fix-my-pc.sh`
* Works from **anywhere**, no matter which folder you are currently sitting in.

### Relative Paths (Starts with `./` or `../` or a name):
Like giving directions based on where you are standing right now:
* **`.` (Current folder)**: `./fix-my-pc.sh` means *"run the script sitting right here beside me"*.
* **`..` (Parent folder / One step up)**: `cd ..` means *"go up one folder"*.
* **`../..` (Two steps up)**: Go up two folder levels.

---

## 🔐 5. Permissions & Ownership: `chmod` vs. `chown`

Every file in Linux has an **Owner** and **Permissions**:

### 1. Ownership (`chown`):
Who owns this file?
```bash
# If a file was accidentally created by root with sudo, reclaim ownership:
sudo chown -R $USER:$USER /home/siakshit/my-folder
```
* `$USER` automatically fills in your current username (`siakshit`).

### 2. Permissions (`chmod`):
What can be done with this file?
* **Read (`r`)**: Open and view contents.
* **Write (`w`)**: Edit, change, or delete.
* **Execute (`x`)**: Run it as an application or script.

```bash
# Make a script executable:
chmod +x my_script.sh

# Remove execution permission:
chmod -x my_script.sh
```

Now you know where every file lives, how paths work, and how permissions keep your system secure!
