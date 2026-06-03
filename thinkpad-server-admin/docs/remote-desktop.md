# Remote Desktop

This sets up a manual-start TigerVNC virtual XFCE desktop on the Lenovo and connects from the Mac with Mac Screen Sharing through an SSH tunnel.

P0 safety rules:

- Do not store the VNC password in this repo.
- Do not open VNC directly on the LAN.
- Do not add firewall rules for VNC.
- Keep VNC bound to Lenovo localhost and reach it with `ssh thinkpad`.

## Install From The Mac

Run the setup script over SSH:

```sh
./scripts/mac-setup-vnc.sh
```

If SSH or sudo asks for a password, use the Lenovo Linux password for user `<YOUR_USERNAME>`.

The Mac wrapper uploads the Linux setup script to a temporary file on the Lenovo, then runs it with `ssh -t thinkpad` so `sudo` and `vncpasswd` can prompt correctly. The setup installs TigerVNC, XFCE, and DBus support. It also writes `~/.vnc/xstartup` so the VNC session starts XFCE.

## Set The VNC Password

The first setup run will ask you to set a VNC password if `~/.vnc/passwd` does not exist.

You can also set it manually:

```sh
ssh thinkpad 'vncpasswd'
```

Do not store the VNC password in this repo, shell history notes, or documentation.

## Open The Desktop

Use the Mac opener first:

```sh
./scripts/mac-open-vnc.sh
```

The helper starts VNC if needed, reuses an existing `:2` session if it is already running, creates or reuses the local tunnel on `127.0.0.1:5902`, and opens macOS Screen Sharing explicitly.

If you need the Linux-side start command directly, use:

```sh
ssh thinkpad 'bash -s' < scripts/linux-start-vnc.sh
```

Equivalent command:

```sh
vncserver -localhost yes -geometry 1440x900 -depth 24 :2
```

## Open The SSH Tunnel

From the Mac:

```sh
ssh -N -L 5902:127.0.0.1:5902 thinkpad
```

Keep this terminal open while using the remote desktop.

## Connect With Mac Screen Sharing

In another Mac terminal:

```sh
open -a "Screen Sharing" vnc://127.0.0.1:5902
```

Enter the VNC password when Screen Sharing asks for it.

If Screen Sharing reports:

```text
Connection failed to "127.0.0.1:5902"
```

check `nc -z 127.0.0.1 5902` first, then `ssh thinkpad 'vncserver -list'`. If `:2` is already running, the remaining issue is the local tunnel or Screen Sharing client, not the Lenovo VNC server.

## One-Command Mac Helper

From `<YOUR_REPO_PATH>/thinkpad-server-admin`:

```sh
./scripts/mac-open-vnc.sh
```

This is the primary handoff path. It reuses the already-running `:2` session if present, otherwise starts it, then opens Screen Sharing through the SSH tunnel.

## Verify

```sh
./scripts/verify-remote-desktop.sh
```

Expected safe listener on the Lenovo:

```text
127.0.0.1:5902
```

If you see VNC listening on `*:5902` or a LAN address, stop and fix the VNC start command before connecting.

## Stop The Desktop

```sh
ssh thinkpad 'bash -s' < scripts/linux-stop-vnc.sh
```

Equivalent command:

```sh
vncserver -kill :2
```
