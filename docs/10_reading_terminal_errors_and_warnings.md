# 🛑 The Complete Encyclopedia of Terminal Errors & Warnings (Decoded)

When a terminal command fails, it often dumps **50 to 200 lines of scary red text** full of numbers, file paths, and memory addresses. 

Most people freeze, close the window, or feel overwhelmed. 

Here is the secret: **95% of that wall of text is completely useless noise**. You only need to know **where to look** and **how to translate the few lines that actually matter**.

---

## 📑 Quick Category Index
1. [🚦 The Golden Rule: Warnings vs. Errors](#1--the-golden-rule-warnings-vs-errors)
2. [🔍 The "Bottom-Up" Rule: Where to Look](#2--the-bottom-up-rule-where-to-look)
3. [📁 Category 1: System, Filesystem & Permissions](#3--category-1-system-filesystem--permissions)
4. [⌨️ Category 2: Shell & Command Execution](#4-️-category-2-shell--command-execution)
5. [📦 Category 3: Package Managers (Pacman, Yay, Apt) & Compilers](#5--category-3-package-managers-pacman-yay-apt--compilers)
6. [🌐 Category 4: Network, Internet & SSL Errors](#6--category-4-network-internet--ssl-errors)
7. [🐙 Category 5: Git & GitHub Errors](#7--category-5-git--github-errors)
8. [🐳 Category 6: Docker & Container Errors](#8--category-6-docker--container-errors)
9. [🟩 Category 7: Node.js, NPM & Web Development](#9--category-7-nodejs-npm--web-development)
10. [🐍 Category 8: Python Errors](#10--category-8-python-errors)
11. [🗄️ Category 9: Database Errors (PostgreSQL, MongoDB)](#11-️-category-9-database-errors-postgresql-mongodb)
12. [⚙️ Category 10: Systemd & Kernel Crashes](#12-️-category-10-systemd--kernel-crashes)
13. [🎮 Category 11: GPU, Graphics & Display Errors](#13--category-11-gpu-graphics--display-errors)
14. [🕵️ Category 12: How to Read a "Stack Trace" Like a Detective](#14-️-category-12-how-to-read-a-stack-trace-like-a-detective)

---

## 1. 🚦 The Golden Rule: Warnings vs. Errors

Not all red or yellow text means something is broken! Linux tools love to talk:

| Label | What It Actually Means | Does the program stop? | Should you panic? |
| :--- | :--- | :--- | :--- |
| **`WARN` / `WARNING`** | *"Hey, heads up! Something is slightly outdated or deprecated, but I was able to do my job anyway."* | **NO** (It finishes successfully) | **No.** 90% of warnings can be safely ignored. |
| **`ERROR` / `FATAL`** | *"I hit a brick wall and could not finish what you asked me to do."* | **YES** (The command stops immediately) | **Yes.** This is the one you need to fix. |
| **`INFO` / `DEBUG`** | *"Just letting you know what I am doing behind the scenes."* | **NO** | **No.** Completely normal logging. |

---

## 2. 🔍 The "Bottom-Up" Rule: Where to Look

When a program crashes and dumps 100 lines of text:

```text
  [Line 1]    Starting compilation...
  [Line 2]    Loading modules...
  [Line 3-80] at internal/modules/cjs/loader.js:1085:14
              at Module._compile (node:internal/modules/cjs/loader:1159:14)
              ... (giant wall of internal files you didn't write) ...
  [Line 99]   Error: connect ECONNREFUSED 127.0.0.1:5432   <--- 🎯 THE REAL PROBLEM!
  [Line 100]  Process exited with code 1
```

### The Rule: **ALWAYS LOOK AT THE VERY BOTTOM FIRST!**
* **The Top**: Usually just standard startup chatter.
* **The Middle**: The "Stack Trace" (the computer listing every internal library function it touched).
* **The Bottom 3 Lines**: **The actual punchline!** The real English reason why the program gave up.

---

## 3. 📁 Category 1: System, Filesystem & Permissions

### Error: `Permission denied`
* **What it means**: You are trying to read, write, or execute a file that belongs to administrator (`root`) or lacks execution rights.
* **The Fix**:
  * If it's a system file: add **`sudo`** (`sudo systemctl restart ...`).
  * If it's a script you downloaded: run **`chmod +x myscript.sh`**.
  * If you own the folder but it got locked by root: `sudo chown -R $USER:$USER ~/my-folder`.

### Error: `Read-only file system`
* **What it means**: Your hard drive encountered a disk error, so Linux locked it into "read-only" mode to protect your files from getting corrupted.
* **The Fix**: Reboot and let Linux check the disk, or run filesystem check:
  ```bash
  sudo btrfs check /dev/nvme0n1p2   # For Btrfs
  ```

### Error: `Device or resource busy` (EBUSY)
* **What it means**: You are trying to unmount a USB drive or delete a folder, but an open terminal, file manager, or app is currently sitting inside it!
* **The Fix**: Find what is holding it:
  ```bash
  fuser -m /path/to/folder
  # Close that terminal window or app, then try again.
  ```

### Error: `No space left on device`
* **What it means**: Your hard drive or `/tmp` folder is 100% full.
* **The Fix**: Run the PC Papa doctor:
  ```bash
  ~/Downloads/PC\ Papa/fix-my-pc.sh
  ```

### Error: `File exists` (EEXIST)
* **What it means**: A script tried to create a file or folder that is already there.
* **The Fix**: Add `-p` to `mkdir` (`mkdir -p folder`) or `-f` to `ln` (`ln -sf target link`).

---

## 4. ⌨️ Category 2: Shell & Command Execution

### Error: `command not found`
* **What it means**:
  1. Typo in command name (`doker` instead of `docker`).
  2. The tool isn't installed (`sudo pacman -S <tool>`).
  3. You forgot the `./` prefix when running a local script (`./myscript.sh`).

### Error: `Syntax error near unexpected token '...'`
* **What it means**: You pasted a command with an unclosed quote (`"`) or parenthesis (`(`).
* **The Fix**: Check that every quote has a matching pair: `echo "hello"` not `echo "hello`.

### Error: `Argument list too long`
* **What it means**: You ran `rm *` or `ls *` inside a folder that has 100,000+ files. The shell cannot fit that many names in one command.
* **The Fix**: Use `find`:
  ```bash
  find . -type f -name "*.tmp" -delete
  ```

### Error: `Is a directory`
* **What it means**: You tried to treat a folder as if it were a text file (e.g. running `cat my_folder` or `rm my_folder` without `-r`).
* **The Fix**: To delete a folder, add `-r` (recursive): `rm -r my_folder`.

---

## 5. 📦 Category 3: Package Managers (Pacman, Yay, Apt) & Compilers

### Error: `failed to lock database`
* **What it means**: An update was aborted, leaving a lock file behind.
* **The Fix**:
  ```bash
  sudo rm -f /var/lib/pacman/db.lck
  ```

### Error: `target not found: package-name`
* **What it means**: The package does not exist in the official repositories (it might be in the AUR, or spelled differently).
* **The Fix**: Try installing with **`yay`** or **`paru`** instead of `pacman`:
  ```bash
  yay -S package-name
  ```

### Error: `failed to commit transaction (conflicting files)`
* **What it means**: A file that the installer wants to write already exists on disk (usually from an old manual install).
* **The Fix**: Tell pacman to overwrite it:
  ```bash
  sudo pacman -S --overwrite "*" <package-name>
  ```

### Error: `fatal error: header_name.h: No such file or directory`
* **What it means**: You are building a program from source (using `make`, `gcc`, `cmake`), and you are missing a developer C/C++ library.
* **The Fix**: Install the base developer tools:
  ```bash
  sudo pacman -S base-devel
  ```

---

## 6. 🌐 Category 4: Network, Internet & SSL Errors

### Error: `Could not resolve host: google.com` / `Temporary failure in name resolution`
* **What it means**: Your computer cannot translate domain names into IP addresses (DNS is broken or Wi-Fi is disconnected).
* **The Fix**:
  ```bash
  sudo systemctl restart NetworkManager
  sudo systemctl restart systemd-resolved
  ```

### Error: `Connection refused` (ECONNREFUSED)
* **What it means**: You tried to connect to an IP and port (e.g. `localhost:5432` or `localhost:27017`), but **no program is listening on that port**!
* **The Fix**: The server/database is turned off. Start it:
  ```bash
  sudo systemctl start postgresql  # or mongodb, docker, ollama
  ```

### Error: `Connection reset by peer` (ECONNRESET)
* **What it means**: You were connected to a server, but the server suddenly died, crashed, or closed the connection on its end.
* **The Fix**: Check the logs of the server you were talking to:
  ```bash
  journalctl -u <service-name> -n 25
  ```

### Error: `SSL certificate problem: certificate has expired / self-signed`
* **What it means**: Your computer clock is wrong, or the website has an invalid HTTPS security certificate.
* **The Fix**: First check your PC clock (`date`). If your clock is wrong:
  ```bash
  sudo systemctl restart systemd-timesyncd
  ```
  *(For temporary curl testing only: `curl -k https://...` skips SSL verification).*

### HTTP Status Codes:
* **`401 Unauthorized`**: You did not provide a password or API key.
* **`403 Forbidden`**: Your API key or login works, but you do not have permission to access this resource.
* **`404 Not Found`**: The URL or endpoint does not exist.
* **`500 Internal Server Error`**: The website or backend code crashed.
* **`502 Bad Gateway` / `504 Gateway Timeout`**: The web server is running, but the app behind it (like Node, Python, or PHP) crashed or timed out.

---

## 7. 🐙 Category 5: Git & GitHub Errors

### Error: `fatal: not a git repository (or any of the parent directories): .git`
* **What it means**: You ran a git command inside a folder that is not tracked by Git!
* **The Fix**: Run `git init` to start tracking it, or `cd` into your actual project folder.

### Error: `fatal: unable to create '.git/index.lock': File exists`
* **What it means**: Git crashed or was cancelled in the middle of a commit, leaving its lock file behind.
* **The Fix**:
  ```bash
  rm -f .git/index.lock
  ```

### Error: `error: failed to push some refs to 'github.com:...'`
* **What it means**: Someone else (or you from another machine) pushed changes to GitHub that you don't have locally.
* **The Fix**: Pull first, then push:
  ```bash
  git pull --rebase
  git push
  ```

### Error: `CONFLICT (content): Merge conflict in file.txt`
* **What it means**: Two different edits happened to the exact same line of code, and Git doesn't know which one you prefer.
* **The Fix**: Open `file.txt`, look for `<<<<<<< HEAD` and `>>>>>>>`, delete the symbols, keep the code you want, save, and run:
  ```bash
  git add file.txt
  git commit -m "Resolved conflict"
  ```

### Error: `You are in 'detached HEAD' state`
* **What it means**: You checked out an old commit instead of a branch.
* **The Fix**: Return to your main branch:
  ```bash
  git checkout main   # or: git switch main
  ```

---

## 8. 🐳 Category 6: Docker & Container Errors

### Error: `Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?`
* **What it means**: Docker service is asleep or turned off.
* **The Fix**:
  ```bash
  sudo systemctl start docker
  ```

### Error: `Bind for 0.0.0.0:5678 failed: port is already allocated`
* **What it means**: Another container or app is already using that port.
* **The Fix**:
  ```bash
  # Stop the running container:
  docker ps
  docker stop <container-id>
  ```

### Error: `manifest for image:tag not found`
* **What it means**: You made a typo in the image name or tag (e.g. `node:99` instead of `node:20`).
* **The Fix**: Check the spelling of the image on Docker Hub.

---

## 9. 🟩 Category 7: Node.js, NPM & Web Development

### Error: `npm ERR! code EACCES / permission denied`
* **What it means**: You ran `npm install -g` into a root-owned system folder.
* **The Fix**: Do **NOT** run npm with sudo! Instead, install packages in user space or configure local npm prefix:
  ```bash
  mkdir -p ~/.npm-global
  npm config set prefix '~/.npm-global'
  ```

### Error: `FATAL ERROR: Ineffective mark-compacts near heap limit Allocation failed - JavaScript heap out of memory`
* **What it means**: Your Node.js project ran out of RAM during a build (Webpack, Next.js, Vite).
* **The Fix**: Increase Node's memory limit:
  ```bash
  export NODE_OPTIONS="--max-old-space-size=4096"
  npm run build
  ```

### Error: `Error [ERR_MODULE_NOT_FOUND]: Cannot find package 'xyz'`
* **What it means**: A library is mentioned in code but not installed in `node_modules`.
* **The Fix**:
  ```bash
  npm install
  ```

---

## 10. 🐍 Category 8: Python Errors

### Error: `IndentationError: unexpected indent` (or `unindent does not match`)
* **What it means**: You mixed **Tabs and Spaces** on the same line, or a line of code is indented too far to the right.
* **The Fix**: Highlight the code in your editor, convert all tabs to 4 spaces, and ensure lines inside functions line up perfectly.

### Error: `RecursionError: maximum recursion depth exceeded`
* **What it means**: A function is calling itself in an infinite loop without an exit condition.
* **The Fix**: Check your `while` loops or recursive functions to make sure they have a way to stop.

### Error: `TypeError: 'NoneType' object is not subscriptable`
* **What it means**: You wrote `data["key"]`, but `data` was `None` (empty) because an API call or database query returned nothing!
* **The Fix**: Check if `data is not None` before accessing its keys.

---

## 11. 🗄️ Category 9: Database Errors (PostgreSQL, MongoDB)

### Error: `FATAL: password authentication failed for user "postgres"`
* **What it means**: The database password you provided in your `.env` or connection string is incorrect.
* **The Fix**: Reset the local password:
  ```bash
  sudo -u postgres psql -c "ALTER USER postgres PASSWORD 'newpassword';"
  ```

### Error: `FATAL: Peer authentication failed for user "siakshit"`
* **What it means**: PostgreSQL is checking if your Linux username matches your database username.
* **The Fix**: Connect using the postgres user (`psql -U postgres`) or change `peer` to `md5` in `/var/lib/postgres/data/pg_hba.conf`.

---

## 12. ⚙️ Category 10: Systemd & Kernel Crashes

### Error: `Unit xyz.service not found`
* **What it means**: You typed the name of a service that is not installed or has a typo (e.g. `mysql` instead of `mariadb`).
* **The Fix**: Search for the exact service name:
  ```bash
  systemctl list-unit-files | grep -i xyz
  ```

### Error: `Killed`
* **What it means**: Your computer completely ran out of RAM and swap. The Linux kernel stepped in to save your PC by killing the biggest memory-hogging program.
* **The Fix**: Run `free -h` to see memory, and close heavy apps or Chrome tabs.

---

## 13. 🎮 Category 11: GPU, Graphics & Display Errors

### Error: `Failed to initialize NVML: Driver/library version mismatch`
* **What it means**: Your NVIDIA graphics driver was upgraded during a system update, but your kernel is still running the old driver version.
* **The Fix**: Simply **reboot your PC**! When Linux reboots, the new kernel and new GPU driver match up and work immediately.

### Error: `Cannot open display: :0`
* **What it means**: You ran a graphical desktop app with `sudo` from a terminal, and Wayland/X11 blocked it for security reasons.
* **The Fix**: Run graphical apps as your regular user, never with `sudo`.

---

## 14. 🕵️ Category 12: How to Read a "Stack Trace" Like a Detective

When a crash happens in Python or Node.js:

```text
Traceback (most recent call last):
  File "/usr/lib/python3.11/site-packages/flask/app.py", line 1478, in __call__
  File "/home/siakshit/Projects/my_server.py", line 42, in index
    result = 10 / divisor
ZeroDivisionError: division by zero
```

### The 3-Step Detective Method:
1. **Look at the bottom line**: `ZeroDivisionError: division by zero` $\rightarrow$ Tells you **WHAT** went wrong.
2. **Scan upwards to find YOUR file**: `/home/siakshit/Projects/my_server.py, line 42` $\rightarrow$ Tells you **WHERE** it happened.
3. **Ignore system files**: Ignore anything pointing to `/usr/lib/...` or `node_modules/...`—those are not your code.

Now you have the master decoder for almost every error that can ever happen on Linux!
