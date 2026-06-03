# Decisions

## D-20260603-1341
- Timestamp: 2026-06-03 13:41 America/Los_Angeles
- Related requests: CR-20260603-1341
- PRD sections: Requirements; Shipped
- Decision:
  "Automatically" and "let me know via the mac" interpreted as two separate concerns:
  (1) Security patches — install silently via `unattended-upgrades` on the Lenovo (no user action needed).
  (2) Non-security updates — a daily Mac-side cron job SSHes to the Lenovo, checks `apt list --upgradable`, and sends a macOS notification via `osascript` when packages are pending. A root cron on the Lenovo runs `apt-get update -qq` at 05:00 daily to keep the cache fresh so the Mac check needs no sudo. "Documented" means a new `docs/updates.md` file plus new helper scripts: `linux-setup-auto-updates.sh` (one-time Lenovo setup) and `mac-notify-updates.sh` (Mac daily check + notification). Notification includes the count and first three package names with the exact `sudo apt upgrade -y` command to act.

## D-20260603-1400
- Timestamp: 2026-06-03 14:00 America/Los_Angeles
- Related requests: CR-20260603-1400
- PRD sections: Remote desktop requirements; Shipped
- Decision:
  Change VNC display from `:1` to `:2` and port from `5901` to `5902`. Root cause verified live: Linux Mint's display manager (Xorg) already claimed both `:0` and `:1` on the ThinkPad (PID 3751 on tty8). VNC must use the next free display. SSH key auth was also set up (`ssh-copy-id`) to enable non-interactive verification. All 8 tests updated to expect `:2`/`5902`. `verify-remote-desktop.sh` confirmed 8/8 PASS with Mac connected via Screen Sharing.

## D-20260602-1258
- Timestamp: 2026-06-02 12:58 America/Los_Angeles
- Related requests: CR-20260602-1253
- PRD sections: Windows USB creation path; Documentation deliverables
- Decision:
  Use a repo `README.md` as the saved human runbook, and document Rufus 3.22 as the default Windows 7-compatible USB creation tool because current Rufus builds require Windows 8 or newer.

## D-20260602-1304
- Timestamp: 2026-06-02 13:04 America/Los_Angeles
- Related requests: CR-20260602-1253, CR-20260602-1301
- PRD sections: Safety constraints; Automation scope
- Decision:
  Keep all partition changes manual. The preflight batch file may report and recommend, and the DiskPart file may be provided as an optional manual artifact, but no script may run shrink or format operations automatically.

## D-20260602-1332
- Timestamp: 2026-06-02 13:32 America/Los_Angeles
- Related requests: CR-20260602-1330
- PRD sections: Windows download automation
- Decision:
  Implement a Windows 7 batch helper that opens the official Linux Mint pages and attempts to download Rufus 3.22 automatically into a Desktop folder. Do not attempt to auto-download a Mint ISO from an arbitrary mirror, because mirror choice and large-file reliability are better handled through the official Mint pages.

## D-20260602-1344
- Timestamp: 2026-06-02 13:44 America/Los_Angeles
- Related requests: CR-20260602-1330, CR-20260602-1342
- PRD sections: Windows download automation; Runbook
- Decision:
  Update the Rufus Windows 7 path to use the official archived downloads index at `https://rufus.ie/downloads/?pubDate=20260128` because the earlier direct `rufus-3.22.exe` URL returned 404 on the live Lenovo. Record the observed Windows result that entering `153600` MB produced about `150 GB` of unallocated space.

## D-20260603-0932
- Timestamp: 2026-06-03 09:32 America/Los_Angeles
- Related requests: CR-20260603-0930
- PRD sections: SSH runbook
- Decision:
  Put the SSH instructions into a dedicated root markdown file named `LENOVA-SSH.md` so the Mac-to-Lenovo access steps can be reused directly on the Lenovo and from the Mac without hunting through the larger dual-boot runbook.

## D-20260603-0000
- Timestamp: 2026-06-03 00:00 America/Los_Angeles
- Related requests: CR-20260603-0000
- PRD sections: Active Feature; ThinkPad server administration project
- Decision:
  Treat `/Volumes/MacShare/thinkpad-server-admin` as the delivery project because the share is currently mounted. Keep all server-facing scripts conservative: verification is read-only, backups are timestamped and non-overwriting, and destructive cleanup is left to explicit user approval.

## D-20260603-1226
- Timestamp: 2026-06-03 12:26 America/Los_Angeles
- Related requests: CR-20260603-1226
- PRD sections: ThinkPad server administration project
- Decision:
  Make `/Volumes/T9/code/lenova/thinkpad-server-admin` the durable source-of-truth project location because `/Volumes/MacShare/thinkpad-server-admin` lives on the Lenovo and would be lost if the Lenovo is terminated. Keep any SMB copy as a deployable mirror only, and do not delete the existing SMB copy.

## D-20260603-1239
- Timestamp: 2026-06-03 12:39 America/Los_Angeles
- Related requests: CR-20260603-1239
- PRD sections: ThinkPad remote desktop
- Decision:
  Implement the approved TDD plan as an SSH-tunneled TigerVNC virtual XFCE desktop for macOS Screen Sharing, with manual VNC startup, localhost-only VNC binding, no firewall opening, and no stored VNC password.

## D-20260603-1250
- Timestamp: 2026-06-03 12:50 America/Los_Angeles
- Related requests: CR-20260603-1250
- PRD sections: ThinkPad remote desktop
- Decision:
  Replace the streamed setup command with a Mac-side setup wrapper that uploads `linux-setup-vnc.sh` to a temporary file and runs it through `ssh -t`, so `sudo` and `vncpasswd` can prompt on a remote TTY. Make the Linux setup script fail fast after apt errors so it cannot report completion after failed installs.

## D-20260603-1303
- Timestamp: 2026-06-03 13:03 America/Los_Angeles
- Related requests: CR-20260603-1303
- PRD sections: ThinkPad remote desktop
- Decision:
  Treat "A X11 server is already running for display :1" as evidence that the Lenovo VNC server is already up, not as a setup failure. Fix the Mac opener to establish the SSH tunnel with `ssh -fN -o ExitOnForwardFailure=yes` so password authentication can prompt before the tunnel backgrounds, then open macOS Screen Sharing explicitly.

## D-20260603-1304
- Timestamp: 2026-06-03 13:04 America/Los_Angeles
- Related requests: CR-20260603-1304
- PRD sections: Documentation state; ThinkPad remote desktop
- Decision:
  Update the docs to make `./scripts/mac-open-vnc.sh` the primary handoff path, note that the Lenovo VNC server may already be running on `:1`, and point recovery guidance at the exact setup/open/verify commands rather than the older streamed setup command.

## D-20260603-1313
- Timestamp: 2026-06-03 13:13 America/Los_Angeles
- Related requests: CR-20260603-1313
- PRD sections: ThinkPad remote desktop; Recovery
- Decision:
  Record the Screen Sharing failure text `Connection failed to "127.0.0.1:5901"` as an observed symptom and document the local-tunnel and `vncserver -list` checks as the first recovery step.
