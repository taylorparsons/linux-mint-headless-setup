---
name: headless-linux-server
description: >
  Convert any Windows PC or iMac into a headless Linux Mint server. Covers hardware assessment,
  bootable USB creation, OS installation (dual-boot or clean wipe), SSH key setup, headless
  configuration, and optional services (Docker, Caddy, Samba, VNC-over-SSH). Use when the user
  wants to repurpose old hardware as a local Linux server, decommission a Windows or Mac machine,
  or set up a home lab server. Triggers: "convert to linux", "headless server", "repurpose old mac",
  "repurpose old PC", "repurpose iMac", "install linux on", "wipe and install linux",
  "dual boot linux", "linux home server", "turn into a server".
---

# Headless Linux Server Setup

Convert a Windows PC or iMac into a headless Linux Mint XFCE server reachable via SSH.

## Step 1 — Assess Hardware

Ask or determine:

| Question | Why it matters |
|---|---|
| Windows PC or iMac? | Different boot firmware — BIOS/MBR vs EFI |
| Keep existing OS? | Dual-boot vs clean wipe |
| RAM and disk? | Minimum: 2 GB RAM, 40 GB free disk |
| Ethernet available? | Strongly preferred for a headless server |

Route to the correct reference:

- **Windows PC (ThinkPad, Dell, HP, Lenovo, etc.)** → `references/windows-bios.md`
- **iMac or Mac mini** → `references/imac-efi.md`

## Step 2 — Choose Install Type

**Dual-boot** (keep Windows/macOS alongside Linux):
- Safe if hardware is still used for the original OS
- Requires shrinking the existing partition first
- Boot menu selects OS at startup

**Clean wipe** (Linux only):
- Simpler — no partition math needed
- Use when hardware is being fully repurposed
- Irreversible — confirm backups are complete before proceeding

## Step 3 — Platform-Specific Steps

Read the appropriate reference and walk through it with the user:

- `references/windows-bios.md` — preflight, DiskPart shrink, Rufus USB, F12 boot, Mint installer
- `references/imac-efi.md` — disk backup, EFI boot, Option-key boot menu, Mint installer

## Step 4 — Post-Install

After Linux Mint boots for the first time, follow `references/post-install.md`:

1. Run the post-install script to apply updates and enable SSH
2. Set up SSH key auth from the admin machine
3. Confirm passwordless `ssh <alias>` works
4. Configure headless behavior (lid-close policy, no display required)
5. Add optional services as needed: Docker, Caddy, Samba, VNC-over-SSH

## Safety Rules

Enforce these throughout every session:

- Do not store passwords in scripts, files, or shell history.
- Do not enable SSH login as root — use `sudo` from a normal user account.
- Do not wipe the disk without explicit confirmation that backups are complete.
- Do not open VNC directly on the LAN — tunnel it through SSH only.
- Do not add firewall rules that could block SSH.
- Do not push to remote repos unless the user explicitly asks.
