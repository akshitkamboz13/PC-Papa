# 📚 Kiwix: Your Offline Knowledge & Wikipedia Server

**Kiwix** is an offline knowledge engine that allows you to store and serve the entirety of **Wikipedia**, **WikiHow**, **Stack Overflow**, **GeeksforGeeks**, and **medical libraries** across your entire local network without needing an internet connection.

It stores information in compressed **`.zim`** archive files.

---

## 🏛️ 1. How Kiwix is Configured on `si4k-server`

Your server runs Kiwix as a high-performance background daemon:

* **Service File**: `/etc/systemd/system/kiwix.service`
* **Internal Port**: `8080`
* **Library XML Index**: `/mnt/knowledge/Metadata/library.xml`
* **Caddy Reverse Proxy URL**: `http://si4k-server.local/wiki/` (or `http://si4k-server.local:8080`)
* **How it executes**:
  ```bash
  /usr/bin/kiwix-serve \
      --library \
      --monitorLibrary \
      --port=8080 \
      /mnt/knowledge/Metadata/library.xml
  ```
  *(Notice the `--monitorLibrary` flag: Kiwix automatically watches `library.xml` and reloads immediately whenever you add new content!)*

---

## 📥 2. How to Add New `.zim` Books to Your Server

Want to add a new offline library (like offline Stack Overflow, Project Gutenberg books, or Medical Wiki)?

### Step 1: Download the `.zim` File
You can download any free offline `.zim` archive from:
👉 [https://library.kiwix.org/](https://library.kiwix.org/)

### Step 2: Copy the `.zim` File to Your Server
Copy it over your local network using `scp`:
```bash
scp my_new_archive.zim si4k@si4k-server.local:/mnt/knowledge/ZIM/
```

### Step 3: Add It to Your Library Index (`kiwix-manage`)
SSH into your server:
```bash
ssh si4k@si4k-server.local
```
Tell Kiwix to index the new book:
```bash
kiwix-manage /mnt/knowledge/Metadata/library.xml add /mnt/knowledge/ZIM/my_new_archive.zim
```
Because `--monitorLibrary` is enabled, **Kiwix will instantly display the new library in your browser without restarting!**

---

## 🔍 3. How to Check Kiwix Health & Logs

### Check if Kiwix is running:
```bash
systemctl status kiwix
```

### View Kiwix live logs:
```bash
sudo journalctl -u kiwix -f
```

### Restart Kiwix manually:
```bash
sudo systemctl restart kiwix
```

---

## 🛑 4. Troubleshooting Kiwix Issues

### Issue 1: "Kiwix won't start / Port 8080 in use"
* **The Fix**:
  ```bash
  sudo fuser -k 8080/tcp
  sudo systemctl restart kiwix
  ```

### Issue 2: "Corrupted `library.xml`"
If your XML index gets accidentally corrupted or deleted, rebuild it from all `.zim` files inside `/mnt/knowledge/ZIM/` in one command:
```bash
# Create fresh library.xml:
rm -f /mnt/knowledge/Metadata/library.xml

# Re-index all ZIM files:
for f in /mnt/knowledge/ZIM/*.zim; do
  kiwix-manage /mnt/knowledge/Metadata/library.xml add "$f"
done

# Restart service:
sudo systemctl restart kiwix
```
