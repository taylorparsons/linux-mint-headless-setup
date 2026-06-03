# Recovery

Use these diagnostics before making changes. When a command prompts for `taylor` over SSH or `[sudo]`, use the Lenovo Linux password.

## P0 SSH Fails

From the Mac:

```sh
ssh -v thinkpad
ssh taylor@192.168.1.60
ping 192.168.1.60
nc -z -G 5 192.168.1.60 22
```

On the Lenovo console if local access is needed:

```sh
ip addr
systemctl status ssh
sudo systemctl enable --now ssh
sudo ufw status verbose
```

Do not change firewall rules that could block SSH unless Taylor explicitly approves.

## P1 Uptime Kuma Is Down

```sh
ssh thinkpad 'docker ps --filter name=uptime-kuma'
ssh thinkpad 'docker inspect uptime-kuma --format "{{.State.Status}} {{.HostConfig.RestartPolicy.Name}}"'
ssh thinkpad 'docker logs --tail 100 uptime-kuma'
ssh thinkpad 'docker volume inspect uptime-kuma'
```

Expected container bind is `127.0.0.1:3001:3001`. Do not remove the `uptime-kuma` Docker volume.

## P1 Caddy Fails

```sh
ssh thinkpad 'systemctl status caddy --no-pager'
ssh thinkpad 'sudo caddy validate --config /etc/caddy/Caddyfile'
ssh thinkpad 'sudo journalctl -u caddy -n 100 --no-pager'
curl -k -I https://192.168.1.60
```

Known working Caddyfile is stored in `configs/Caddyfile`.

## P1 Finder Cannot Connect

From Finder, use:

```text
smb://192.168.1.60/MacShare
```

From the Mac terminal:

```sh
nc -z -G 5 192.168.1.60 445
mount | grep MacShare
ls -la /Volumes/MacShare
```

From the Lenovo:

```sh
ssh thinkpad 'systemctl status smbd --no-pager'
ssh thinkpad 'testparm -s'
ssh thinkpad 'ls -ld /home/taylor/MacShare'
```

## P1 SMB Password Fails

- Finder login name should be `taylor`, not `taylorparsons`.
- Finder password is the Samba password created with `sudo smbpasswd -a taylor`.
- It may differ from the Lenovo Linux password and Mac password.

Diagnostic commands:

```sh
ssh thinkpad 'sudo pdbedit -L | grep "^taylor:"'
ssh thinkpad 'sudo smbpasswd -a taylor'
```

The `smbpasswd` command changes the Samba password. Run it only when Taylor is ready to set or reset that credential.

## P1 Browser Shows Certificate Warning Again

```sh
curl -k -I https://192.168.1.60
ssh thinkpad 'systemctl status caddy --no-pager'
ssh thinkpad 'sudo caddy trust'
```

If Chrome still warns, restart Chrome and confirm the Caddy internal root certificate is trusted on the Mac. Before trust, use `curl -k -I https://192.168.1.60`; after trust, use `curl -I https://192.168.1.60`.

## P1 Remote Desktop Does Not Open

```sh
./scripts/verify-remote-desktop.sh
./scripts/mac-open-vnc.sh
nc -z 127.0.0.1 5902
ssh thinkpad 'vncserver -list'
ssh thinkpad 'ss -ltn | grep 5902'
```

Observed Mac error:

```text
Connection failed to "127.0.0.1:5902"
```

If you see that message, check the local tunnel first with `nc -z 127.0.0.1 5902`. If `ssh thinkpad 'vncserver -list'` shows `:2`, the Linux desktop is already up. Focus on the local tunnel and Screen Sharing step rather than restarting VNC.
