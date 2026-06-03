#!/usr/bin/env bash
set -euo pipefail

if [[ "${EUID}" -eq 0 ]]; then
  SUDO=""
else
  SUDO="sudo"
fi

PACKAGES=(
  openssh-server
  git
  curl
  wget
  htop
  neofetch
  build-essential
  avahi-daemon
)

echo "Updating package lists..."
$SUDO apt update

echo "Upgrading installed packages..."
$SUDO apt upgrade -y

echo "Installing requested packages..."
$SUDO apt install -y "${PACKAGES[@]}"

echo "Enabling SSH and Avahi..."
$SUDO systemctl enable --now ssh
$SUDO systemctl enable --now avahi-daemon

IP_ADDRESS="$(hostname -I 2>/dev/null | awk '{print $1}')"
HOSTNAME_VALUE="$(hostname)"

echo
if [[ -n "${IP_ADDRESS}" ]]; then
  echo "Detected IP address: ${IP_ADDRESS}"
  echo "SSH from your MacBook with:"
  echo "ssh <linux-username>@${IP_ADDRESS}"
else
  echo "Could not detect an IP address automatically."
fi

echo
if command -v avahi-resolve-host-name >/dev/null 2>&1 && avahi-resolve-host-name "${HOSTNAME_VALUE}.local" >/dev/null 2>&1; then
  echo "Avahi hostname looks ready."
  echo "ssh <linux-username>@${HOSTNAME_VALUE}.local"
else
  echo "If Avahi is working on your network, also try:"
  echo "ssh <linux-username>@${HOSTNAME_VALUE}.local"
fi
