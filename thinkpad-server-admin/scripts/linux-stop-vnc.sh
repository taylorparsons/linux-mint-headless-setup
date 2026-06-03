#!/usr/bin/env bash
set -u

DISPLAY_ID="${DISPLAY_ID:-:2}"

if ! command -v vncserver >/dev/null 2>&1; then
  echo "FAIL vncserver is not installed." >&2
  exit 1
fi

echo "Stopping TigerVNC display ${DISPLAY_ID}."
vncserver -kill :2
