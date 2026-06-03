# Do Not Delete

P0 safety rules:

- Do not delete backups without asking Taylor first.
- Do not delete Docker volumes without asking Taylor first.
- Do not delete `/home/taylor/MacShare` without asking Taylor first.
- Do not remove the `uptime-kuma` Docker volume.
- Do not overwrite existing backups.
- Do not replace the full `/etc/samba/smb.conf` blindly.
- Do not disable SSH.
- Do not change firewall rules that could block SSH.

Preferred pattern:

1. Verify current state.
2. Back up first when touching service data.
3. Show Taylor the command and expected effect before destructive maintenance.
