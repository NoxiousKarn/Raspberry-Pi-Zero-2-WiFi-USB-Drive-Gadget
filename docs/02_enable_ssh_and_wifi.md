# Enabling SSH and WiFi Before First Boot

## Enable SSH
Create an empty file on the SD card boot partition:
```bash
ssh
```
## Enable WiFi
Create `wpa_supplicant.conf`:

```conf
country=US
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1

network={
    ssid="YOUR_WIFI_SSID"
    psk="YOUR_WIFI_PASSWORD"
}

Save and eject the SD card, then boot the Pi.
