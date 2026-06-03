#!/usr/bin/env bash
set -euo pipefail

# Run once on the Lenovo via: ssh -t thinkpad 'bash -s' < scripts/linux-setup-auto-updates.sh

echo "Installing unattended-upgrades..."
if ! sudo apt-get install -y unattended-upgrades; then
    echo "FAIL apt-get install failed." >&2
    exit 1
fi

echo "Configuring unattended-upgrades for security patches only..."
sudo tee /etc/apt/apt.conf.d/51lenova-auto-updates > /dev/null <<'EOF'
Unattended-Upgrade::Allowed-Origins {
    "${distro_id}:${distro_codename}-security";
    "${distro_id}ESMApps:${distro_codename}-apps-security";
    "${distro_id}ESM:${distro_codename}-infra-security";
};
Unattended-Upgrade::AutoFixInterruptedDpkg "true";
Unattended-Upgrade::Remove-Unused-Dependencies "true";
EOF

echo "Adding daily apt-get update to root crontab (05:00)..."
(sudo crontab -l 2>/dev/null | grep -v "apt-get update -qq" || true
 echo "0 5 * * * apt-get update -qq") | sudo crontab -

echo "PASS auto-update setup complete."
echo "  - Security patches will apply automatically via unattended-upgrades."
echo "  - apt cache refreshes daily at 05:00 so Mac notification checks need no sudo."
echo "  - Run mac-notify-updates.sh from the Mac to check for non-security updates."
