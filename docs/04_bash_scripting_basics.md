# 📜 Bash Scripting 101 for Absolute Beginners

A Bash script is simply a text file that lists commands in order, exactly as if you were typing them one by one into your terminal window.

If you find yourself running the same 3 commands every day, putting them in a `.sh` file turns them into a 1-click automated superpower.

---

## 🍳 1. The Recipe Analogy

Think of a Bash script like a kitchen recipe:
1. **The Shebang (`#!/usr/bin/env bash`)**: Tells the computer: *"This is a recipe written in English for the Bash kitchen chef."* Always put this at the very top of line 1.
2. **The Ingredients (Variables)**: Storing numbers or names to reuse later (`PORT=5678`).
3. **The Steps (Commands)**: `echo "Starting up..."`, `docker start n8n`.
4. **Decisions (If / Else Statements)**: *"If the water is boiling, add the pasta. Otherwise, wait."*

---

## 📝 2. Building Your First Script (In 60 Seconds)

Open a terminal and create a file called `hello.sh`:
```bash
nano hello.sh
```

Paste this into it:
```bash
#!/usr/bin/env bash

# This is a comment (the computer ignores lines starting with #)
echo "Hello, Siakshit!"
echo "Today is: $(date)"
echo "Your free hard drive space is:"
df -h /
```

Save and exit (`Ctrl + O`, `Enter`, `Ctrl + X`).

### Making it Executable (`chmod +x`):
Linux protects files by default so they cannot run as programs until you give permission:
```bash
chmod +x hello.sh
```
* `chmod`: **Ch**ange File **Mod**e.
* `+x`: Grant **eX**ecution permission.

Now run it!
```bash
./hello.sh
```
*(The `./` means "look inside the current folder for this file").*

---

## 🧱 3. The 4 Essential Building Blocks of Bash

### 1. Variables (Storing Information)
```bash
# Setting a variable (NO spaces around the '=' sign!)
NAME="Alice"
PORT=8080

# Reading a variable (Add a '$' in front of the name)
echo "Connecting to $NAME on port $PORT..."
```

---

### 2. If / Else Conditions (Making Decisions)
```bash
# Check if a folder exists:
if [ -d "/home/siakshit/Downloads" ]; then
  echo "Downloads folder exists!"
else
  echo "Folder not found!"
fi

# Check if a number equals something (-eq means equals):
COUNT=5
if [ "$COUNT" -ge 5 ]; then
  echo "Count reached 5 or greater (-ge = Greater than or Equal)!"
fi
```

**Common Comparison Operators:**
* `-eq`: Equal to (`[ "$a" -eq 5 ]`)
* `-ne`: Not equal to (`[ "$a" -ne 0 ]`)
* `-gt`: Greater than (`[ "$a" -gt 10 ]`)
* `-ge`: Greater than or equal to (`[ "$a" -ge 5 ]`)
* `-f`: File exists (`[ -f "note.txt" ]`)
* `-d`: Directory exists (`[ -d "folder" ]`)

---

### 3. Catching Command Outputs (`$( ... )`)
If you want to save the result of a terminal command inside a variable, wrap it in `$()`:
```bash
CURRENT_USER=$(whoami)
RUNNING_CONTAINERS=$(docker ps -q | wc -l)

echo "Logged in as: $CURRENT_USER"
echo "Active containers: $RUNNING_CONTAINERS"
```

---

### 4. Exit Codes (Did the Command Succeed?)
Every command in Linux outputs an invisible number when it finishes called an **Exit Code**:
* **`0`**: Success! Everything went smoothly.
* **`1` (or higher)**: Error! Something went wrong.

You can inspect the exit code of the last command using `$?`:
```bash
ls /tmp
echo "Exit code was: $?" # Prints 0

ls /folder_that_does_not_exist
echo "Exit code was: $?" # Prints 2 (Error)
```

---

## 🔍 4. The Golden Debugging Trick: `bash -x`

If you ever run a script and wonder *"Why did it do that? Which line failed?"*, do NOT guess! 

Run the script with the `-x` flag:
```bash
bash -x my_script.sh
```
This prints **every single line in real-time with variable values filled in** before executing it, showing you the exact line where an error happened!
