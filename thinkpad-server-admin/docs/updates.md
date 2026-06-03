# Lenovo Updates

## Apply Updates Manually via SSH

From the Mac terminal:

```sh
ssh thinkpad 'sudo apt update && sudo apt upgrade -y'
```

Add `-t` if sudo prompts for a password:

```sh
ssh -t thinkpad 'sudo apt update && sudo apt upgrade -y'
```

Check what is pending without installing:

```sh
ssh thinkpad 'apt list --upgradable 2>/dev/null'
```

For kernel and held-back packages, use `full-upgrade`:

```sh
ssh -t thinkpad 'sudo apt full-upgrade -y'
```

Do not store passwords in scripts, history notes, or documentation.

## Set Up Automatic Security Updates (one-time)

Run this from your **Mac terminal** in the project directory. You do not need to log in to the Lenovo — the wrapper uploads the setup script and connects over SSH for you.

```sh
./scripts/mac-setup-auto-updates.sh
```

It will ask for your Lenovo Linux password for the initial SSH connection and again for `sudo`. When it finishes you will see:

```
PASS auto-update setup complete.
```

This installs `unattended-upgrades` and configures it to apply security patches only, silently. It also adds a root cron that runs `apt-get update` at 05:00 daily to keep the apt cache fresh — this means the Mac notification script can check for pending updates without needing sudo.

Non-security updates (like the three shown in the Update Manager screenshot) are not auto-applied. They are surfaced via the Mac notification below.

## Mac Notification for Pending Updates

`scripts/mac-notify-updates.sh` SSHes to the Lenovo, checks `apt list --upgradable`, and sends a macOS notification via `osascript` when packages are waiting. It requires SSH key auth (`ssh-copy-id` already set up).

Run it once manually to test:

```sh
./scripts/mac-notify-updates.sh
```

You should see a macOS notification like:

```
Lenovo Updates Pending
3 update(s): libwww-perl, python-urllib3, apparmor and more
ssh thinkpad 'sudo apt upgrade -y'
```

## Automate the Mac Notification (daily cron)

Add a daily check to your Mac crontab:

```sh
crontab -e
```

Add this line (runs at 08:00 every day):

```
0 8 * * * /Volumes/T9/code/lenova/thinkpad-server-admin/scripts/mac-notify-updates.sh >> /tmp/lenova-updates.log 2>&1
```

The script exits silently if the Lenovo is not reachable (e.g., powered off) — no spurious notifications.

To remove the cron job later, run `crontab -e` and delete the line.

## What Gets Auto-Applied vs. Notified

| Update type | Handled by |
|---|---|
| Security patches | `unattended-upgrades` — silent, automatic |
| Non-security updates | Mac notification → manual `sudo apt upgrade -y` |
| Kernel/held-back | Manual `sudo apt full-upgrade -y` |

## Safety Rules

- Do not store the Lenovo sudo password in any script, file, or shell history.
- `mac-notify-updates.sh` uses SSH key auth only — it never prompts for a password.
- `linux-setup-auto-updates.sh` requires an interactive TTY for sudo — always run it with `ssh -t`.
