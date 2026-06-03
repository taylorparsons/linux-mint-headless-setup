# Lenovo ThinkPad Linux Mint XFCE Dual-Boot Helper

## Scripts

### `thinkpad-linux-preflight.bat`
- Creates `ThinkPad-Linux-Install-Info` on the Windows Desktop.
- Saves hardware and disk reports there.
- Checks C: free space.
- Recommends a manual shrink size.
- Prints Disk Management steps.
- Does not change partitions.

### `download-mint-and-rufus.bat`
- Creates `Linux-Mint-Download` on the Windows Desktop.
- Opens the official Linux Mint XFCE, Rufus, and archived Rufus 3.22 pages.
- Points you to the working Windows 7-compatible `Rufus 3.22` archive entry.
- Saves a status file with the links and result.
- Does not change partitions or boot settings.

### `shrink-c-for-linux.txt`
- Manual DiskPart commands only.
- Default shrink is `102400` MB.
- Includes a `153600` MB alternative as a comment.
- Leaves the new space unallocated.
- Does not create or format partitions.

### `mint-post-install.sh`
- Updates Linux Mint packages.
- Installs SSH, Git, curl, wget, htop, neofetch, build tools, and Avahi.
- Enables SSH and Avahi.
- Prints SSH commands for your MacBook.

### `LENOVA-SSH.md`
- Dedicated SSH runbook for Mac-to-Lenovo access.
- Shows how to enable SSH on the Lenovo.
- Shows the IP and `.local` connection commands.
- Shows how to use `sudo` for admin access.

## Exact Order To Run

1. In Windows 7, copy `thinkpad-linux-preflight.bat` to the ThinkPad.
2. Double-click `thinkpad-linux-preflight.bat`.
3. Open the Desktop folder `ThinkPad-Linux-Install-Info` and review the saved reports.
4. Double-click `download-mint-and-rufus.bat`.
5. Let it open the official download pages, including the Rufus 3.22 archive page.
6. Open the Desktop folder `Linux-Mint-Download` and confirm `download-status.txt` was created.
7. If the script warns that free space is under `200 GB`, stop and clean up files before doing anything else.
8. If you want Linux space now, stop here and confirm before running any partition step.
9. If you choose to shrink C: manually, use Disk Management first:
   - Press `Windows + R`
   - Type `diskmgmt.msc`
   - Right-click `C:`
   - Click `Shrink Volume...`
   - Enter `102400` for about `100 GB` or `153600` for about `150 GB`
   - Leave the result as **Unallocated**
   - Do not create a new partition in Windows
10. If you choose the optional DiskPart route instead, read `shrink-c-for-linux.txt` first and only then run:

```bat
diskpart /s shrink-c-for-linux.txt
```

11. Create the Linux Mint USB.
12. Boot the ThinkPad from the USB and test the live session.
13. Install Linux Mint only if the installer shows **Install Linux Mint alongside Windows 7**.
14. After Linux Mint is installed, run `mint-post-install.sh`.
15. From your MacBook, connect with SSH.
16. If you want a shorter SSH-only guide, open `LENOVA-SSH.md`.

Observed result on the target ThinkPad:
- Entering `153600` in Disk Management produced about `150 GB` of **Unallocated** space.

## Linux Mint USB Creation On Windows 7

1. Run `download-mint-and-rufus.bat` first.
2. Download Linux Mint XFCE 64-bit from:
   - `https://www.linuxmint.com/download.php`
   - `https://www.linuxmint.com/edition.php?id=327`
3. Download Rufus from:
   - `https://rufus.ie/`
   - `https://rufus.ie/downloads/?pubDate=20260128`
4. Use **Rufus 3.22** on Windows 7.
   - As of June 2, 2026, newer Rufus builds target Windows 8 or newer.
   - If an older direct `rufus-3.22.exe` link returns `404`, use the archived downloads index above and click the `Rufus 3.22` entry there.
5. Insert the USB flash drive.
6. Open Rufus.
7. Choose the Linux Mint XFCE ISO.
8. Use these Rufus settings:
   - Partition scheme: `MBR`
   - Target system: `BIOS or UEFI`
   - File system: `FAT32` if available
   - If Rufus asks how to write the image, choose `ISO Image mode`
9. Click `Start`.
10. Wait for Rufus to finish.
11. Verify the USB is ready:
    - Rufus shows `READY`
    - The USB now has visible boot files
    - Safely eject the USB

## Manual Boot Steps

1. Shut down the Lenovo.
2. Insert the Linux Mint USB.
3. Power on the laptop.
4. Tap F12 repeatedly.
5. Choose `USB HDD` or `USB Storage`.
6. Start the Linux Mint live session.
7. Test Wi-Fi, keyboard, trackpad, screen, and sound.
8. Click `Install Linux Mint`.
9. Choose **Install Linux Mint alongside Windows 7** if available.
10. Stop if the installer does not show that option.

Do not wipe the drive. Do not delete partitions. Do not format the Windows partition.

## Linux Mint Post-Install

1. Copy `mint-post-install.sh` onto the new Linux Mint system.
2. Open Terminal.
3. Run:

```bash
chmod +x mint-post-install.sh
./mint-post-install.sh
```

4. When the script finishes, note the IP address it prints.
5. Also note the `.local` hostname command it prints.

## Mac SSH Commands

Use the exact command format below from macOS:

```bash
ssh <linux-username>@<thinkpad-ip-address>
ssh <linux-username>@<hostname>.local
```
