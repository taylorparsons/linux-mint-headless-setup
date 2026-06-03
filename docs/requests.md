# Customer Requests

## CR-20260602-1253
- Timestamp: 2026-06-02 12:53 America/Los_Angeles
- Request:
  > You are an automation engineer helping me prepare an older Lenovo ThinkPad for Linux Mint XFCE dual boot with Windows 7.
  >
  > Goal:
  > Automate as much as possible using scripts and code on the Lenovo, while keeping Windows 7 intact.
  >
  > Machine details:
  >
  > * Lenovo ThinkPad
  > * Model: 23474Q7
  > * Current OS: Windows 7 Enterprise SP1 64-bit
  > * RAM: 8 GB
  > * Internal disk: HGST HTS725050A7E630 ATA Device
  > * Disk size: about 500 GB
  > * C: drive filesystem: NTFS
  > * C: drive total size: 500,000,878,592 bytes
  > * C: drive free space: 375,753,665,560 bytes
  > * Goal: dual boot Windows 7 and Linux Mint XFCE 64-bit
  > * Desired Linux space: 100 GB to 150 GB
  >
  > What I want you to do:
  > Create scripts and command-line steps to automate everything possible before and after the manual boot/install process.
  >
  > Important limits:
  >
  > * You cannot physically press F12 for me.
  > * You cannot boot the machine into the USB for me unless the BIOS/boot configuration supports it and it is safe.
  > * You cannot complete the Linux Mint GUI installer without me interacting with the laptop.
  > * Do not wipe the disk.
  > * Do not delete partitions.
  > * Do not format the Windows partition.
  > * Do not run destructive disk commands without stopping and asking for confirmation.
  > * Assume I am not an expert and I may be typing commands by hand.
  >
  > Phase 1, Windows 7 preflight automation:
  > Create a Windows batch script named `thinkpad-linux-preflight.bat` that:
  >
  > 1. Creates a folder on the Desktop named `ThinkPad-Linux-Install-Info`.
  > 2. Captures system information into text files:
  >
  >    * systeminfo
  >    * computer system info
  >    * CPU info
  >    * BIOS info
  >    * physical disk info
  >    * logical disk info
  >    * memory info
  >    * graphics info
  >    * network adapter info
  > 3. Saves all outputs into the Desktop folder.
  > 4. Checks C: drive free space.
  > 5. Prints a recommendation:
  >
  >    * If free space is over 200 GB, recommend shrinking C: by 102400 MB or 153600 MB.
  >    * If free space is under 200 GB, warn me not to continue without cleanup.
  > 6. Prints exact Disk Management steps for shrinking C:.
  > 7. Does not shrink the partition automatically unless I explicitly ask for a separate script.
  > 8. Gives me a final checklist before creating the Linux USB.
  >
  > Phase 2, optional Windows partition shrink script:
  > Create a second script named `shrink-c-for-linux.txt` that contains DiskPart commands but does not run automatically.
  >
  > The script should:
  >
  > * Shrink C: by 102400 MB by default.
  > * Include a commented alternative for 153600 MB.
  > * Leave the new space unallocated.
  > * Not format the unallocated space.
  > * Not create Linux partitions.
  > * Include warnings at the top.
  >
  > Also tell me exactly how to run it manually only if I choose to.
  >
  > Phase 3, Linux Mint USB creation:
  > Provide a Windows 7-friendly path for creating the USB.
  >
  > Tell me:
  >
  > 1. Where to download Linux Mint XFCE 64-bit.
  > 2. Where to download Rufus.
  > 3. What Rufus settings to use:
  >
  >    * Partition scheme: MBR
  >    * Target system: BIOS or UEFI
  >    * File system: FAT32 if available
  >    * Write in ISO Image mode if asked
  > 4. How to verify the USB is ready.
  >
  > Do not assume PowerShell 7 or modern Windows tools are available.
  >
  > Phase 4, manual boot instructions:
  > Tell me the physical steps:
  >
  > 1. Shut down Lenovo.
  > 2. Insert USB.
  > 3. Power on.
  > 4. Tap F12 repeatedly.
  > 5. Choose USB HDD or USB Storage.
  > 6. Start Linux Mint live session.
  > 7. Test Wi-Fi, keyboard, trackpad, screen, sound.
  > 8. Click Install Linux Mint.
  > 9. Choose “Install Linux Mint alongside Windows 7” if available.
  > 10. Stop if the installer does not show that option.
  >
  > Phase 5, Linux post-install automation:
  > Create a Bash script named `mint-post-install.sh` that I can run after Linux Mint is installed.
  >
  > The script should:
  >
  > 1. Update apt package lists.
  > 2. Upgrade installed packages.
  > 3. Install:
  >
  >    * openssh-server
  >    * git
  >    * curl
  >    * wget
  >    * htop
  >    * neofetch
  >    * build-essential
  >    * avahi-daemon
  > 4. Enable and start SSH.
  > 5. Enable and start Avahi.
  > 6. Print the machine’s IP address.
  > 7. Print the SSH command I should use from my MacBook.
  > 8. Print the `.local` hostname SSH option if Avahi is working.
  >
  > Phase 6, Mac SSH instructions:
  > Give me the exact command format from macOS:
  >
  > ssh <linux-username>@<thinkpad-ip-address>
  >
  > Also include the hostname option:
  >
  > ssh <linux-username>@<hostname>.local
  >
  > Output format:
  >
  > * Give me the scripts first.
  > * Then give me the exact order to run them.
  > * Keep steps short.
  > * Use plain language.
  > * Stop before risky partition steps and ask for confirmation.
  > * Do not tell me to erase the disk.
  > * Do not tell me to delete Windows.

## CR-20260602-1301
- Timestamp: 2026-06-02 13:01 America/Los_Angeles
- Request:
  > Implement the plan.

## CR-20260602-1330
- Timestamp: 2026-06-02 13:30 America/Los_Angeles
- Request:
  > create a script to do this on the lenova for me
  >
  > Download Linux Mint XFCE 64-bit from:
  > https://www.linuxmint.com/download.php
  > https://www.linuxmint.com/edition.php?id=327
  > Download Rufus from:
  > https://rufus.ie/
  > https://rufus.ie/downloads/

## CR-20260602-1342
- Timestamp: 2026-06-02 13:42 America/Los_Angeles
- Request:
  > update the athena docs if anything changed

## CR-20260603-0930
- Timestamp: 2026-06-03 09:30 America/Los_Angeles
- Request:
  > put all of the instruction in a md file

## CR-20260603-0000
- Timestamp: 2026-06-03 00:00 America/Los_Angeles
- Request:
  > Paste this into Codex. I wrote it as a seeded handoff prompt with current state, paths, priorities, and guardrails.
  >
  > You are taking over a local headless Linux Mint server setup from a Mac.
  >
  > Your job is to create a small, clean project that documents the current server state, adds verification scripts, and prepares safe maintenance scripts. Do not delete anything. Do not overwrite existing backups. Ask before destructive actions.
  >
  > Preferred project location from the Mac: `/Volumes/MacShare/thinkpad-server-admin`
  >
  > If `/Volumes/MacShare` is not mounted, do not guess. Tell the user to mount Finder share first using: `smb://192.168.1.60/MacShare`
  >
  > Create `README.md`, `docs/current-state.md`, `configs/Caddyfile`, `configs/smb-MacShare.conf`, `configs/mac-ssh-config-snippet`, `scripts/verify-server.sh`, `scripts/backup-uptime-kuma.sh`, `scripts/test-smb-share.sh`, `docs/recovery.md`, and `docs/do-not-delete.md`.
  >
  > Scripts should run from the Mac. `verify-server.sh` should check SSH, Docker, uptime-kuma, Caddy, HTTPS, Samba port 445, and `/Volumes/MacShare` without changing anything. `backup-uptime-kuma.sh` should create timestamped, non-overwriting Docker volume backups under `/home/taylor/server-backups` on the Lenovo. `test-smb-share.sh` should test Mac-to-Lenovo and Lenovo-to-Mac file visibility, asking before deleting test files or leaving timestamped files.
  >
  > Guardrails: Do not store passwords. Do not disable SSH. Do not stop Docker unless needed for a specific command. Do not remove Docker volumes. Do not delete backups. Do not replace full `/etc/samba/smb.conf` blindly. Do not change firewall rules that could block SSH. Prefer verification before modification. When a command prompts for a password, clearly say which machine password is needed. Use priority labels: P0 access or safety critical, P1 important for server function, P2 useful maintenance, P3 optional cleanup.
  >
  > Suggested first actions: check whether `/Volumes/MacShare` exists, create `/Volumes/MacShare/thinkpad-server-admin`, create the files, make scripts executable, run `scripts/verify-server.sh`, report PASS/FAIL, and do not make server changes until verification output is shown to Taylor.

## CR-20260603-1226
- Timestamp: 2026-06-03 12:26 America/Los_Angeles
- Request:
  > I just want to make this files here /Volumes/MacShare/thinkpad-server-admin will be destoyed if the lenova is terminaated I would suggest usig this locatation for a project /Volumes/T9/code/lenova

## CR-20260603-1239
- Timestamp: 2026-06-03 12:39 America/Los_Angeles
- Request:
  > Implement the plan.

## CR-20260603-1250
- Timestamp: 2026-06-03 12:50 America/Los_Angeles
- Request:
  > I ran is and got this
  > thinkpad-server-admin ssh thinkpad 'bash -s' < scripts/linux-setup-vnc.sh
  > taylor@192.168.1.60's password:
  > Installing TigerVNC virtual XFCE desktop packages.
  > If sudo asks for a password, use the Lenovo Linux password for user taylor.
  > sudo: a terminal is required to read the password; either use the -S option to read from standard input or configure an askpass helper
  > sudo: a password is required
  > sudo: a terminal is required to read the password; either use the -S option to read from standard input or configure an askpass helper
  > sudo: a password is required
  > Wrote ~/.vnc/xstartup for XFCE.
  > No VNC password file found. Run vncpasswd now and do not store the password in this repo.
  > bash: line 35: vncpasswd: command not found
  > Setup complete. From the Mac project directory, start VNC with:
  > ssh thinkpad 'bash -s' < scripts/linux-start-vnc.sh
  >
  > Do better

## CR-20260603-1303
- Timestamp: 2026-06-03 13:03 America/Los_Angeles
- Request:
  > I am not seeing this open vnc://127.0.0.1:5901
  >
  > it returned this Starting TigerVNC on :1, bound to Lenovo localhost only.
  > A X11 server is already running for display :1 on machine taylor-ThinkPad-T430.

## CR-20260603-1304
- Timestamp: 2026-06-03 13:04 America/Los_Angeles
- Request:
  > update all documentation state I will hand this off to claude to finish

## CR-20260603-1313
- Timestamp: 2026-06-03 13:13 America/Los_Angeles
- Request:
  > <image name=[Image #1]>
  > after the last update I get this error document it [Image #1]

## CR-20260603-1341
- Timestamp: 2026-06-03 13:41 America/Los_Angeles
- Request:
  > add this to the documentation, I want this to happen automatically it let me know via the mac that it needs to be dealt with

## CR-20260603-1400
- Timestamp: 2026-06-03 14:00 America/Los_Angeles
- Request:
  > use superpowers to fix this work that codex started but failed to complete before I ran out of tokens
  > Documented the exact failure Connection failed to "127.0.0.1:5901" in the handoff docs.
  >
  > Updated:
  > - thinkpad-server-admin/docs/current-state.md
  > - thinkpad-server-admin/docs/recovery.md
  > - thinkpad-server-admin/docs/remote-desktop.md
  > - ATHENA state in docs/requests.md, docs/decisions.md, docs/PRD.md, docs/specs/20260603-thinkpad-server-admin/spec.md, docs/specs/20260603-thinkpad-server-admin/tasks.md, and docs/progress.txt
  >
  > Verification:
  > - python3 -m unittest tests/test_install_assets.py -> 8/8 passing
  > - rg confirms the exact failure text and recovery checks are in the docs

## CR-20260603-1600
- Timestamp: 2026-06-03 16:00 America/Los_Angeles
- Request:
  > yes I want all steps accounted for
  >
  > Context: after reviewing a full numbered step list of the dual-boot + SSH setup, user confirmed that
  > all missing steps should be added to the repo docs. Gap identified:
  > - README.md missing steps 6-11: Rufus USB write settings, F12 boot menu, booting from USB into
  >   live environment, "Install alongside Windows 7" choice, pointing installer at unallocated space,
  >   completing install and rebooting.
  > - LENOVA-SSH.md missing steps 13/14/16/18: router static IP reservation note, ssh-keygen on Mac,
  >   ssh-copy-id to Lenovo, verifying passwordless ssh thinkpad.

## CR-20260603-1700
- Timestamp: 2026-06-03 17:00 America/Los_Angeles
- Request:
  > create add a new skill to the source code that can be used to convert any windows or imac to a headless linux server.

## CR-20260603-1800
- Timestamp: 2026-06-03 18:00 America/Los_Angeles
- Request:
  > add the skill to the project and check in headless-linux-server/references/imac-efi.md
