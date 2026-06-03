#!/usr/bin/env bash
set -euo pipefail

PACKAGES=(
  tigervnc-standalone-server
  tigervnc-common
  xfce4
  xfce4-goodies
  dbus-x11
)

if [ "$(id -u)" -eq 0 ]; then
  SUDO=""
else
  SUDO="sudo"
fi

echo "Installing TigerVNC virtual XFCE desktop packages."
echo "If sudo asks for a password, use the Lenovo Linux password for user taylor."
$SUDO apt update
$SUDO apt install -y "${PACKAGES[@]}"

if ! command -v vncpasswd >/dev/null 2>&1; then
  echo "FAIL vncpasswd was not installed. Package installation did not complete correctly." >&2
  exit 1
fi

mkdir -p "$HOME/.vnc"
cat > "$HOME/.vnc/xstartup" <<'EOF'
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
exec startxfce4
EOF
chmod +x "$HOME/.vnc/xstartup"

echo "Wrote ~/.vnc/xstartup for XFCE."
if [ ! -f "$HOME/.vnc/passwd" ]; then
  echo "No VNC password file found. Run vncpasswd now and do not store the password in this repo."
  vncpasswd
else
  echo "Existing VNC password file found at ~/.vnc/passwd."
fi

echo "Setup complete. From the Mac project directory, start VNC with:"
echo "ssh thinkpad 'bash -s' < scripts/linux-start-vnc.sh"
