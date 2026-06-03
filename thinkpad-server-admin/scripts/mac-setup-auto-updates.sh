#!/usr/bin/env bash
set -euo pipefail

SSH_ALIAS="${SSH_ALIAS:-thinkpad}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOCAL_SETUP="${SCRIPT_DIR}/linux-setup-auto-updates.sh"

if [ ! -f "$LOCAL_SETUP" ]; then
    echo "FAIL missing local setup script: $LOCAL_SETUP" >&2
    exit 1
fi

echo "Connecting to ${SSH_ALIAS} to set up automatic updates on the Lenovo."
echo "If SSH asks for a password, use the Lenovo Linux password for user <YOUR_USERNAME>."

REMOTE_PATH="/tmp/thinkpad-auto-updates-setup-${USER:-mac}-$$.sh"

scp "$LOCAL_SETUP" "${SSH_ALIAS}:${REMOTE_PATH}" >/dev/null

echo "Running setup — sudo will prompt for the Lenovo Linux password."
ssh -t "$SSH_ALIAS" "bash '$REMOTE_PATH'; status=\$?; rm -f '$REMOTE_PATH'; exit \$status"
