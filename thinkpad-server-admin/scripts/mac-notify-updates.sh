#!/usr/bin/env bash
set -euo pipefail

SSH_ALIAS="${SSH_ALIAS:-thinkpad}"

echo "Checking for pending updates on ${SSH_ALIAS}."

# Key auth only — exits silently if Lenovo is not reachable (e.g., powered off)
if ! ssh -o ConnectTimeout=5 -o BatchMode=yes "$SSH_ALIAS" true 2>/dev/null; then
    echo "Lenovo not reachable via SSH — skipping update check."
    exit 0
fi

# Fetch pending updates (no sudo needed; root cron keeps apt cache fresh at 05:00)
PENDING_LIST=$(ssh "$SSH_ALIAS" 'apt list --upgradable 2>/dev/null | grep -v "^Listing"' 2>/dev/null || true)
PENDING_COUNT=$(echo "$PENDING_LIST" | grep -c . 2>/dev/null || echo "0")

if [ "$PENDING_COUNT" -eq 0 ]; then
    echo "Lenovo is up to date — no pending updates."
    exit 0
fi

# First three package names for the notification body
PACKAGES=$(echo "$PENDING_LIST" | cut -d/ -f1 | head -3 | tr '\n' ',' | sed 's/,$//')
if [ "$PENDING_COUNT" -gt 3 ]; then
    PACKAGES="${PACKAGES} and more"
fi

echo "${PENDING_COUNT} update(s) pending: ${PACKAGES}"
osascript -e "display notification \"${PENDING_COUNT} update(s): ${PACKAGES}\" with title \"Lenovo Updates Pending\" subtitle \"ssh thinkpad 'sudo apt upgrade -y'\""
echo "Notification sent. To apply: ssh thinkpad 'sudo apt upgrade -y'"
