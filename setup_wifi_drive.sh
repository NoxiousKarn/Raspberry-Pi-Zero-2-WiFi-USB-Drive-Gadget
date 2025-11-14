#!/bin/bash

echo "==============================="
echo " Raspberry Pi WiFi USB Drive"
echo " Automated Setup Script (Updated)"
echo "==============================="

# --- Ask user questions --------------------------------------

read -p "Enter size for piusb.bin (example: 2G, 4G, 512M): " PISIZE
while [[ -z "$PISIZE" ]]; do
    read -p "Please enter a valid size (ex: 2G): " PISIZE
done

read -p "USB mode? Enter 1 = Read-only, 0 = Read/Write (default 1): " ROMODE
ROMODE=${ROMODE:-1}
while [[ "$ROMODE" != "0" && "$ROMODE" != "1" ]]; do
    read -p "Invalid input. Enter 1 for RO, 0 for RW: " ROMODE
done

read -p "Enter Samba share name (default: usb): " SHARENAME
SHARENAME=${SHARENAME:-usb}

DEFAULTUSER=$(logname)
read -p "Enter Linux username Samba should use for file operations (default: ${DEFAULTUSER}): " FORCEUSER
FORCEUSER=${FORCEUSER:-$DEFAULTUSER}

read -p "Enter idle timeout before USB re-mount (seconds, default 10): " TIMEOUT
TIMEOUT=${TIMEOUT:-10}

echo ""
echo "--------------------------------"
echo " Summary of your selections"
echo "--------------------------------"
echo "File size:      $PISIZE"
echo "USB mode:       ro=$ROMODE"
echo "Samba share:    $SHARENAME"
echo "Samba force user: $FORCEUSER"
echo "Idle timeout:   ${TIMEOUT}s"
echo "--------------------------------"
read -p "Press ENTER to continue or CTRL+C to cancel"

# --- Enable dwc2 overlay --------------------------------------

echo "Updating /boot/firmware/config.txt..."
grep -qxF "dtoverlay=dwc2" /boot/firmware/config.txt || echo "dtoverlay=dwc2" | sudo tee -a /boot/firmware/config.txt >/dev/null

echo "Updating /etc/modules-load.d/modules.conf..."
grep -qxF "dwc2" /etc/modules-load.d/modules.conf || echo "dwc2" | sudo tee -a /etc/modules-load.d/modules.conf >/dev/null

# --- Create piusb.bin ----------------------------------------

echo "Creating piusb.bin of size $PISIZE..."
sudo truncate -s $PISIZE /piusb.bin

echo "Formatting piusb.bin as FAT32..."
sudo mkdosfs /piusb.bin -F 32 -I

# --- Create mount & fstab entry -------------------------------

sudo mkdir -p /mnt/usb_share

if ! grep -q "/piusb.bin" /etc/fstab; then
    echo "/piusb.bin /mnt/usb_share vfat users,umask=000 0 2" | sudo tee -a /etc/fstab >/dev/null
fi

sudo systemctl daemon-reload
sudo mount -a

# --- Install Samba -------------------------------------------

echo "Installing Samba..."
sudo apt-get update
sudo apt-get install -y samba winbind

# --- Configure Samba -----------------------------------------

echo "Configuring Samba share..."

# Remove any previously defined share with that name
sudo sed -i "/^\[${SHARENAME}\]/,/^$/d" /etc/samba/smb.conf

sudo bash -c "cat <<EOF >> /etc/samba/smb.conf

[${SHARENAME}]
browseable = yes
path = /mnt/usb_share
public = yes
available = yes
force user = ${FORCEUSER}
read only = no
create mask = 0700
directory mask = 0700

EOF"

sudo systemctl restart smbd.service

# --- Install watchdog -----------------------------------------

echo "Installing Python watchdog..."
sudo apt-get install -y python3-watchdog

# --- Create USB share Python script ---------------------------

echo "Creating /usr/local/share/usb_share.py..."

sudo bash -c "cat << 'EOF' > /usr/local/share/usb_share.py
#!/usr/bin/python3
import time
import os
from watchdog.observers import Observer
from watchdog.events import *

CMD_MOUNT = \"sudo modprobe g_mass_storage file=/piusb.bin stall=0 ro=${ROMODE}\"
CMD_UNMOUNT = \"sudo modprobe -r g_mass_storage\"
CMD_SYNC = \"sudo sync\"

WATCH_PATH = \"/mnt/usb_share\"
ACT_EVENTS = [DirDeletedEvent, DirMovedEvent, FileDeletedEvent, FileModifiedEvent, FileMovedEvent]
ACT_TIME_OUT = ${TIMEOUT}

class DirtyHandler(FileSystemEventHandler):
    def __init__(self):
        self.reset()

    def on_any_event(self, event):
        if type(event) in ACT_EVENTS:
            self._dirty = True
            self._dirty_time = time.time()

    @property
    def dirty(self):
        return self._dirty

    @property
    def dirty_time(self):
        return self._dirty_time

    def reset(self):
        self._dirty = False
        self._dirty_time = 0
        self._path = None

os.system(CMD_MOUNT)

evh = DirtyHandler()
observer = Observer()
observer.schedule(evh, path=WATCH_PATH, recursive=True)
observer.start()

try:
    while True:
        while evh.dirty:
            time_out = time.time() - evh.dirty_time
            if time_out >= ACT_TIME_OUT:
                os.system(CMD_UNMOUNT)
                time.sleep(1)
                os.system(CMD_SYNC)
                time.sleep(1)
                os.system(CMD_MOUNT)
                evh.reset()
            time.sleep(1)
        time.sleep(1)

except KeyboardInterrupt:
    observer.stop()

observer.join()
EOF"

sudo chmod +x /usr/local/share/usb_share.py

# --- Create systemd service ----------------------------------

echo "Creating systemd service /etc/systemd/system/usbshare.service..."

sudo bash -c "cat << 'EOF' > /etc/systemd/system/usbshare.service
[Unit]
Description=USB Share Watchdog

[Service]
Type=simple
ExecStart=/usr/local/share/usb_share.py
Restart=always

[Install]
WantedBy=multi-user.target
EOF"

sudo systemctl daemon-reload
sudo systemctl enable usbshare.service
sudo systemctl start usbshare.service

echo ""
echo "======================================"
echo " Setup complete!"
echo " A reboot is recommended: sudo reboot"
echo "======================================"
