# Windows / BIOS Machine — Install Reference

Applies to: ThinkPad, Dell, HP, Lenovo, and most PC hardware running Windows 7/8/10/11 with a traditional BIOS or UEFI-with-CSM.

## Table of Contents
1. [Pre-Install Checklist](#1-pre-install-checklist)
2. [Hardware Inventory](#2-hardware-inventory)
3. [Download Linux Mint and Rufus](#3-download-linux-mint-and-rufus)
4. [Dual-Boot: Shrink C](#4-dual-boot-shrink-c)
5. [Write the Bootable USB](#5-write-the-bootable-usb)
6. [Boot From USB](#6-boot-from-usb)
7. [Run the Linux Mint Installer](#7-run-the-linux-mint-installer)
8. [Hard Stops](#8-hard-stops)

---

## 1. Pre-Install Checklist

Before touching partitions or rebooting:

- [ ] Data backed up (documents, browser profiles, important files)
- [ ] Windows product key noted if needed later
- [ ] Ethernet cable available for the install (avoids Wi-Fi driver issues)
- [ ] USB drive ≥ 4 GB available (will be wiped)
- [ ] Admin access on the Windows machine

---

## 2. Hardware Inventory

Run this from an elevated Command Prompt to capture specs:

```bat
@echo off
mkdir "%USERPROFILE%\Desktop\ThinkPad-Linux-Install-Info"
set OUT=%USERPROFILE%\Desktop\ThinkPad-Linux-Install-Info\info.txt
echo === System Info === >> "%OUT%"
systeminfo >> "%OUT%"
echo === CPU === >> "%OUT%"
wmic cpu get Name,NumberOfCores,MaxClockSpeed >> "%OUT%"
echo === Disk === >> "%OUT%"
wmic diskdrive get Model,Size,MediaType >> "%OUT%"
echo === Logical Disks === >> "%OUT%"
wmic logicaldisk get DeviceID,Size,FreeSpace >> "%OUT%"
echo === RAM === >> "%OUT%"
wmic memorychip get Capacity,Speed >> "%OUT%"
echo Done. See Desktop\ThinkPad-Linux-Install-Info\info.txt
```

Check free space on C:. Rule of thumb for dual-boot:
- 100 GB free → shrink by 51200 MB, giving Linux ~50 GB
- 200 GB free → shrink by 102400 MB, giving Linux ~100 GB
- 300+ GB free → shrink by 153600 MB, giving Linux ~150 GB

---

## 3. Download Linux Mint and Rufus

Provide the user with these official links:

- Linux Mint XFCE (lightweight, good for headless): `https://www.linuxmint.com/download.php`
- Rufus (bootable USB tool): `https://rufus.ie/`
- Rufus 3.22 archive (last version with full Windows 7 BIOS support): `https://rufus.ie/downloads/?pubDate=20260128`

**Why Rufus 3.22**: newer versions dropped ISO mode for some older BIOS firmwares. Use 3.22 when targeting pre-2015 hardware.

---

## 4. Dual-Boot: Shrink C

Skip this section entirely for a clean wipe.

Open an elevated Command Prompt and run DiskPart manually:

```
diskpart
list disk
select disk 0
list volume
select volume C
shrink desired=102400
exit
```

Replace `102400` with the size in MB matching the recommendation from Step 2. Leave the result as **unallocated** — do not create or format a partition. Verify in Disk Management (`diskmgmt.msc`) that the unallocated block appears.

**Do not** use `create partition`, `format`, or `assign` commands. The Mint installer handles the rest.

---

## 5. Write the Bootable USB

Open Rufus. Settings:

| Setting | Value |
|---|---|
| Device | The USB drive (double-check — it will be wiped) |
| Boot selection | Select the Linux Mint ISO |
| Partition scheme | **MBR** |
| Target system | **BIOS (or UEFI-CSM)** |
| File system | FAT32 |
| Cluster size | Default |

Click **Start**. When prompted, choose **Write in ISO Image mode**. Wait for completion.

---

## 6. Boot From USB

1. Insert the USB drive.
2. Reboot the machine.
3. Tap the boot-menu key repeatedly as the machine starts — before the OS loads:
   - ThinkPad: **F12**
   - Dell: **F12**
   - HP: **F9** or **Esc then F9**
   - Lenovo (non-ThinkPad): **F12** or **Novo button**
   - Generic: **F11** or **Del**
4. Select the USB drive from the boot menu.

If the machine boots into Windows instead, the timing was off — reboot and try again, pressing the key as soon as the logo appears.

---

## 7. Run the Linux Mint Installer

In the live environment:

1. Double-click **Install Linux Mint** on the desktop.
2. Choose language, keyboard, and whether to install multimedia codecs (recommended).
3. At the **Installation type** screen:
   - **Dual-boot**: Select **Install Linux Mint alongside Windows**. Drag the divider to size the Linux partition using the unallocated space. Confirm.
   - **Clean wipe**: Select **Erase disk and install Linux Mint**. Confirm when warned all data will be lost.
4. Set timezone and create the user account. Choose a strong password — this becomes the sudo password.
5. Complete the installer. When prompted, remove the USB and press Enter to reboot.

After reboot, boot into Linux Mint. Proceed to `references/post-install.md`.

---

## 8. Hard Stops

**Stop and do not continue if:**

- The installer does not offer "Install Linux Mint alongside Windows" for dual-boot. This means the partition table may be GPT or the free space is not visible. Investigate before proceeding.
- Disk Management shows no unallocated space after the DiskPart shrink. Re-run shrink or check whether C: is fragmented (defrag and retry).
- The USB does not appear in the boot menu. Try a different USB port (prefer USB 2.0 on older machines), re-write the USB, or check if Secure Boot must be disabled in BIOS.
- The installer reports less disk space than expected. Abort and verify partitions before formatting anything.
