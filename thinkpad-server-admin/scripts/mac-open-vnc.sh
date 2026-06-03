#!/usr/bin/env bash
set -euo pipefail

SSH_ALIAS="${SSH_ALIAS:-thinkpad}"
LOCAL_PORT="${LOCAL_PORT:-5902}"
REMOTE_PORT="${REMOTE_PORT:-5902}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Checking SSH access with: ssh thinkpad"
ssh "$SSH_ALIAS" true

echo "Starting Lenovo VNC session if it is not already running."
if ! ssh "$SSH_ALIAS" "vncserver -list 2>/dev/null | grep -qE '^[[:space:]]*2[[:space:]]'"; then
  ssh "$SSH_ALIAS" "bash -s" < "${SCRIPT_DIR}/linux-start-vnc.sh"
else
  echo "VNC display :2 is already running on the Lenovo."
fi

if nc -z 127.0.0.1 "$LOCAL_PORT" >/dev/null 2>&1; then
  echo "Local port ${LOCAL_PORT} is already open; reusing existing tunnel."
else
  echo "Opening SSH tunnel: ${LOCAL_PORT}:127.0.0.1:${REMOTE_PORT}"
  echo "If SSH asks for a password, use the Lenovo Linux password for user <YOUR_USERNAME>."
  ssh -fN -o ExitOnForwardFailure=yes -L ${LOCAL_PORT}:127.0.0.1:${REMOTE_PORT} "$SSH_ALIAS"
fi

if ! nc -z 127.0.0.1 "$LOCAL_PORT" >/dev/null 2>&1; then
  echo "FAIL local VNC tunnel is not reachable on 127.0.0.1:${LOCAL_PORT}." >&2
  exit 1
fi

echo "Opening Mac Screen Sharing."
open -a "Screen Sharing" vnc://127.0.0.1:5902

echo "Screen Sharing requested for vnc://127.0.0.1:${LOCAL_PORT}."
echo "The SSH tunnel remains in the background. Close it later with:"
echo "pkill -f 'ssh -fN -o ExitOnForwardFailure=yes -L ${LOCAL_PORT}:127.0.0.1:${REMOTE_PORT} ${SSH_ALIAS}'"
