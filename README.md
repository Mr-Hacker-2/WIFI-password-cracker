# 📶 WiFi Password Exporter

A lightweight Windows batch script that digs through your PC's saved WiFi profiles and pulls out the network names *and* their passwords — no extra software, no internet connection, just built-in Windows tools.

## ✨ Features

- 🔍 Scans **all saved WiFi profiles** on your PC
- 🔑 Extracts the password (key) for each network
- 📝 Saves everything to a clean, readable `WiFi_Passwords.txt`
- 🚀 Auto-opens the results in Notepad when done
- 🛠️ Zero dependencies — pure `netsh` + batch scripting

## 📂 What's Inside

| File | Description |
|------|-------------|
| `WiFi_Passwords.bat` | The script you double-click to run |
| `WiFi_Passwords.txt` | Generated output (created after running) |

## 🚀 How to Use

1. Download `WiFi_Passwords.bat` and place it anywhere (Desktop, USB stick, etc.)
2. **Right-click → Run as administrator** *(recommended — some passwords won't show without it)*
3. A console window will flash by while it scans your saved networks
4. `WiFi_Passwords.txt` opens automatically with your results

## 📄 Sample Output

```
Saved WiFi Networks and Passwords
Generated: Tue 06/30/2026 14:32:10
=====================================

Network: HomeNetwork_5G
Password: SuperSecret123!
-------------------------------------

Network: OfficeGuestWiFi
Password: (none / open network)
-------------------------------------
```

## ⚠️ Important Notes

> **This script only reveals passwords for networks your computer has already connected to and saved.** It cannot crack or reveal passwords for networks you've never joined.

- 🔐 **Treat the output file like a password!** It contains real, plain-text credentials.
- 🗑️ Delete `WiFi_Passwords.txt` once you're done with it — don't leave it lying around.
- 🖥️ Works on Windows 7/8/10/11 (anywhere `netsh wlan` is supported).
- 👮 Use this only on your **own devices/networks**. Running this on a computer you don't own or have permission to access is not okay.

## 🧠 How It Works

Under the hood, the script loops through Windows' `netsh wlan show profiles` output to list every saved network, then queries each one individually with `netsh wlan show profile name="X" key=clear` to reveal the stored key. It's the same data you could pull manually via Command Prompt — this just automates and formats it nicely.

## 📜 License

Free to use, modify, and share. No warranty — use responsibly.
