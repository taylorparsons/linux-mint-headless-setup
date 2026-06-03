#!/usr/bin/env bash
set -euo pipefail

SSH_ALIAS="${SSH_ALIAS:-thinkpad}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOCAL_SETUP="${SCRIPT_DIR}/linux-setup-vnc.sh"

if [ ! -f "$LOCAL_SETUP" ]; then
  echo "FAIL missing local setup script: $LOCAL_SETUP" >&2
  exit 1
fi

echo "Uploading Linux VNC setup script to ${SSH_ALIAS}."
echo "If SSH asks for a password, use the Lenovo Linux password for user <YOUR_USERNAME>."

REMOTE_PATH="/tmp/thinkpad-vnc-setup-${USER:-mac}-$$.sh"

scp "$LOCAL_SETUP" "${SSH_ALIAS}:${REMOTE_PATH}" >/dev/null

echo "Running setup with a remote terminal so sudo and vncpasswd can prompt."
ssh -t "$SSH_ALIAS" "bash '$REMOTE_PATH'; status=\$?; rm -f '$REMOTE_PATH'; exit \$status"
