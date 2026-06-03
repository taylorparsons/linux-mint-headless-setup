# Feature Spec: 20260603-thinkpad-server-admin

Status: Done

## Functional Requirements

- FR-001: The project must exist at `<YOUR_REPO>/thinkpad-server-admin` as the durable source-of-truth copy. (Sources: CR-20260603-1226; D-20260603-1226)
- FR-002: The project must include documentation for the known Linux Mint server state, access paths, password prompt guide, maintenance checklist, recovery commands, and do-not-delete safety rules without storing passwords. (Sources: CR-20260603-0000)
- FR-003: The project must include reference config snippets for Caddy, the Samba `MacShare` block, and the Mac SSH config alias. (Sources: CR-20260603-0000)
- FR-004: The project must include executable Mac-run scripts for read-only server verification, timestamped non-overwriting Uptime Kuma Docker volume backup, and bidirectional SMB share testing. (Sources: CR-20260603-0000; D-20260603-0000)
- FR-005: Verification must be run and reported as PASS/FAIL before any server changes are made. (Sources: CR-20260603-0000; D-20260603-0000)
- FR-006: The docs must explain that `/Volumes/MacShare/thinkpad-server-admin` is not durable and is only an optional mirror/deploy target. (Sources: CR-20260603-1226; D-20260603-1226)
- FR-007: The project must document a manual-start TigerVNC virtual XFCE desktop on the Lenovo, reached from macOS Screen Sharing through an SSH tunnel to `127.0.0.1:5901`. (Sources: CR-20260603-1239; D-20260603-1239)
- FR-008: The project must include executable helper scripts to set up VNC packages/config, start VNC, stop VNC, open the Mac tunnel/client, and verify the remote desktop setup. (Sources: CR-20260603-1239; D-20260603-1239)
- FR-009: Remote desktop scripts and docs must avoid stored passwords, firewall-opening commands, and LAN-wide VNC binding. (Sources: CR-20260603-1239; D-20260603-1239)
- FR-010: Remote desktop setup must use a Mac-side wrapper that uploads the Linux setup script and runs it with `ssh -t`, so `sudo` and `vncpasswd` can prompt through a remote TTY. (Sources: CR-20260603-1250; D-20260603-1250)
- FR-011: `linux-setup-vnc.sh` must fail fast if apt update or package installation fails, and must verify `vncpasswd` exists before invoking it. (Sources: CR-20260603-1250; D-20260603-1250)
- FR-012: `mac-open-vnc.sh` must establish the SSH tunnel in a way that supports password-authenticated SSH before backgrounding, must fail clearly if the local forward cannot bind, and must open macOS Screen Sharing explicitly. (Sources: CR-20260603-1303; D-20260603-1303)
- FR-013: The docs must make `./scripts/mac-open-vnc.sh` the primary handoff path, note that `:1` may already be running on the Lenovo, and point recovery at the setup/open/verify commands instead of the older streamed setup command. (Sources: CR-20260603-1304; D-20260603-1304)
- FR-014: The docs must record the observed Screen Sharing failure `Connection failed to "127.0.0.1:5901"` and tell the reader to verify the local tunnel and `vncserver -list` before restarting VNC. (Sources: CR-20260603-1313; D-20260603-1313)

## Acceptance Scenarios

- Given the local repo is available, when the project is generated, then all requested files exist under `<YOUR_REPO>/thinkpad-server-admin`. (Verifies: FR-001, FR-002, FR-003, FR-004)
- Given a user reads the documentation, when they follow maintenance or recovery guidance, then they see priority labels, exact known access paths, diagnostic commands, password prompt meanings, and explicit warnings not to delete backups, Docker volumes, or `/home/taylor/MacShare` without asking Taylor. (Verifies: FR-002)
- Given a user reviews the scripts, when checking for server risk, then verification makes no changes, backups use timestamped filenames and refuse overwrite, and SMB tests either ask before cleanup or leave timestamped files. (Verifies: FR-004)
- Given the project scripts are complete, when validation is run, then shell syntax checks pass and `verify-server.sh` reports PASS or FAIL for each check. (Verifies: FR-005)
- Given Taylor needs to rebuild later, when reading the README, then the durable repo location is clear and `/Volumes/MacShare/thinkpad-server-admin` is described as an optional mirror that can be lost with the Lenovo. (Verifies: FR-006)
- Given Taylor needs a remote desktop, when reading `docs/remote-desktop.md`, then the setup uses TigerVNC, XFCE, `vncpasswd`, `vncserver -localhost yes`, SSH tunnel `5901:127.0.0.1:5901`, and `open vnc://127.0.0.1:5901`. (Verifies: FR-007)
- Given a user reviews the remote desktop scripts, when checking safety, then scripts are executable and avoid `ufw allow`, `0.0.0.0`, and plaintext password assignment patterns. (Verifies: FR-008, FR-009)
- Given Taylor runs setup from the Mac, when using the documented command, then the Mac wrapper uploads the Linux setup script and invokes it with `ssh -t` instead of streaming it through `ssh thinkpad 'bash -s' < scripts/linux-setup-vnc.sh`. (Verifies: FR-010)
- Given package installation fails, when `linux-setup-vnc.sh` runs, then it exits before claiming setup completion or invoking `vncpasswd`. (Verifies: FR-011)
- Given VNC display `:1` is already running on the Lenovo, when Taylor opens the Mac helper, then the helper must skip restarting VNC, create or reuse a local tunnel on `127.0.0.1:5901`, and open Screen Sharing. (Verifies: FR-012)
- Given the docs are updated for handoff, when Claude reads them, then the primary opener is `./scripts/mac-open-vnc.sh`, the running `:1` state is documented, and the recovery section points to the exact commands to setup, open, verify, and stop the remote desktop. (Verifies: FR-013)
- Given the Screen Sharing app shows `Connection failed to "127.0.0.1:5901"`, when the reader opens the docs, then the docs record that exact failure and tell them to check the local tunnel and `ssh thinkpad 'vncserver -list'` first. (Verifies: FR-014)
- FR-015: The project must include a one-time Lenovo setup script (`linux-setup-auto-updates.sh`) that installs `unattended-upgrades` for automatic security patches and adds a root daily cron to refresh the apt cache at 05:00. (Sources: CR-20260603-1341; D-20260603-1341)
- FR-016: The project must include a Mac-run notification script (`mac-notify-updates.sh`) that SSHes to the Lenovo, checks `apt list --upgradable`, and delivers a macOS notification via `osascript` with the pending package count and first three package names when updates exist. (Sources: CR-20260603-1341; D-20260603-1341)
- FR-017: A `docs/updates.md` file must document how to run updates manually via SSH, how to set up auto-updates, how to add the Mac daily notification check as a cron job, and must not store passwords. (Sources: CR-20260603-1341; D-20260603-1341)
- Given unattended-upgrades setup is requested, when `linux-setup-auto-updates.sh` runs on the Lenovo via SSH, then it installs unattended-upgrades, configures the daily apt cache refresh cron, and prints PASS. (Verifies: FR-015)
- Given it is 08:00 on the Mac and `mac-notify-updates.sh` runs via cron, when pending updates exist on the Lenovo, then a macOS notification appears with the count, package names, and the command to apply them. (Verifies: FR-016)
- Given a user reads `docs/updates.md`, when following the guide, then they can apply updates via SSH, run the one-time setup, and add the Mac notification cron without storing a password anywhere. (Verifies: FR-017)
