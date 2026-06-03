#!/usr/bin/env bash
set -u

SSH_ALIAS="${SSH_ALIAS:-thinkpad}"
BACKUP_DIR="/home/taylor/server-backups"
VOLUME="uptime-kuma"
STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_NAME="uptime-kuma-backup-${STAMP}.tar.gz"
BACKUP_PATH="${BACKUP_DIR}/${BACKUP_NAME}"

echo "Creating timestamped Uptime Kuma backup on Lenovo."
echo "If SSH or sudo asks for a password, use the Lenovo Linux password for user taylor."

ssh "$SSH_ALIAS" "set -eu
mkdir -p '$BACKUP_DIR'
if [ -e '$BACKUP_PATH' ]; then
  echo 'Refusing to overwrite existing backup: $BACKUP_PATH' >&2
  exit 1
fi
docker volume inspect '$VOLUME' >/dev/null
docker run --rm \
  -v '${VOLUME}:/volume:ro' \
  -v '${BACKUP_DIR}:/backup' \
  alpine:3.20 \
  tar -czf '/backup/${BACKUP_NAME}' -C /volume .
ls -lh '$BACKUP_PATH'
"
