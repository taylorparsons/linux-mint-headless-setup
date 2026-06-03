# Lenovo SSH Runbook

Use this file when the Lenovo is booted into Linux Mint and you want to connect from your Mac with admin capability.

## On The Lenovo

1. Make sure SSH is running:
```bash
sudo systemctl enable --now ssh
```

2. Get the Lenovo IP address:
```bash
hostname -I
```

3. Get the hostname:
```bash
hostname
```

## From The Mac

1. Connect with the Lenovo IP address:
```bash
ssh <linux-username>@<thinkpad-ip-address>
```

2. Or connect with the `.local` hostname if Avahi is working:
```bash
ssh <linux-username>@<hostname>.local
```

3. On the first connection, type `yes` to trust the host key and enter your Linux password.

## Admin Access

Use `sudo` for full admin permissions after you log in.

```bash
sudo <command>
```

To open a root shell for the session:

```bash
sudo -i
```

Do not enable SSH login as `root`. Keep SSH on the normal user account and elevate with `sudo`.

## SSH Key Setup (Passwordless Access)

After you can connect with a password, set up key-based auth so future connections do not prompt.

**On your router:** Reserve the Lenovo's MAC address as a static IP so `<thinkpad-ip-address>` never changes. The exact steps depend on your router admin page. Once set, update `~/.ssh/config` on the Mac with that IP.

**On the Mac — check for an existing key:**

```bash
ls ~/.ssh/id_ed25519.pub
```

If the file is missing, generate a key:

```bash
ssh-keygen -t ed25519 -C "thinkpad"
```

Accept the default path (`~/.ssh/id_ed25519`). Set a passphrase or leave it empty.

**On the Mac — copy the key to the Lenovo:**

```bash
ssh-copy-id <linux-username>@<thinkpad-ip-address>
```

Enter the Lenovo Linux password when prompted. This appends your public key to `~/.ssh/authorized_keys` on the Lenovo.

**On the Mac — add a Host alias to `~/.ssh/config`:**

```sshconfig
Host thinkpad
  HostName <thinkpad-ip-address>
  User <linux-username>
```

A ready-made snippet is in `thinkpad-server-admin/configs/mac-ssh-config-snippet`.

**Verify passwordless access:**

```bash
ssh thinkpad
```

It should connect without a password prompt. If it still asks, check that `~/.ssh/authorized_keys` on the Lenovo contains the public key and that `~/.ssh` permissions are `700` and the file permissions are `600`.
