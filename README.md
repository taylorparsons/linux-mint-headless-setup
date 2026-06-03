# Lenova — ThinkPad Admin Repo

Admin toolkit for Taylor's Lenovo ThinkPad T430 running Linux Mint XFCE as a dual-boot local server.

Linux Mint is installed and running. The ThinkPad is live on the LAN as a headless server.

## Using the Skill With Your Own Hardware

The `skills/headless-linux-server/` folder contains a reusable AI agent skill for converting any Windows PC or Intel iMac into a headless Linux Mint server. It is designed to work with agent frameworks that support skills or custom instructions — such as [Claude Code](https://claude.ai/code).

### What the skill covers

- Assessing your hardware (Windows PC vs iMac, BIOS vs EFI, RAM, disk)
- Choosing between dual-boot (keep Windows/macOS) or clean wipe (Linux only)
- Platform-specific install steps for Windows PCs and Intel iMacs
- Post-install: SSH, static IP, headless config, Docker, Caddy, Samba, VNC-over-SSH

### Folder structure

```
skills/headless-linux-server/
├── SKILL.md                     # Skill definition — tells the agent when and how to use it
└── references/
    ├── windows-bios.md          # Windows PC: Rufus USB, DiskPart shrink, F12 boot, Mint installer
    ├── imac-efi.md              # Intel iMac: Disk Utility shrink, Option-key boot, Mint installer
    └── post-install.md          # All platforms: SSH, key auth, Docker, Caddy, Samba, VNC-over-SSH
```

`SKILL.md` is the entry point. The agent reads it first to understand scope and routing, then pulls in the relevant reference file based on your hardware. Reference files are only loaded when needed so they don't fill up the context window on every message.

### Installing in Claude Code

Copy the skill folder into your Claude skills directory:

```sh
cp -r skills/headless-linux-server ~/.claude/skills/
```

Once installed, the skill activates automatically when you describe what you want to do. You do not need to reference the skill by name — just describe your goal:

- "I want to repurpose my old Dell as a home server"
- "Help me install Linux on my iMac"
- "Set up a headless Linux box with Docker and SSH"

The skill will ask about your hardware, walk through the install, and guide post-install setup.

### Using with other agent frameworks

The skill follows a standard structure: a `SKILL.md` frontmatter file and a `references/` folder of lazy-loaded markdown docs. Any framework that supports reading a skill definition and referencing supplemental files can use it. Point your agent at `SKILL.md` as the skill entrypoint.

---

## Quick Access

```sh
ssh thinkpad                        # SSH into the Lenovo
cd thinkpad-server-admin            # server admin scripts and docs
```

See `LENOVA-SSH.md` for SSH setup details and `thinkpad-server-admin/README.md` for server operations.

---

## What's In This Repo

### Server Admin (active use)

`thinkpad-server-admin/` — daily-use scripts, configs, and docs for the running server.

| Script | What it does |
|---|---|
| `scripts/verify-server.sh` | Read-only health check (SSH, Docker, SMB, HTTPS) |
| `scripts/backup-uptime-kuma.sh` | Timestamped Uptime Kuma Docker volume backup |
| `scripts/test-smb-share.sh` | Bidirectional SMB share test |
| `scripts/mac-setup-vnc.sh` | One-time VNC setup on Lenovo (runs with ssh -t) |
| `scripts/mac-open-vnc.sh` | Open macOS Screen Sharing via SSH tunnel |
| `scripts/verify-remote-desktop.sh` | Check VNC service, password file, and tunnel |
| `scripts/mac-setup-auto-updates.sh` | One-time auto-update setup on Lenovo |
| `scripts/mac-notify-updates.sh` | Check for pending updates and send Mac notification |

Docs: `docs/current-state.md`, `docs/remote-desktop.md`, `docs/updates.md`, `docs/recovery.md`, `docs/do-not-delete.md`

### SSH Runbook

`LENOVA-SSH.md` — how to enable SSH on the Lenovo, connect from macOS, and use sudo.

### Dual-Boot Setup (completed — reference only)

These files were used to install Linux Mint alongside Windows 7. The install is done; they are kept for reference.

| File | Purpose |
|---|---|
| `thinkpad-linux-preflight.bat` | Windows hardware/disk inventory — run before install |
| `download-mint-and-rufus.bat` | Opens official Linux Mint and Rufus download pages |
| `shrink-c-for-linux.txt` | Manual DiskPart commands to shrink C: |
| `mint-post-install.sh` | Post-install: updates, SSH, Git, dev tools, Avahi |

#### Install Sequence

1. On Windows: run `thinkpad-linux-preflight.bat`. It writes a `ThinkPad-Linux-Install-Info` folder to the Desktop with hardware details and safe shrink recommendations.
2. On Windows: run `download-mint-and-rufus.bat`. It opens the official Linux Mint XFCE download page and the Rufus archive page. Download **Rufus 3.22** (the last version with full Windows 7 BIOS compatibility) and the Linux Mint XFCE ISO.
3. On Windows: run DiskPart manually with the commands in `shrink-c-for-linux.txt`. Use `153600` MB to free about 150 GB. Leave the space **unallocated** — do not create or format a partition.
4. Insert the USB drive. Open Rufus. Select the ISO. Set **Partition scheme: MBR** and **Target system: BIOS (or UEFI-CSM)**. File system: FAT32. Click Start and write in ISO mode.
5. Reboot the ThinkPad. Tap **F12** repeatedly at the ThinkPad logo to reach the boot menu. Select the USB drive.
6. The system boots into the Linux Mint live environment. Double-click **Install Linux Mint** on the desktop.
7. Work through the installer. At the installation type screen, select **Install Linux Mint alongside Windows 7**. **Stop here if this option is not shown** — do not continue with "Erase disk" or "Something else" without reviewing the partition state first.
8. The installer shows a partition map. Drag the divider or accept the default to assign the unallocated space to Linux Mint. Confirm and proceed.
9. Complete the installer (timezone, user account, password). When it finishes, remove the USB and reboot.
10. Boot into Linux Mint. Run `mint-post-install.sh` to apply updates, install tools, enable SSH and Avahi, and print the SSH connection command.

Observed result: entering `153600` MB in Disk Management produced ~150 GB of unallocated space for Linux.

---

## Server Access

| Item | Value |
|---|---|
| Server IP | `<YOUR_IP>` |
| SSH alias | `ssh thinkpad` (see `LENOVA-SSH.md` for setup) |
| SSH user | `<YOUR_USERNAME>` |
| HTTPS Uptime Kuma | `https://<YOUR_IP>` |
| Finder share | `smb://<YOUR_IP>/<YOUR_SHARE_NAME>` |
| Mac mount path | `/Volumes/<YOUR_SHARE_NAME>` |
| VNC tunnel | `ssh thinkpad` then `./scripts/mac-open-vnc.sh` → `vnc://127.0.0.1:5902` |

---

## Safety Rules

- Do not store passwords in scripts, files, or shell history.
- Do not disable SSH or change firewall rules that could block SSH.
- Do not stop Docker unless needed for a specific command.
- Do not remove Docker volumes or delete backups.
- Do not replace `/etc/samba/smb.conf` blindly — use the `smb-<YOUR_SHARE_NAME>.conf` block only.
- Do not open VNC directly on the LAN. Keep it bound to Lenovo localhost and reach it via `ssh thinkpad`.

---

## Source Of Truth

This repo (`<YOUR_REPO_PATH>`) is the durable source. The Lenovo-hosted copy at `/Volumes/<YOUR_SHARE_NAME>/thinkpad-server-admin` is a mirror only — it can be lost if the Lenovo is wiped or the share is destroyed.

To refresh the mirror after mounting `smb://<YOUR_IP>/<YOUR_SHARE_NAME>`:

```sh
rsync -a --delete --exclude='.DS_Store' --exclude='._*' thinkpad-server-admin/ /Volumes/<YOUR_SHARE_NAME>/thinkpad-server-admin/
```
