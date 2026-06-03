#!/usr/bin/env bash
set -u

SSH_ALIAS="${SSH_ALIAS:-thinkpad}"

pass() { printf 'PASS %s\n' "$1"; }
fail() { printf 'FAIL %s\n' "$1"; }

check() {
  label="$1"
  shift
  if "$@" >/dev/null 2>&1; then
    pass "$label"
  else
    fail "$label"
  fi
}

echo "Remote desktop verification from the Mac."
echo "If SSH asks for a password, use the Lenovo Linux password for user <YOUR_USERNAME>."

check "ssh thinkpad works" ssh "$SSH_ALIAS" true
check "vncserver command exists" ssh "$SSH_ALIAS" "command -v vncserver"
check "XFCE session command exists" ssh "$SSH_ALIAS" "command -v startxfce4"
check "VNC xstartup exists" ssh "$SSH_ALIAS" "test -x ~/.vnc/xstartup && grep -q 'exec startxfce4' ~/.vnc/xstartup"
check "VNC password file exists" ssh "$SSH_ALIAS" "test -f ~/.vnc/passwd"
check "vncserver -list runs" ssh "$SSH_ALIAS" "vncserver -list"
check "VNC localhost listener is present on 127.0.0.1:5902" ssh "$SSH_ALIAS" "ss -ltn | grep -q '127.0.0.1:5902'"
check "VNC is not listening on all interfaces" ssh "$SSH_ALIAS" "! ss -ltn | grep -Eq '(^|[[:space:]])0\\.0\\.0\\.0:5902|\\*:5902'"
