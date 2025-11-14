
---

### **04_how_it_works.md**

```markdown
# System Architecture

## USB Gadget
The Pi emulates a USB mass storage device using:
- dwc2 overlay
- g_mass_storage kernel module
- A file-backed storage device (`/piusb.bin`)

## Network
Files are shared via Samba in `/mnt/usb_share`.

## Auto-Refresh System
A Python watchdog observer detects changes and performs:

1. Unmount USB gadget
2. Sync storage
3. Remount USB gadget
4. Connected devices refresh automatically
