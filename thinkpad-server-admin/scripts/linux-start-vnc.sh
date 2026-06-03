#!/usr/bin/env bash
set -u

DISPLAY_ID="${DISPLAY_ID:-:2}"
GEOMETRY="${GEOMETRY:-1440x900}"
DEPTH="${DEPTH:-24}"

if ! command -v vncserver >/dev/null 2>&1; then
  echo "FAIL vncserver is not installed. Run linux-setup-vnc.sh first." >&2
  exit 1
fi

if [ ! -f "$HOME/.vnc/passwd" ]; then
  echo "FAIL VNC password is not configured. Run vncpasswd over SSH first." >&2
  exit 1
fi

mkdir -p "$HOME/.vnc"
if [ ! -x "$HOME/.vnc/xstartup" ]; then
  echo "FAIL ~/.vnc/xstartup is missing or not executable. Run linux-setup-vnc.sh first." >&2
  exit 1
fi

echo "Starting TigerVNC on ${DISPLAY_ID}, bound to Lenovo localhost only."
vncserver -localhost yes -geometry 1440x900 -depth 24 :2
