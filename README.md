# Raspberry Pi Zero 2 – WiFi USB Drive Gadget  
Turn a **Raspberry Pi Zero / Zero 2 W** into a **wireless USB flash drive** accessible via WiFi.

![Project Diagram](images/overview-diagram.png)

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

- Automatic creation of a **virtual USB flash drive** (`piusb.bin`)
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

## 📂 Repository Structure

```plaintext
raspberrypi-wifi-usb-drive/
│
├── README.md
├── LICENSE
├── setup_wifi_drive.sh
├── uninstall_wifi_drive.sh
│
├── docs/
│   ├── 01_installing_raspberry_pi_os.md
│   ├── 02_enable_ssh_and_wifi.md
│   ├── 03_running_the_setup_script.md
│   ├── 04_how_it_works.md
│   ├── 05_troubleshooting.md
│   └── 06_faq.md
│
└── images/
    ├── overview-diagram.png
    ├── pi-zero-usb-port.png
    ├── samba-share-example.png
    └── system-architecture.png
