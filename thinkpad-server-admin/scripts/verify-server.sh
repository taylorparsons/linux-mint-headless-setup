#!/usr/bin/env bash
set -u

SSH_ALIAS="${SSH_ALIAS:-thinkpad}"
SERVER_IP="${SERVER_IP:-<YOUR_IP>}"
MAC_SHARE="${MAC_SHARE:-/Volumes/<YOUR_SHARE_NAME>}"
if [ -t 0 ]; then
  SSH_OPTS=(-o ConnectTimeout=5)
else
  SSH_OPTS=(-o BatchMode=yes -o ConnectTimeout=5)
fi

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

echo "Read-only verification from the Mac."
echo "SSH command: ssh thinkpad"
echo "If SSH asks for a password, use the Lenovo Linux password for user <YOUR_USERNAME>."
if [ ! -t 0 ]; then
  echo "Non-interactive run: SSH password prompts are disabled, so password-only SSH will show as FAIL."
fi

check "ssh ${SSH_ALIAS} works" ssh "${SSH_OPTS[@]}" "$SSH_ALIAS" true
check "docker is-active" ssh "${SSH_OPTS[@]}" "$SSH_ALIAS" "systemctl is-active --quiet docker"
check "uptime-kuma container is running" ssh "${SSH_OPTS[@]}" "$SSH_ALIAS" "docker inspect -f '{{.State.Running}}' uptime-kuma | grep -qx true"
check "uptime-kuma restart policy is always" ssh "${SSH_OPTS[@]}" "$SSH_ALIAS" "docker inspect -f '{{.HostConfig.RestartPolicy.Name}}' uptime-kuma | grep -qx always"
check "caddy is-active" ssh "${SSH_OPTS[@]}" "$SSH_ALIAS" "systemctl is-active --quiet caddy"
check "HTTPS responds on ${SERVER_IP}" curl -k -I --max-time 10 "https://${SERVER_IP}"
check "Samba port 445 reachable" nc -z -G 5 "$SERVER_IP" 445

if [ -d "$MAC_SHARE" ]; then
  pass "${MAC_SHARE} exists"
else
  fail "${MAC_SHARE} exists"
fi
