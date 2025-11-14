#!/bin/bash

echo "==============================="
echo " Uninstalling WiFi USB Drive"
echo "==============================="

sudo systemctl stop usbshare.service
sudo systemctl disable usbshare.service
sudo rm -f /etc/systemd/system/usbshare.service
sudo systemctl daemon-reload

sudo modprobe -r g_mass_storage

sudo rm -f /usr/local/share/usb_share.py

sudo sed -i '/piusb.bin/d' /etc/fstab

sudo umount /mnt/usb_share 2>/dev/null
sudo rm -rf /mnt/usb_share

sudo rm -f /piusb.bin

echo "Uninstall complete. Reboot recommended."
