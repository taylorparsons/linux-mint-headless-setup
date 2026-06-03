# ATHENA Index: lenova

**Generated:** 2026-06-03

## Active Features

None.

## Archived Features

### 20260602-thinkpad-linux-mint-dual-boot
**Status:** Done  
**Shipped:** Yes

Windows-to-Linux dual-boot preparation suite for Lenovo ThinkPad. Includes Windows batch preflight, DiskPart shrink script, Linux Mint post-install helper, and runbook covering safe partitioning, USB creation, and SSH setup.

**Key Files:**
- `<YOUR_REPO>/thinkpad-linux-preflight.bat` — System inventory and C: space analysis
- `<YOUR_REPO>/download-mint-and-rufus.bat` — Official download links and Windows 7 archive guidance
- `<YOUR_REPO>/shrink-c-for-linux.txt` — DiskPart manual shrink (102400 MB default, 153600 MB alt)
- `<YOUR_REPO>/mint-post-install.sh` — Package update, tool install, SSH/Avahi enable
- `<YOUR_REPO>/README.md` — Complete dual-boot workflow with hard stops at unsafe points

**Test Result:** Pass (validated scripts, no partition-changing commands)

---

### 20260603-lenova-ssh-runbook
**Status:** Done  
**Shipped:** Yes

Dedicated SSH runbook for Mac-to-Lenovo connectivity. Explains SSH startup on Lenovo, connection from macOS with IP/`.local` hostname, and sudo-based admin access without root SSH login.

**Key Files:**
- `<YOUR_REPO>/LENOVA-SSH.md` — SSH setup, connection methods, admin access guidance

**Test Result:** Pass (runbook content verified)

---

### 20260603-thinkpad-server-admin
**Status:** Done  
**Shipped:** Yes

Mac-side project documenting Linux Mint server state, with verification scripts, backup automation, recovery guardrails, and SSH-tunneled TigerVNC remote desktop for macOS Screen Sharing. Durable source at `<YOUR_REPO>/thinkpad-server-admin`; `/Volumes/MacShare/thinkpad-server-admin` is a mirror only.

**Key Files:**
- `<YOUR_REPO>/thinkpad-server-admin/README.md` — Project overview and access paths
- `<YOUR_REPO>/thinkpad-server-admin/docs/server-state.md` — Known server config, Docker services, Samba/Caddy/SSH details
- `<YOUR_REPO>/thinkpad-server-admin/docs/remote-desktop.md` — TigerVNC XFCE setup, SSH tunnel (127.0.0.1:5902), Screen Sharing connection
- `<YOUR_REPO>/thinkpad-server-admin/docs/updates.md` — Manual updates, unattended-upgrades setup, Mac notification cron
- `<YOUR_REPO>/thinkpad-server-admin/docs/recovery.md` — Failure modes, diagnostic commands, `:2`/`5902` display root cause
- `<YOUR_REPO>/thinkpad-server-admin/scripts/verify-server.sh` — Read-only server health check (SSH, Docker, SMB, HTTPS)
- `<YOUR_REPO>/thinkpad-server-admin/scripts/backup-uptime-kuma.sh` — Timestamped non-overwriting Docker volume backup
- `<YOUR_REPO>/thinkpad-server-admin/scripts/test-smb-share.sh` — Bidirectional SMB `/Volumes/MacShare` visibility test
- `<YOUR_REPO>/thinkpad-server-admin/scripts/linux-setup-vnc.sh` — TigerVNC/XFCE package install and vncpasswd config (fails fast on errors)
- `<YOUR_REPO>/thinkpad-server-admin/scripts/linux-start-vnc.sh` — Start vncserver on `:2` (port 5902)
- `<YOUR_REPO>/thinkpad-server-admin/scripts/linux-stop-vnc.sh` — Stop vncserver
- `<YOUR_REPO>/thinkpad-server-admin/scripts/mac-setup-vnc.sh` — Upload and run Linux setup with ssh -t for TTY prompts
- `<YOUR_REPO>/thinkpad-server-admin/scripts/mac-open-vnc.sh` — Establish SSH tunnel, open macOS Screen Sharing (primary opener)
- `<YOUR_REPO>/thinkpad-server-admin/scripts/linux-setup-auto-updates.sh` — One-time unattended-upgrades setup and apt cache cron
- `<YOUR_REPO>/thinkpad-server-admin/scripts/mac-notify-updates.sh` — Mac daily notification of pending updates

**Test Result:** Pass (9/9 unit tests, syntax checks, live Screen Sharing verified)  
**Root Cause Documented:** Xorg owns displays `:0` and `:1`; VNC uses `:2`/`5902` to avoid conflicts

---

## Retrieval Notes

- To retrieve a feature summary: Check above section for feature ID, key files, and test status
- All features are shipped and archived; no active work remains
- PR: Refer to `<YOUR_REPO>/docs/PRD.md` for requirement/shipped mapping
- Progress: Refer to `<YOUR_REPO>/docs/progress.txt` (pruned version)
