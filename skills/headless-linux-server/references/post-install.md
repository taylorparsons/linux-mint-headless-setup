# Post-Install Reference

Applies to any machine after Linux Mint first boot, regardless of whether it was a Windows PC or iMac.

## Table of Contents
1. [Base Updates and Packages](#1-base-updates-and-packages)
2. [Enable SSH](#2-enable-ssh)
3. [SSH Key Auth From Admin Machine](#3-ssh-key-auth-from-admin-machine)
4. [Static IP Reservation](#4-static-ip-reservation)
5. [Headless Configuration](#5-headless-configuration)
6. [Optional: Docker](#6-optional-docker)
7. [Optional: Caddy Reverse Proxy](#7-optional-caddy-reverse-proxy)
8. [Optional: Samba Share](#8-optional-samba-share)
9. [Optional: VNC Remote Desktop (SSH-tunneled)](#9-optional-vnc-remote-desktop-ssh-tunneled)
10. [Verify Everything Works](#10-verify-everything-works)

---

## 1. Base Updates and Packages

Run immediately after first boot. Connect Ethernet first — do not rely on Wi-Fi during initial setup.

```sh
sudo apt update && sudo apt upgrade -y
sudo apt install -y \
  openssh-server \
  git \
  curl \
  wget \
  htop \
  neofetch \
  build-essential \
  avahi-daemon
```

Enable and start Avahi (mDNS — lets you reach the server as `<hostname>.local`):

```sh
sudo systemctl enable --now avahi-daemon
```

Verify hostname:

```sh
hostname
hostname -I
```

Note the IP address — you will need it for the SSH and router steps below.

---

## 2. Enable SSH

```sh
sudo systemctl enable --now ssh
```

Verify it is listening:

```sh
ss -ltn | grep 22
```

Expected output includes `0.0.0.0:22` or `:::22`.

Test from the admin machine (Mac or another PC):

```sh
ssh <linux-username>@<server-ip>
```

Enter the Linux password when prompted. If it connects, SSH is working.

---

## 3. SSH Key Auth From Admin Machine

Replace password auth with key-based auth so future connections are passwordless.

**On the admin machine — check for an existing key:**

```sh
ls ~/.ssh/id_ed25519.pub
```

If missing, generate one:

```sh
ssh-keygen -t ed25519 -C "server-name"
```

Accept the default path. Set a passphrase or leave empty.

**Copy the key to the server:**

```sh
ssh-copy-id <linux-username>@<server-ip>
```

Enter the Linux password once. The key is added to `~/.ssh/authorized_keys` on the server.

**Add a Host alias on the admin machine** (`~/.ssh/config`):

```sshconfig
Host <alias>
  HostName <server-ip>
  User <linux-username>
```

Replace `<alias>` with a short name (e.g., `imac-server`, `thinkpad`).

**Verify passwordless access:**

```sh
ssh <alias>
```

Should connect without a password prompt. If it still asks, check:

```sh
ssh <linux-username>@<server-ip> 'ls -la ~/.ssh/'
```

`authorized_keys` must exist with permissions `600`, and `~/.ssh` must be `700`.

---

## 4. Static IP Reservation

Without a static IP, the server's address may change after a router reboot, breaking the `~/.ssh/config` entry.

**On the router admin page:**

1. Find the DHCP client list or connected devices section.
2. Locate the server's MAC address (from `ip link show` or the router list).
3. Reserve that MAC address to always get the same IP.
4. Save and apply.

After reserving, update `~/.ssh/config` on the admin machine with the reserved IP if it changed.

---

## 5. Headless Configuration

For a machine running without a monitor, keyboard, or mouse:

**Disable screen blanking and DPMS** (prevents GPU from sleeping):

```sh
sudo bash -c 'cat > /etc/X11/xorg.conf.d/10-no-blank.conf << EOF
Section "ServerFlags"
  Option "BlankTime" "0"
  Option "StandbyTime" "0"
  Option "SuspendTime" "0"
  Option "OffTime" "0"
EndSection
EOF'
```

**Prevent suspend/sleep on lid close** (laptops only):

Edit `/etc/systemd/logind.conf`:

```ini
HandleLidSwitch=ignore
HandleLidSwitchExternalPower=ignore
HandleLidSwitchDocked=ignore
```

Apply:

```sh
sudo systemctl restart systemd-logind
```

**Verify the server survives a reboot** by running `sudo reboot`, then SSHing back in after ~60 seconds.

---

## 6. Optional: Docker

```sh
curl -fsSL https://get.docker.com | sudo sh
sudo usermod -aG docker $USER
```

Log out and back in (or `newgrp docker`) for the group change to take effect.

Verify:

```sh
docker run --rm hello-world
```

For persistent containers, always set `--restart=always` or `--restart=unless-stopped`.

---

## 7. Optional: Caddy Reverse Proxy

Caddy provides HTTPS with automatic internal TLS — no Let's Encrypt account needed for LAN use.

```sh
sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https curl
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
sudo apt update && sudo apt install caddy
```

Minimal Caddyfile for a local HTTPS reverse proxy (e.g., to a Docker service on port 3001):

```
https://<server-ip> {
    tls internal
    reverse_proxy 127.0.0.1:3001
}
```

Place at `/etc/caddy/Caddyfile`. Apply:

```sh
sudo systemctl reload caddy
```

To trust the internal cert on the admin Mac:

```sh
ssh <alias> 'sudo caddy trust'
```

Then copy `/var/lib/caddy/.local/share/caddy/pki/authorities/local/root.crt` to the Mac and add it to Keychain (System, Always Trust).

---

## 8. Optional: Samba Share

Expose a folder on the server as a macOS Finder share.

```sh
sudo apt install -y samba
```

Add a share block to `/etc/samba/smb.conf`:

```ini
[<share-name>]
   path = /home/<username>/<share-name>
   browseable = yes
   read only = no
   create mask = 0644
   directory mask = 0755
   valid users = <username>
```

Create the folder and set the Samba password:

```sh
mkdir -p /home/<username>/<share-name>
sudo smbpasswd -a <username>
sudo systemctl restart smbd
```

From the Mac, connect in Finder: `smb://<server-ip>/<share-name>`.

---

## 9. Optional: VNC Remote Desktop (SSH-tunneled)

For occasional graphical access without exposing VNC to the LAN.

**On the server:**

```sh
sudo apt install -y tigervnc-standalone-server tigervnc-common xfce4 xfce4-goodies dbus-x11
```

Create the XFCE startup file:

```sh
mkdir -p ~/.vnc
cat > ~/.vnc/xstartup << 'EOF'
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
exec startxfce4
EOF
chmod +x ~/.vnc/xstartup
```

Set the VNC password (do not store it anywhere):

```sh
vncpasswd
```

Start VNC on display `:2` (use `:2` because `:0` and `:1` are often taken by the physical Xorg session):

```sh
vncserver -localhost yes -geometry 1440x900 -depth 24 :2
```

**On the admin Mac — open the tunnel and connect:**

```sh
# Open SSH tunnel (keep this terminal open)
ssh -N -L 5902:127.0.0.1:5902 <alias>

# In another terminal, open Screen Sharing
open -a "Screen Sharing" vnc://127.0.0.1:5902
```

**Safety rules:**
- Always use `-localhost yes` when starting VNC — never bind to `0.0.0.0`.
- Never add a firewall rule opening VNC port 5902 to the LAN.
- Reach VNC only through the SSH tunnel.
- Do not store the VNC password in any file.

**Stop VNC when done:**

```sh
vncserver -kill :2
```

---

## 10. Verify Everything Works

Run these checks from the admin machine after setup is complete:

```sh
# SSH access
ssh <alias> 'hostname && uptime'

# SSH survives reboot
ssh <alias> 'sudo reboot'
sleep 60
ssh <alias> 'echo "back online"'

# Docker (if installed)
ssh <alias> 'docker ps'

# Samba (if installed)
ls /Volumes/<share-name>

# Caddy HTTPS (if installed)
curl -I https://<server-ip>
```

All checks should return clean output. Record any failures and resolve before treating the server as production-ready.
