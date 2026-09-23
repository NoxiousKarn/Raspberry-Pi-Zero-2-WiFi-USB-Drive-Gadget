# Raspberry Pi Zero or Zero 2 – WiFi USB Drive Gadget  
Turn a **Raspberry Pi Zero or Zero 2 W** into a **wireless USB flash drive** accessible via WiFi. 

Great for 3D printers or any device that needs files added to a thumb drive frequently.

Inspiration: https://youtu.be/iDgQ7o_yZgU?si=pctKAqhMNQ9P6GsT

Old Write-up: https://magazine.raspberrypi.com/articles/pi-zero-w-smart-usb-flash-drive

---

![OS](https://img.shields.io/badge/OS-Raspberry%20Pi%20OS%20Lite-red)
![Board](https://img.shields.io/badge/Hardware-Raspberry%20Pi%20Zero%202%20W-blue)
![USB Gadget](https://img.shields.io/badge/USB%20Gadget-Mass%20Storage-green)
![License](https://img.shields.io/badge/License-MIT-yellow)

---

##  🧰 Requirements

- Raspberry Pi Zero 2 W  
- Raspberry Pi OS Lite (Trixie, 32-bit, no desktop)
- MicroSD card (8GB minimum recommended)
- USB data cable (not charge-only) or USB Hat
- WiFi access for network file creation and editing


## 🚀 What This Project Does

This project transforms a **Raspberry Pi Zero 2 W** into a:

- ✔ **USB Flash Drive** when connected to a TV, stereo, or computer  
- ✔ **Network Share** over WiFi (via Samba)  
- ✔ Device that **auto-syncs** changes from WiFi to USB by remounting  
- ✔ Completely automated installation using a Bash script  

You can add or remove files wirelessly, and the connected device will automatically refresh and re-detect the USB drive, allowing usb access to files transmitted wirelessly.

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
## ⚙️ Running the Automated Setup Script

Use wget to copy the script from this repository to your Raspberry Pi and run it:
```bash
sudo mkdir -p /Scripts && sudo wget -O /Scripts/setup_wifi_drive.sh https://raw.githubusercontent.com/NoxiousKarn/Raspberry-Pi-Zero-2-WiFi-USB-Drive-Gadget/refs/heads/main/setup_wifi_drive.sh && sudo chmod +x /Scripts/setup_wifi_drive.sh && sudo /Scripts/setup_wifi_drive.sh

```
The script will interactively ask for:

1. Size of virtual USB drive (ex: 2G, 4G, 512M)
2. USB read-only or read/write
3. Samba share name (ex: usb, movies, music)
4. Linux user for Samba ownership
5. Auto-remount timeout in seconds

It then:

✔ Creates /piusb.bin

✔ Formats it as FAT32

✔ Configures USB gadget mode

✔ Creates /mnt/usb_share

✔ Installs Samba and watchdog

✔ Creates a Python file-change detector

✔ Creates and activates a systemd service

✔ Enables automatic USB remounting on file changes

## 🔌 Using the Pi as a USB Gadget

1. Connect the Pi Zero's USB data port to your TV / car stereo / PC
(the port labeled USB, not PWR)

2. The device should immediately detect a USB flash drive.

3. Files added over WiFi to the Samba share will update on the USB device automatically after the configured timeout.

## 🔄 How Auto-Remount Works

A Python watchdog script monitors /mnt/usb_share.
If files change, it:

Waits for X seconds of inactivity

Unmounts the gadget

Syncs storage

Remounts the gadget

This forces TVs, stereos, etc. to refresh the drive contents.

## 🗑 Running the Uninstall Script
Copy uninstall_wifi_drive.sh to your Pi, then run:
```bash
chmod +x uninstall_wifi_drive.sh
sudo ./uninstall_wifi_drive.sh
```
This removes:

1. USB gadget config
2. Python watchdog service
3. Samba share
4. /piusb.bin
5. /mnt/usb_share
6. Systemd service


## 🐛 Troubleshooting
The device does not detect the USB drive:

Ensure you are using the USB data port, not PWR-IN

Some cables are charge-only — use a proper USB data cable

Reboot the Pi:
```bash
sudo reboot
```
Samba share not visible

Ensure Pi is on WiFi:
```bash
iwconfig
```
Restart Samba:
```bash
sudo systemctl restart smbd
```
/piusb.bin too large

Make sure your SD card has enough free space:
```bash
df -h
```
## 📘 License

MIT License / Open Source — modify freely.

## 💬 Support

If you have questions or want enhancements (multi-LUN, NTFS, extra services), feel free to open an issue or request help.
