# ThinkPad Server Admin

Small admin project for Taylor's Lenovo ThinkPad T430 running Linux Mint as a local headless server. It documents the current known state, stores reference configs, and provides Mac-run scripts for verification, Uptime Kuma backups, and SMB share testing.

No passwords are stored here. Do not delete backups, Docker volumes, or `/home/taylor/MacShare` without asking Taylor first.

## Source Of Truth

The durable source of truth is:

```text
/Volumes/T9/code/lenova/thinkpad-server-admin
```

The Lenovo-hosted copy at `/Volumes/MacShare/thinkpad-server-admin` is only a mirror/deploy target. It can be lost if the Lenovo is terminated, rebuilt, or its share is destroyed.

To refresh the mirror after mounting Finder share `smb://192.168.1.60/MacShare`, run from `/Volumes/T9/code/lenova`:

```sh
rsync -a --delete --exclude='.DS_Store' --exclude='._*' thinkpad-server-admin/ /Volumes/MacShare/thinkpad-server-admin/
```

Do not use the mirror as the only copy.

## Access

| Item | Value |
| --- | --- |
| Server IP | `192.168.1.60` |
| SSH alias | `ssh thinkpad` |
| SSH user | `taylor` |
| HTTPS Uptime Kuma | `https://192.168.1.60` |
| Finder share | `smb://192.168.1.60/MacShare` |
| Mac mount path | `/Volumes/MacShare` |
| Lenovo share path | `/home/taylor/MacShare` |

## Key Commands

```sh
ssh thinkpad
./scripts/mac-setup-vnc.sh
./scripts/mac-open-vnc.sh
./scripts/verify-server.sh
./scripts/backup-uptime-kuma.sh
./scripts/test-smb-share.sh
./scripts/verify-remote-desktop.sh
curl -I https://192.168.1.60
curl -k -I https://192.168.1.60
```

Use `curl -k` only before the Caddy internal root certificate is trusted on the Mac. A good HTTPS response can be `HTTP 200` or `HTTP 302`.

## Maintenance Checklist

- P0: Confirm SSH works before changing server services: `ssh thinkpad`.
- P0: Do not change firewall rules that could block SSH.
- P0: Do not delete `/home/taylor/MacShare`, Docker volumes, or backups without asking Taylor.
- P1: Run `./scripts/verify-server.sh` after reboot or service changes.
- P1: Back up Uptime Kuma before upgrades: `./scripts/backup-uptime-kuma.sh`.
- P1: Keep Uptime Kuma bound to `127.0.0.1:3001`; Caddy should be the only LAN-facing path.
- P2: Test Finder sharing with `./scripts/test-smb-share.sh` after Samba changes.
- P3: Optionally set Samba `netbios name = THINKPAD` to silence the long NetBIOS warning.

## Project Files

- `docs/current-state.md`: Known server state and password prompt guide.
- `docs/remote-desktop.md`: TigerVNC virtual XFCE desktop through SSH tunnel for Mac Screen Sharing.
- `docs/recovery.md`: Diagnostic commands for common failures.
- `docs/do-not-delete.md`: Safety rules for backups, volumes, and shares.
- `configs/Caddyfile`: Known working Caddy reverse proxy config.
- `configs/smb-MacShare.conf`: Samba share block only.
- `configs/mac-ssh-config-snippet`: Mac SSH alias.
- `scripts/verify-server.sh`: Read-only verification from the Mac.
- `scripts/backup-uptime-kuma.sh`: Timestamped Uptime Kuma Docker volume backup.
- `scripts/test-smb-share.sh`: Bidirectional SMB visibility test.
- `scripts/mac-setup-vnc.sh`: Uploads and runs the Lenovo VNC setup with a remote TTY for sudo and VNC password prompts.
- `scripts/mac-open-vnc.sh`: Starts the SSH-tunneled Mac Screen Sharing path.
- `scripts/verify-remote-desktop.sh`: Confirms the VNC service, password file, and local tunnel state.
