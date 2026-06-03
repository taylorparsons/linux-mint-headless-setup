# Spec: Sanitize main for Public Sharing

**Date:** 2026-06-03  
**Status:** Approved

## Goal

Make the `main` branch of the `lenova` repo safe to publish publicly (GitHub, blog, etc.) by replacing all personal identifiers with generic placeholders. Preserve the live personal configuration in a `taylor-config` branch.

## What Gets Changed

### Personal identifiers → placeholders

| Current value | Placeholder | Context |
|---|---|---|
| `192.168.1.60` | `<YOUR_IP>` | LAN IP in configs, docs, scripts |
| `taylor` (Linux username) | `<YOUR_USERNAME>` | Config files, scripts, SSH refs |
| `taylor-ThinkPad-T430` | `<YOUR_HOSTNAME>` | Hostname in docs |
| `MacShare` | `<YOUR_SHARE_NAME>` | SMB share name in configs and docs |
| `Taylor's` / "Taylor" (prose) | `your` / generic | README and doc prose |

### Files in scope

- `thinkpad-server-admin/configs/mac-ssh-config-snippet`
- `thinkpad-server-admin/configs/Caddyfile`
- `thinkpad-server-admin/configs/smb-MacShare.conf`
- `thinkpad-server-admin/docs/current-state.md`
- `thinkpad-server-admin/docs/recovery.md`
- `thinkpad-server-admin/docs/do-not-delete.md`
- `thinkpad-server-admin/docs/updates.md`
- `thinkpad-server-admin/docs/remote-desktop.md`
- `thinkpad-server-admin/README.md`
- `README.md`
- `LENOVA-SSH.md`
- All scripts under `thinkpad-server-admin/scripts/`

### Substitution rules

- `taylor` as a Linux username (in `User taylor`, `valid users = taylor`, `path = /home/taylor/`, `taylor@`) → `<YOUR_USERNAME>`
- `taylor-ThinkPad-T430` → `<YOUR_HOSTNAME>`
- `192.168.1.60` → `<YOUR_IP>`
- `MacShare` → `<YOUR_SHARE_NAME>`
- "Taylor's" in prose → "your" (e.g., "Taylor's Lenovo ThinkPad" → "your ThinkPad")
- Standalone "Taylor" in prose as a name → "you" or "your" where natural
- `ssh thinkpad` alias references are fine to keep — the alias is generic enough

## Git Workflow

1. **Create `taylor-config` branch** from current `main` — no changes, just preserves the personal config as-is.
2. **On `main`**, apply all substitutions across files in scope.
3. **Commit `main`** with message: `chore: sanitize personal identifiers for public sharing`.

## Out of Scope

- Athena docs (`docs/specs/`, `docs/requests.md`, `docs/decisions.md`) — internal project docs, not user-facing; no personal info beyond what's already in the files above.
- `.claude/settings.local.json` — already gitignored or non-sensitive.
- No new files created; no functional behavior changed.

## Success Criteria

- `grep -r "192.168.1.60\|taylor-ThinkPad" .` returns zero matches on `main`.
- `grep -r "\btaylor\b" . --include="*.sh" --include="*.conf" --include="*.md"` returns zero matches on `main` (outside of prose references that have been converted to "your").
- `taylor-config` branch is unchanged from pre-work `main`.
- Scripts still function correctly for a reader who substitutes their own values.
