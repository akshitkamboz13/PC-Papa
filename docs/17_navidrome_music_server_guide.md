# 🎵 Navidrome: Your Self-Hosted Personal Spotify Server

**Navidrome** is an open-source, ultra-fast personal music streaming server. It turns your home server into your own private Spotify, allowing you to stream your own music collection in full lossless audio quality to your phone, laptop, or car stereo anywhere in the world.

---

## 🎧 1. How Navidrome is Configured on `si4k-server`

On your server, Navidrome runs natively as an optimized systemd service:

* **Service File**: `/etc/systemd/system/navidrome.service`
* **Configuration File**: `/etc/navidrome/navidrome.toml`
* **Music Storage Folder**: `/mnt/music`
* **Database & Playlists Folder**: `/var/lib/navidrome`
* **Default Port**: `4533`
* **Local Web Access**: `http://si4k-server.local:4533` (or `http://192.168.31.250:4533`)

---

## 📂 2. How to Add Songs & Albums to Navidrome

Whenever you download new MP3s or FLAC albums on your PC, send them to your server:

### Option A: Using `rsync` (Fastest, resumes if interrupted)
```bash
rsync -avzP ~/Music/ si4k@si4k-server.local:/mnt/music/
```

### Option B: Using `scp` (Single album or folder)
```bash
scp -r "My Favorite Album/" si4k@si4k-server.local:/mnt/music/
```

### Triggering a Music Library Rescan:
* **From the Web UI**: Log into `http://si4k-server.local:4533` $\rightarrow$ Click your profile icon in the top right $\rightarrow$ **Settings** $\rightarrow$ Click **"Quick Scan"** or **"Full Scan"**.
* **From Terminal**:
  ```bash
  ssh si4k@si4k-server.local "touch /mnt/music"
  ```
  *(Navidrome automatically notices the new files and imports cover art, artists, and lyrics!)*

---

## 📱 3. The Best Mobile & Desktop Apps for Navidrome

Navidrome is compatible with all modern Subsonic streaming clients. 

When opening any of these apps, choose **"Subsonic Server"**, enter:
* **Server URL**: `http://si4k-server.local:4533` (or your Cloudflare tunnel domain `https://music.yourdomain.com`)
* **Username**: Your Navidrome username
* **Password**: Your Navidrome password

### 🤖 Android Apps:
1. **Symfonium** *(The Gold Standard)*: Gorgeous UI, offline caching, Android Auto support, Chromecast, equalizer.
2. **Substreamer**: Free, clean, modern Spotify-like interface.
3. **DSub**: Lightweight, open-source, highly reliable.

### 🍎 iOS Apps (iPhone / iPad):
1. **Amperfy**: Fast, native iOS design, CarPlay support, offline downloads.
2. **Substreamer**: Free on the App Store, smooth modern UI.
3. **play:Sub**: Feature-packed Subsonic player.

### 💻 Desktop Apps (Linux, Mac, Windows):
1. **Feishin** *(Recommended)*: Beautiful desktop client inspired by Spotify and Apple Music (available as AppImage / Flatpak).
2. **Sonixd**: Cross-platform desktop player.
3. **Web Player**: Simply open `http://si4k-server.local:4533` in any browser!

---

## 🛑 4. Troubleshooting Navidrome Issues

### Issue 1: "Songs aren't showing up after copying"
* **Why**: The file permissions on `/mnt/music` don't allow the `navidrome` user to read the new files.
* **The Fix**: Fix permissions on the server:
  ```bash
  sudo chown -R si4k:navidrome /mnt/music
  sudo chmod -R 775 /mnt/music
  ```

### Issue 2: "Forgot your Navidrome admin password"
* **The Fix**: SSH into the server and reset it using the Navidrome CLI:
  ```bash
  sudo navidrome user update admin --password "MyNewStrongPassword"
  ```

### Issue 3: "Navidrome won't start / Port 4533 busy"
* **The Fix**:
  ```bash
  sudo fuser -k 4533/tcp
  sudo systemctl restart navidrome
  ```
