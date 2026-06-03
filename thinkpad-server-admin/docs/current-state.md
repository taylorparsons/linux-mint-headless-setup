# Current State

This document records the known state for Taylor's Lenovo ThinkPad T430 local server. It intentionally does not store actual passwords.

## P0 Access

- Mac user appears to be `taylorparsons`.
- Mac can SSH to the Lenovo with `ssh thinkpad`.
- Mac SSH config:

```sshconfig
Host thinkpad
  HostName 192.168.1.60
  User taylor
```

- Reserved LAN IP: `192.168.1.60`.
- SSH user: `taylor`.
- Host prompt observed as `taylor@taylor-ThinkPad-T430:~$`.
- Laptop lid is closed and the server remains reachable.
- SSH survived reboot.

## System

- Device: old Lenovo ThinkPad T430.
- OS: Linux Mint 22.3 Zena.
- Ubuntu base: noble.
- Kernel: 6.17.0-35-generic.
- Architecture: x86_64.
- Virtualization: VT-x.
- RAM: 7.5 GiB total, about 6.5 GiB available when checked.
- Swap: 2.0 GiB.
- Root partition: `/dev/sda5`, 147G size, 128G available, 9 percent used when checked.
- Docker is a good fit for lightweight local services.

## Docker

- Docker installed and enabled.
- Docker 29.1.3 observed on client and server.
- Docker service status observed as active and enabled.
- Docker survived reboot.
- Uptime Kuma survived reboot.
- Uptime Kuma container:
  - Name: `uptime-kuma`
  - Image: `louislam/uptime-kuma:1`
  - Restart policy: `always`
  - Docker volume: `uptime-kuma`
  - Expected bind: `127.0.0.1:3001:3001`
- Direct LAN HTTP access to `http://192.168.1.60:3001` should not load.
- Caddy should be the only network-facing path to Uptime Kuma.

## Caddy And HTTPS

- Caddy is installed on the Lenovo.
- Caddy is used as a reverse proxy for HTTPS.
- Normal browser access from the Mac: `https://192.168.1.60`.
- Caddy internal root certificate was copied to the Mac and trusted.
- Chrome should load `https://192.168.1.60` without the privacy warning after restart.
- If testing before trust: `curl -k -I https://192.168.1.60`.
- If testing after trust: `curl -I https://192.168.1.60`.
- Good response can be HTTP 200 or HTTP 302.

## Samba And Finder

- Samba installed and running.
- Share folder on Lenovo: `/home/taylor/MacShare`.
- Share name: `MacShare`.
- Finder connection: `smb://192.168.1.60/MacShare`.
- Mac mounted path: `/Volumes/MacShare`.
- Samba user: `taylor`.
- Finder login name: `taylor`.
- Finder password is the Samba password created with `sudo smbpasswd -a taylor`.
- Do not use Mac username `taylorparsons` for SMB login.
- Warning observed: `WARNING: The 'netbios name' is too long (max. 15 chars).`
- The warning is not blocking the share.
- Optional cleanup: set `netbios name = THINKPAD` under `[global]` in `/etc/samba/smb.conf`.

## Firewall

- No current firewall rule changes are recorded in this project.
- P0: Do not change firewall rules that could block SSH.
- If firewall diagnostics are needed, first inspect with `ssh thinkpad 'sudo ufw status verbose'`.

## Password Prompt Guide

- `taylor@192.168.1.60's password:` means Lenovo Linux password.
- `[sudo] password for taylor:` on SSH means Lenovo Linux password.
- macOS Keychain or local Mac sudo prompt means Mac login/admin password.
- Finder SMB login uses the Samba password, which may differ from both.
- Do not store actual passwords in this project.

## Remote Desktop

- A TigerVNC virtual desktop is configured for display `:2`.
- Display `:0` and `:1` are taken by the physical Xorg session. VNC uses `:2` (port `5902`).
- The Lenovo can report `A X11 server is already running for display :1`; that means Xorg owns `:1`, which is expected.
- Primary Mac opener: `./scripts/mac-open-vnc.sh`.
- Initial setup wrapper: `./scripts/mac-setup-vnc.sh`.
- The Mac opener should reuse or create a local tunnel on `127.0.0.1:5902` and then open macOS Screen Sharing.
- Observed Screen Sharing error: `Connection failed to "127.0.0.1:5902"`.
- Recovery command sequence:

```sh
./scripts/verify-remote-desktop.sh
./scripts/mac-open-vnc.sh
ssh thinkpad 'vncserver -list'
ssh -N -L 5902:127.0.0.1:5902 thinkpad
```
