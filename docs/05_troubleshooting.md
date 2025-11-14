# Troubleshooting

## TV or Stereo Does Not Detect USB Drive
- Use the correct USB data port (not PWR)
- Use a data-capable USB cable

## Samba Not Visible
Restart Samba:
```bash
sudo systemctl restart smbd
```
Not Enough Space

Check SD card free space:
```bash
df -h
```
