# Fixing brcmfmac Suspension Crash

This directory contains scripts to fix kernel crashes caused by the Broadcom WiFi driver (`brcmfmac`) during system suspend/resume cycles.

## The Problem

The `brcmfmac_wcc` module can cause system crashes when the computer enters or exits suspend mode.

## Installation

### 1. Install the manual reload script

Copy `brcmfmac-reload` to your local bin directory:

```bash
cp brcmfmac-reload ~/.local/bin/
chmod +x ~/.local/bin/brcmfmac-reload
```

You can now run `brcmfmac-reload` from anywhere to manually fix the driver.

### 2. Install the systemd service (Recommended)

Set up automatic driver handling during suspend/resume:

```bash
sudo cp brcmfmac-reload.service /etc/systemd/system/
sudo systemctl enable brcmfmac-reload.service
sudo systemctl start brcmfmac-reload.service
```

The service will:
- Remove `brcmfmac_wcc` before suspend
- Reload `brcmfmac` after resume

## Usage

### Manual Fix

If you need to reload the driver manually:

```bash
brcmfmac-reload
```

### Automatic Fix

Once the service is installed, it runs automatically during suspend/resume cycles.

## Verification

After installation, suspend and resume your system. Check the service status:

```bash
systemctl status brcmfmac-reload.service
```

Your WiFi should work normally without crashes.


## References

- [Arch Linux Wiki](https://wiki.archlinux.org/title/Broadcom_wireless)
