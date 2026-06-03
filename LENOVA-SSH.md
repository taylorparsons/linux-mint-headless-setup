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
