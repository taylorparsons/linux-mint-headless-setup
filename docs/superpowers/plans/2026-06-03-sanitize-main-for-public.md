# Sanitize main for Public Sharing — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace all personal identifiers (IP, username, hostname, share name, drive path, name in prose) with generic placeholders so `main` can be published publicly, while preserving the live personal config in a `taylor-config` branch.

**Architecture:** Create a preservation branch first (no changes), then apply `sed` substitutions file-by-file on `main` in dependency order (longest tokens before substrings — e.g. `taylor-ThinkPad-T430` before `taylor`). Verify with `grep` after each group. Commit once all files are clean.

**Tech Stack:** bash, macOS BSD `sed` (`-i ''` syntax), `grep`

---

### Task 1: Create taylor-config branch

**Files:** (no file changes — branch creation only)

- [ ] **Step 1: Confirm you are on main**

```bash
git -C /Volumes/T9/code/lenova branch
```

Expected: `* main` is the current branch.

- [ ] **Step 2: Create and push the preservation branch**

```bash
git -C /Volumes/T9/code/lenova branch taylor-config
```

Expected: no output (branch created silently).

- [ ] **Step 3: Verify branch exists**

```bash
git -C /Volumes/T9/code/lenova branch
```

Expected:
```
  taylor-config
* main
```

---

### Task 2: Sanitize config files

**Files:**
- Modify: `thinkpad-server-admin/configs/mac-ssh-config-snippet`
- Modify: `thinkpad-server-admin/configs/Caddyfile`
- Modify: `thinkpad-server-admin/configs/smb-MacShare.conf`

- [ ] **Step 1: Replace IP in mac-ssh-config-snippet**

```bash
sed -i '' 's/192\.168\.1\.60/<YOUR_IP>/g' /Volumes/T9/code/lenova/thinkpad-server-admin/configs/mac-ssh-config-snippet
```

- [ ] **Step 2: Replace username in mac-ssh-config-snippet**

```bash
sed -i '' 's/User taylor/User <YOUR_USERNAME>/g' /Volumes/T9/code/lenova/thinkpad-server-admin/configs/mac-ssh-config-snippet
```

- [ ] **Step 3: Verify mac-ssh-config-snippet**

```bash
cat /Volumes/T9/code/lenova/thinkpad-server-admin/configs/mac-ssh-config-snippet
```

Expected:
```
Host thinkpad
  HostName <YOUR_IP>
  User <YOUR_USERNAME>
```

- [ ] **Step 4: Replace IP in Caddyfile**

```bash
sed -i '' 's/192\.168\.1\.60/<YOUR_IP>/g' /Volumes/T9/code/lenova/thinkpad-server-admin/configs/Caddyfile
```

- [ ] **Step 5: Verify Caddyfile**

```bash
cat /Volumes/T9/code/lenova/thinkpad-server-admin/configs/Caddyfile
```

Expected:
```
https://<YOUR_IP> {
    tls internal
    reverse_proxy 127.0.0.1:3001
}
```

- [ ] **Step 6: Replace share name in smb-MacShare.conf**

```bash
sed -i '' 's/MacShare/<YOUR_SHARE_NAME>/g' /Volumes/T9/code/lenova/thinkpad-server-admin/configs/smb-MacShare.conf
```

- [ ] **Step 7: Replace username in smb-MacShare.conf**

```bash
sed -i '' 's/\/home\/taylor\//\/home\/<YOUR_USERNAME>\//g' /Volumes/T9/code/lenova/thinkpad-server-admin/configs/smb-MacShare.conf
sed -i '' 's/valid users = taylor/valid users = <YOUR_USERNAME>/g' /Volumes/T9/code/lenova/thinkpad-server-admin/configs/smb-MacShare.conf
```

- [ ] **Step 8: Verify smb-MacShare.conf**

```bash
cat /Volumes/T9/code/lenova/thinkpad-server-admin/configs/smb-MacShare.conf
```

Expected:
```
[<YOUR_SHARE_NAME>]
path = /home/<YOUR_USERNAME>/<YOUR_SHARE_NAME>
browseable = yes
read only = no
guest ok = no
valid users = <YOUR_USERNAME>
create mask = 0644
directory mask = 0755
```

- [ ] **Step 9: Commit**

```bash
git -C /Volumes/T9/code/lenova add thinkpad-server-admin/configs/
git -C /Volumes/T9/code/lenova commit -m "chore: sanitize config files — replace personal identifiers with placeholders"
```

---

### Task 3: Sanitize scripts

**Files:**
- Modify: `thinkpad-server-admin/scripts/backup-uptime-kuma.sh`
- Modify: `thinkpad-server-admin/scripts/linux-setup-vnc.sh`
- Modify: `thinkpad-server-admin/scripts/test-smb-share.sh`
- Modify: `thinkpad-server-admin/scripts/verify-server.sh`
- Modify: `thinkpad-server-admin/scripts/verify-remote-desktop.sh`
- Modify: `thinkpad-server-admin/scripts/mac-setup-vnc.sh`
- Modify: `thinkpad-server-admin/scripts/mac-open-vnc.sh`
- Modify: `thinkpad-server-admin/scripts/mac-setup-auto-updates.sh`

- [ ] **Step 1: Replace /home/taylor/ in backup-uptime-kuma.sh**

```bash
sed -i '' 's/\/home\/taylor\//\/home\/<YOUR_USERNAME>\//g' /Volumes/T9/code/lenova/thinkpad-server-admin/scripts/backup-uptime-kuma.sh
sed -i '' 's/user taylor/user <YOUR_USERNAME>/g' /Volumes/T9/code/lenova/thinkpad-server-admin/scripts/backup-uptime-kuma.sh
```

- [ ] **Step 2: Replace username reference in linux-setup-vnc.sh**

```bash
sed -i '' 's/user taylor/user <YOUR_USERNAME>/g' /Volumes/T9/code/lenova/thinkpad-server-admin/scripts/linux-setup-vnc.sh
```

- [ ] **Step 3: Replace identifiers in test-smb-share.sh**

```bash
sed -i '' 's/MacShare/<YOUR_SHARE_NAME>/g' /Volumes/T9/code/lenova/thinkpad-server-admin/scripts/test-smb-share.sh
sed -i '' 's/\/home\/taylor\//\/home\/<YOUR_USERNAME>\//g' /Volumes/T9/code/lenova/thinkpad-server-admin/scripts/test-smb-share.sh
sed -i '' 's/192\.168\.1\.60/<YOUR_IP>/g' /Volumes/T9/code/lenova/thinkpad-server-admin/scripts/test-smb-share.sh
sed -i '' 's/user taylor/user <YOUR_USERNAME>/g' /Volumes/T9/code/lenova/thinkpad-server-admin/scripts/test-smb-share.sh
```

- [ ] **Step 4: Replace identifiers in verify-server.sh**

```bash
sed -i '' 's/192\.168\.1\.60/<YOUR_IP>/g' /Volumes/T9/code/lenova/thinkpad-server-admin/scripts/verify-server.sh
sed -i '' 's/MacShare/<YOUR_SHARE_NAME>/g' /Volumes/T9/code/lenova/thinkpad-server-admin/scripts/verify-server.sh
sed -i '' 's/user taylor/user <YOUR_USERNAME>/g' /Volumes/T9/code/lenova/thinkpad-server-admin/scripts/verify-server.sh
```

- [ ] **Step 5: Replace username in verify-remote-desktop.sh, mac-setup-vnc.sh, mac-open-vnc.sh, mac-setup-auto-updates.sh**

```bash
for f in \
  /Volumes/T9/code/lenova/thinkpad-server-admin/scripts/verify-remote-desktop.sh \
  /Volumes/T9/code/lenova/thinkpad-server-admin/scripts/mac-setup-vnc.sh \
  /Volumes/T9/code/lenova/thinkpad-server-admin/scripts/mac-open-vnc.sh \
  /Volumes/T9/code/lenova/thinkpad-server-admin/scripts/mac-setup-auto-updates.sh; do
  sed -i '' 's/user taylor/user <YOUR_USERNAME>/g' "$f"
done
```

- [ ] **Step 6: Verify no personal identifiers remain in scripts**

```bash
grep -rn "192\.168\.1\.60\|taylor-ThinkPad\|/home/taylor\|\bvalid users = taylor\b\|MacShare" \
  /Volumes/T9/code/lenova/thinkpad-server-admin/scripts/
```

Expected: no output (zero matches).

- [ ] **Step 7: Check for any remaining bare `taylor` as username in scripts**

```bash
grep -n "\btaylor\b" /Volumes/T9/code/lenova/thinkpad-server-admin/scripts/*.sh
```

Expected: no output. If any lines appear, inspect and apply `sed -i '' 's/\btaylor\b/<YOUR_USERNAME>/g'` to that specific file.

- [ ] **Step 8: Commit**

```bash
git -C /Volumes/T9/code/lenova add thinkpad-server-admin/scripts/
git -C /Volumes/T9/code/lenova commit -m "chore: sanitize scripts — replace personal identifiers with placeholders"
```

---

### Task 4: Sanitize docs

**Files:**
- Modify: `thinkpad-server-admin/docs/current-state.md`
- Modify: `thinkpad-server-admin/docs/recovery.md`
- Modify: `thinkpad-server-admin/docs/do-not-delete.md`
- Modify: `thinkpad-server-admin/docs/remote-desktop.md`
- Modify: `thinkpad-server-admin/docs/updates.md`

- [ ] **Step 1: Sanitize current-state.md**

Run in order (hostname before username to avoid partial replacement):

```bash
sed -i '' 's/taylor-ThinkPad-T430/<YOUR_HOSTNAME>/g' /Volumes/T9/code/lenova/thinkpad-server-admin/docs/current-state.md
sed -i '' 's/192\.168\.1\.60/<YOUR_IP>/g' /Volumes/T9/code/lenova/thinkpad-server-admin/docs/current-state.md
sed -i '' 's/MacShare/<YOUR_SHARE_NAME>/g' /Volumes/T9/code/lenova/thinkpad-server-admin/docs/current-state.md
sed -i '' 's/\/home\/taylor\//\/home\/<YOUR_USERNAME>\//g' /Volumes/T9/code/lenova/thinkpad-server-admin/docs/current-state.md
sed -i '' 's/User taylor/User <YOUR_USERNAME>/g' /Volumes/T9/code/lenova/thinkpad-server-admin/docs/current-state.md
sed -i '' "s/taylor@/<YOUR_USERNAME>@/g" /Volumes/T9/code/lenova/thinkpad-server-admin/docs/current-state.md
sed -i '' 's/for taylor/for <YOUR_USERNAME>/g' /Volumes/T9/code/lenova/thinkpad-server-admin/docs/current-state.md
sed -i '' "s/Taylor's/your/g" /Volumes/T9/code/lenova/thinkpad-server-admin/docs/current-state.md
```

- [ ] **Step 2: Verify current-state.md**

```bash
grep -n "taylor\|192\.168\.1\.60\|MacShare\|ThinkPad-T430" /Volumes/T9/code/lenova/thinkpad-server-admin/docs/current-state.md
```

Expected: no output. If any lines appear, inspect and fix manually with Edit.

- [ ] **Step 3: Sanitize recovery.md**

```bash
sed -i '' 's/192\.168\.1\.60/<YOUR_IP>/g' /Volumes/T9/code/lenova/thinkpad-server-admin/docs/recovery.md
sed -i '' "s/taylor@/<YOUR_USERNAME>@/g" /Volumes/T9/code/lenova/thinkpad-server-admin/docs/recovery.md
sed -i '' 's/user `taylor`/user `<YOUR_USERNAME>`/g' /Volumes/T9/code/lenova/thinkpad-server-admin/docs/recovery.md
sed -i '' 's/for taylor/for <YOUR_USERNAME>/g' /Volumes/T9/code/lenova/thinkpad-server-admin/docs/recovery.md
```

- [ ] **Step 4: Verify recovery.md**

```bash
grep -n "taylor\|192\.168\.1\.60" /Volumes/T9/code/lenova/thinkpad-server-admin/docs/recovery.md
```

Expected: no output.

- [ ] **Step 5: Sanitize do-not-delete.md**

```bash
sed -i '' 's/asking Taylor first/asking the repo owner first/g' /Volumes/T9/code/lenova/thinkpad-server-admin/docs/do-not-delete.md
sed -i '' 's/\/home\/taylor\//\/home\/<YOUR_USERNAME>\//g' /Volumes/T9/code/lenova/thinkpad-server-admin/docs/do-not-delete.md
sed -i '' 's/MacShare/<YOUR_SHARE_NAME>/g' /Volumes/T9/code/lenova/thinkpad-server-admin/docs/do-not-delete.md
sed -i '' 's/Show Taylor the/Show the owner the/g' /Volumes/T9/code/lenova/thinkpad-server-admin/docs/do-not-delete.md
```

- [ ] **Step 6: Sanitize remote-desktop.md**

```bash
sed -i '' 's/user `taylor`/user `<YOUR_USERNAME>`/g' /Volumes/T9/code/lenova/thinkpad-server-admin/docs/remote-desktop.md
sed -i '' 's/\/Volumes\/T9\/code\/lenova/<YOUR_REPO_PATH>/g' /Volumes/T9/code/lenova/thinkpad-server-admin/docs/remote-desktop.md
```

- [ ] **Step 7: Sanitize updates.md**

```bash
sed -i '' 's/\/Volumes\/T9\/code\/lenova/<YOUR_REPO_PATH>/g' /Volumes/T9/code/lenova/thinkpad-server-admin/docs/updates.md
```

- [ ] **Step 8: Verify all docs**

```bash
grep -rn "taylor\|192\.168\.1\.60\|MacShare\|ThinkPad-T430\|Volumes\/T9" \
  /Volumes/T9/code/lenova/thinkpad-server-admin/docs/
```

Expected: no output. If matches appear, open the relevant file and fix with Edit.

- [ ] **Step 9: Commit**

```bash
git -C /Volumes/T9/code/lenova add thinkpad-server-admin/docs/
git -C /Volumes/T9/code/lenova commit -m "chore: sanitize server-admin docs — replace personal identifiers with placeholders"
```

---

### Task 5: Sanitize READMEs and LENOVA-SSH.md

**Files:**
- Modify: `thinkpad-server-admin/README.md`
- Modify: `README.md`
- Modify: `LENOVA-SSH.md`

- [ ] **Step 1: Sanitize thinkpad-server-admin/README.md**

```bash
sed -i '' 's/192\.168\.1\.60/<YOUR_IP>/g' /Volumes/T9/code/lenova/thinkpad-server-admin/README.md
sed -i '' 's/MacShare/<YOUR_SHARE_NAME>/g' /Volumes/T9/code/lenova/thinkpad-server-admin/README.md
sed -i '' 's/\/Volumes\/T9\/code\/lenova/<YOUR_REPO_PATH>/g' /Volumes/T9/code/lenova/thinkpad-server-admin/README.md
sed -i '' "s/Taylor's/your/g" /Volumes/T9/code/lenova/thinkpad-server-admin/README.md
sed -i '' 's/asking Taylor first/asking the repo owner first/g' /Volumes/T9/code/lenova/thinkpad-server-admin/README.md
```

- [ ] **Step 2: Verify thinkpad-server-admin/README.md**

```bash
grep -n "taylor\|192\.168\.1\.60\|Volumes\/T9" /Volumes/T9/code/lenova/thinkpad-server-admin/README.md
```

Expected: no output.

- [ ] **Step 3: Sanitize root README.md**

```bash
sed -i '' 's/192\.168\.1\.60/<YOUR_IP>/g' /Volumes/T9/code/lenova/README.md
sed -i '' 's/MacShare/<YOUR_SHARE_NAME>/g' /Volumes/T9/code/lenova/README.md
sed -i '' 's/\/Volumes\/T9\/code\/lenova/<YOUR_REPO_PATH>/g' /Volumes/T9/code/lenova/README.md
```

- [ ] **Step 4: Verify root README.md**

```bash
grep -n "taylor\|192\.168\.1\.60\|Volumes\/T9" /Volumes/T9/code/lenova/README.md
```

Expected: no output.

- [ ] **Step 5: Verify LENOVA-SSH.md is already clean**

```bash
grep -n "taylor\|192\.168\.1\.60" /Volumes/T9/code/lenova/LENOVA-SSH.md
```

Expected: no output (this file already uses `<linux-username>` and `<thinkpad-ip-address>` placeholders). If any matches appear, apply the same `sed` pattern as above.

- [ ] **Step 6: Commit**

```bash
git -C /Volumes/T9/code/lenova add thinkpad-server-admin/README.md README.md LENOVA-SSH.md
git -C /Volumes/T9/code/lenova commit -m "chore: sanitize READMEs and SSH runbook — replace personal identifiers with placeholders"
```

---

### Task 6: Final verification + summary commit

**Files:** (no changes — verification only)

- [ ] **Step 1: Full repo scan for IP**

```bash
grep -rn "192\.168\.1\.60" /Volumes/T9/code/lenova \
  --include="*.sh" --include="*.md" --include="*.conf" --include="*.bat" --include="*.txt" \
  --exclude-dir=".git" --exclude-dir="__pycache__" --exclude-dir="docs/specs" \
  --exclude-dir="docs/superpowers"
```

Expected: no output.

- [ ] **Step 2: Full repo scan for Linux username**

```bash
grep -rn "\btaylor\b" /Volumes/T9/code/lenova \
  --include="*.sh" --include="*.conf" \
  --exclude-dir=".git" --exclude-dir="__pycache__"
```

Expected: no output.

- [ ] **Step 3: Full repo scan for hostname**

```bash
grep -rn "taylor-ThinkPad-T430" /Volumes/T9/code/lenova \
  --exclude-dir=".git" --exclude-dir="__pycache__"
```

Expected: no output.

- [ ] **Step 4: Confirm taylor-config branch is unmodified**

```bash
git -C /Volumes/T9/code/lenova diff main taylor-config -- thinkpad-server-admin/configs/mac-ssh-config-snippet
```

Expected: output showing the personal values (`192.168.1.60`, `taylor`) still present on `taylor-config` and placeholders on `main`.

- [ ] **Step 5: Show final git log**

```bash
git -C /Volumes/T9/code/lenova log --oneline -8
```

Expected: 4 new commits on top of the design-spec commit, each labeled `chore: sanitize ...`.
