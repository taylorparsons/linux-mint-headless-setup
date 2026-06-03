#!/usr/bin/env bash
set -u

SSH_ALIAS="${SSH_ALIAS:-thinkpad}"
MAC_SHARE="${MAC_SHARE:-/Volumes/<YOUR_SHARE_NAME>}"
LENOVO_SHARE="${LENOVO_SHARE:-/home/<YOUR_USERNAME>/<YOUR_SHARE_NAME>}"
STAMP="$(date +%Y%m%d-%H%M%S)"
MAC_FILE="${MAC_SHARE}/mac-to-lenovo-test-${STAMP}.txt"
LENOVO_FILE="${LENOVO_SHARE}/lenovo-to-mac-test-${STAMP}.txt"
MAC_VIEW_OF_LENOVO_FILE="${MAC_SHARE}/lenovo-to-mac-test-${STAMP}.txt"

echo "Testing SMB visibility in both directions."
echo "If SSH asks for a password, use the Lenovo Linux password for user <YOUR_USERNAME>."

if [ ! -d "$MAC_SHARE" ]; then
  echo "FAIL ${MAC_SHARE} is not mounted."
  echo "Mount Finder share first: smb://<YOUR_IP>/<YOUR_SHARE_NAME>"
  exit 1
fi

printf 'Mac to Lenovo SMB test %s\n' "$STAMP" > "$MAC_FILE"
if ssh "$SSH_ALIAS" "test -f '$LENOVO_SHARE/$(basename "$MAC_FILE")'"; then
  echo "PASS Mac-created file is visible on Lenovo: $LENOVO_SHARE/$(basename "$MAC_FILE")"
else
  echo "FAIL Mac-created file is not visible on Lenovo."
  exit 1
fi

ssh "$SSH_ALIAS" "printf 'Lenovo to Mac SMB test %s\n' '$STAMP' > '$LENOVO_FILE'"
if [ -f "$MAC_VIEW_OF_LENOVO_FILE" ]; then
  echo "PASS Lenovo-created file is visible on Mac: $MAC_VIEW_OF_LENOVO_FILE"
else
  echo "FAIL Lenovo-created file is not visible on Mac."
  exit 1
fi

echo "Test files:"
echo "- $MAC_FILE"
echo "- $MAC_VIEW_OF_LENOVO_FILE"
printf 'Delete test files now? Type yes to delete, anything else to leave them: '
read -r answer
if [ "$answer" = "yes" ]; then
  rm -f "$MAC_FILE" "$MAC_VIEW_OF_LENOVO_FILE"
  echo "Deleted test files."
else
  echo "Left timestamped test files in place."
fi
