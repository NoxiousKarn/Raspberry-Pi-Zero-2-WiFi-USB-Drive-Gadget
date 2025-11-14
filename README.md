# Raspberry Pi Zero 2 – WiFi USB Drive Gadget  
Turn a **Raspberry Pi Zero / Zero 2 W** into a **wireless USB flash drive** accessible via WiFi.

---

## 📛 Badges
![OS](https://img.shields.io/badge/OS-Raspberry%20Pi%20OS%20Lite-red)
![Board](https://img.shields.io/badge/Hardware-Raspberry%20Pi%20Zero%202%20W-blue)
![USB Gadget](https://img.shields.io/badge/USB%20Gadget-Mass%20Storage-green)
![License](https://img.shields.io/badge/License-MIT-yellow)

---

## 🚀 What This Project Does

This project transforms a **Raspberry Pi Zero 2 W** into a:

- ✔ **USB Flash Drive** when connected to a TV, stereo, or computer  
- ✔ **Network Share** over WiFi (via Samba)  
- ✔ Device that **auto-syncs** changes from WiFi to USB by remounting  
- ✔ Completely automated installation using a Bash script  

You can update files wirelessly and the connected device will automatically refresh and re-detect the USB drive.

---

## 📦 Features

- Automatic creation of a **virtual USB flash drive** 
- Automatic formatting (FAT32)
- Network file sharing via **Samba**
- Auto-remount via **Python watchdog**
- Full systemd service integration
- User-configurable:
  - USB read/write mode  
  - Share name  
  - Auto-remount timeout  
  - Username for Samba force-user  
  - Storage size  

---
