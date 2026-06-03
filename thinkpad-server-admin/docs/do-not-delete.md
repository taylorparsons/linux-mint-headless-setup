# Do Not Delete

P0 safety rules:

- Do not delete backups without asking the repo owner first.
- Do not delete Docker volumes without asking the repo owner first.
- Do not delete `/home/<YOUR_USERNAME>/<YOUR_SHARE_NAME>` without asking the repo owner first.
- Do not remove the `uptime-kuma` Docker volume.
- Do not overwrite existing backups.
- Do not replace the full `/etc/samba/smb.conf` blindly.
- Do not disable SSH.
- Do not change firewall rules that could block SSH.

Preferred pattern:

1. Verify current state.
2. Back up first when touching service data.
3. Show the owner the command and expected effect before destructive maintenance.
