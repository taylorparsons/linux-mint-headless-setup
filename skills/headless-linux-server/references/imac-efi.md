# iMac / Mac Mini — EFI Install Reference

Applies to: iMac (2007–2020), Mac mini, MacBook repurposed as a server. All Apple Intel hardware uses EFI firmware — not the traditional BIOS found on PCs.

## Table of Contents
1. [Compatibility Notes](#1-compatibility-notes)
2. [Pre-Install Checklist](#2-pre-install-checklist)
3. [Download Linux Mint and Prepare USB](#3-download-linux-mint-and-prepare-usb)
4. [Dual-Boot: Shrink macOS Partition](#4-dual-boot-shrink-macos-partition)
5. [Write the EFI-Bootable USB](#5-write-the-efi-bootable-usb)
6. [Boot From USB](#6-boot-from-usb)
7. [Run the Linux Mint Installer](#7-run-the-linux-mint-installer)
8. [Post-Install: Apple-Specific Fixes](#8-post-install-apple-specific-fixes)
9. [Hard Stops](#9-hard-stops)

---

## 1. Compatibility Notes

| Model | Linux support | Notes |
|---|---|---|
| iMac 2009–2019 (Intel) | Good | Most hardware works with upstream drivers |
| Mac mini 2011–2020 (Intel) | Good | Preferred for headless — no display hardware issues |
| iMac 2020 (Intel, last Intel) | Good | Same as above |
| iMac M1/M2/M3/M4 (Apple Silicon) | **Not supported** | Do not attempt with this skill — use Asahi Linux project separately |
| MacBook repurposed headless | Good | Lid-close behavior needs post-install fix |

Confirm the machine is Intel before proceeding. Apple Silicon Macs require a completely different approach (Asahi Linux) not covered here.

---

## 2. Pre-Install Checklist

- [ ] Verify Intel CPU: Apple menu → About This Mac → Processor shows "Intel"
- [ ] Data backed up to Time Machine or external drive
- [ ] iCloud data synced and signed out if wiping
- [ ] Ethernet cable available (Wi-Fi may need a driver fix post-install)
- [ ] USB drive ≥ 4 GB available (will be wiped)
- [ ] Target machine has power (iMacs have no battery)

---

## 3. Download Linux Mint and Prepare USB

Download from the admin Mac (not the target machine):

- Linux Mint XFCE: `https://www.linuxmint.com/download.php`
  - Choose the **64-bit** XFCE edition
  - Verify the SHA256 checksum after download

No Rufus needed on macOS. Use the terminal to write the USB.

---

## 4. Dual-Boot: Shrink macOS Partition

Skip this section for a clean wipe.

On the target iMac:

1. Open **Disk Utility** (Applications → Utilities → Disk Utility).
2. Select **Macintosh HD** (the main volume — not the container).
3. Click **Partition** → **+** to add a partition.
4. Set size for the new Linux partition (at least 40 GB recommended, 100 GB+ if available).
5. Format: **MS-DOS (FAT)** — the Mint installer will reformat it.
6. Click **Apply** and confirm.

Alternatively, from Terminal using `diskutil`:

```sh
diskutil resizeVolume disk0s1 200GB
```

Replace `200GB` with the size you want to keep for macOS. This frees the rest for Linux.

Verify the new free space appears in Disk Utility before proceeding.

---

## 5. Write the EFI-Bootable USB

On the admin Mac (the machine you're using to prepare the USB — not the target iMac):

```sh
# Find the USB drive identifier
diskutil list

# Unmount it (replace diskN with actual disk number, e.g., disk2)
diskutil unmountDisk /dev/diskN

# Write the ISO (takes 5-10 minutes)
sudo dd if=/path/to/linuxmint-22-xfce-64bit.iso of=/dev/rdiskN bs=1m status=progress

# Eject when done
diskutil eject /dev/diskN
```

Use `/dev/rdiskN` (with the `r` prefix) for raw device access — significantly faster than `/dev/diskN`.

---

## 6. Boot From USB

1. Insert the USB into the target iMac.
2. Shut down completely.
3. Power on and immediately hold the **Option (⌥) key**.
4. The Startup Manager appears — release Option when you see disk icons.
5. Select the USB drive (often labeled "EFI Boot" or "Windows" — this is normal for Linux ISOs on Apple EFI).
6. Choose **Start Linux Mint** from the GRUB menu.

If the USB does not appear in Startup Manager:
- Try a different USB port
- Re-write the USB (the `dd` command must complete cleanly)
- Check whether the ISO file was fully downloaded (verify SHA256)

---

## 7. Run the Linux Mint Installer

In the live environment:

1. Double-click **Install Linux Mint** on the desktop.
2. Choose language, keyboard, and whether to install multimedia codecs (recommended).
3. At the **Installation type** screen:
   - **Dual-boot**: Select **Something else** → find the FAT partition you created in Disk Utility → format it as `ext4`, mount point `/` → set the bootloader to the disk (e.g., `/dev/sda`).
   - **Clean wipe**: Select **Erase disk and install Linux Mint**.
4. Create the user account and set a strong password.
5. Complete the installer. Remove the USB when prompted, then reboot.

**iMac note**: GRUB installs to the EFI partition automatically. On reboot, GRUB appears first — select Linux Mint or macOS from the menu.

---

## 8. Post-Install: Apple-Specific Fixes

After first boot into Linux Mint:

### Wi-Fi (if needed)

iMacs use Broadcom Wi-Fi chips. Install the driver:

```sh
sudo apt update
sudo apt install bcmwl-kernel-source
```

Reboot after installation. Ethernet is more reliable — use it for the initial setup.

### Fan and Temperature (iMac only)

iMacs may run fans at full speed without macOS's SMC control. Install `mbpfan`:

```sh
sudo apt install mbpfan
sudo systemctl enable --now mbpfan
```

### Lid-Close Behavior (MacBook only)

If repurposing a MacBook as a headless server, prevent suspend on lid close:

Edit `/etc/systemd/logind.conf`:

```ini
HandleLidSwitch=ignore
HandleLidSwitchExternalPower=ignore
```

Apply without rebooting:

```sh
sudo systemctl restart systemd-logind
```

### Bluetooth (optional)

Bluetooth usually works. If the system shows it as blocked:

```sh
sudo rfkill unblock bluetooth
```

After these fixes, continue to `references/post-install.md`.

---

## 9. Hard Stops

**Stop and do not continue if:**

- `About This Mac` shows Apple M1, M2, M3, or M4. This skill does not apply — the user needs Asahi Linux.
- Startup Manager does not show the USB after two attempts with different ports. The ISO may be corrupt or the USB write failed.
- The Mint installer does not show the partition you created in Disk Utility. Re-check Disk Utility — the partition may not have been applied.
- The installer warns that it cannot find a bootloader target. Verify the EFI partition exists (`/dev/sda1` or similar with type `EFI System`) before formatting anything.
