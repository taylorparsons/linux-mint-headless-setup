from pathlib import Path
import unittest


ROOT = Path(__file__).resolve().parent.parent
SERVER_ADMIN = ROOT / "thinkpad-server-admin"


class InstallAssetTests(unittest.TestCase):
    def test_remote_desktop_assets_support_ssh_tunneled_mac_screen_sharing(self):
        expected = [
            "docs/remote-desktop.md",
            "scripts/mac-setup-vnc.sh",
            "scripts/linux-setup-vnc.sh",
            "scripts/linux-start-vnc.sh",
            "scripts/linux-stop-vnc.sh",
            "scripts/mac-open-vnc.sh",
            "scripts/verify-remote-desktop.sh",
        ]
        for relative in expected:
            self.assertTrue((SERVER_ADMIN / relative).exists(), f"{relative} missing")

        readme = (SERVER_ADMIN / "README.md").read_text()
        self.assertIn("docs/remote-desktop.md", readme)
        self.assertIn("Mac Screen Sharing", readme)

        runbook = (SERVER_ADMIN / "docs/remote-desktop.md").read_text()
        for required in [
            "TigerVNC",
            "XFCE",
            "Mac Screen Sharing",
            "vncpasswd",
            "vncserver -localhost yes -geometry 1440x900 -depth 24 :2",
            "ssh -N -L 5902:127.0.0.1:5902 thinkpad",
            'open -a "Screen Sharing" vnc://127.0.0.1:5902',
            "vncserver -kill :2",
            "./scripts/mac-setup-vnc.sh",
            "ssh -t thinkpad",
            "Do not store the VNC password",
            "Do not open VNC directly on the LAN",
        ]:
            self.assertIn(required, runbook)
        self.assertNotIn("ssh thinkpad 'bash -s' < scripts/linux-setup-vnc.sh", runbook)

        scripts = {relative: (SERVER_ADMIN / relative) for relative in expected if relative.startswith("scripts/")}
        for script in scripts.values():
            text = script.read_text()
            self.assertTrue(script.stat().st_mode & 0o111, f"{script.name} not executable")
            self.assertRegex(text, r"set -(u|euo pipefail)")
            self.assertNotIn("ufw allow", text.lower())
            self.assertNotIn("0.0.0.0", text)
            self.assertNotRegex(text, r"(?i)(password|secret)\s*=\s*\S+")

        setup_text = scripts["scripts/linux-setup-vnc.sh"].read_text()
        self.assertIn("set -euo pipefail", setup_text)
        for package in [
            "tigervnc-standalone-server",
            "tigervnc-common",
            "xfce4",
            "xfce4-goodies",
            "dbus-x11",
        ]:
            self.assertIn(package, setup_text)
        self.assertIn("vncpasswd", setup_text)
        self.assertIn("command -v vncpasswd", setup_text)
        self.assertIn("exec startxfce4", setup_text)
        self.assertIn("~/.vnc/xstartup", setup_text)
        self.assertIn("apt install", setup_text)

        mac_setup_text = scripts["scripts/mac-setup-vnc.sh"].read_text()
        self.assertIn("scp", mac_setup_text)
        self.assertIn("ssh -t", mac_setup_text)
        self.assertIn("linux-setup-vnc.sh", mac_setup_text)
        self.assertIn("/tmp/thinkpad-vnc-setup-", mac_setup_text)
        self.assertNotIn("mktemp", mac_setup_text)
        self.assertIn("rm -f", mac_setup_text)

        start_text = scripts["scripts/linux-start-vnc.sh"].read_text()
        self.assertIn("vncserver -localhost yes -geometry 1440x900 -depth 24 :2", start_text)

        stop_text = scripts["scripts/linux-stop-vnc.sh"].read_text()
        self.assertIn("vncserver -kill :2", stop_text)

        mac_text = scripts["scripts/mac-open-vnc.sh"].read_text()
        self.assertIn("ssh thinkpad", mac_text)
        self.assertIn("bash -s", mac_text)
        self.assertIn("linux-start-vnc.sh", mac_text)
        self.assertIn("ssh -fN", mac_text)
        self.assertIn("ExitOnForwardFailure=yes", mac_text)
        self.assertIn("nc -z 127.0.0.1", mac_text)
        self.assertIn("LOCAL_PORT:-5902", mac_text)
        self.assertIn("${LOCAL_PORT}:127.0.0.1:${REMOTE_PORT}", mac_text)
        self.assertIn('open -a "Screen Sharing" vnc://127.0.0.1:5902', mac_text)

        verify_text = scripts["scripts/verify-remote-desktop.sh"].read_text()
        self.assertIn("PASS", verify_text)
        self.assertIn("FAIL", verify_text)
        self.assertIn("vncserver -list", verify_text)
        self.assertIn("ss -ltn", verify_text)
        self.assertIn("127.0.0.1:5902", verify_text)

    def test_thinkpad_server_admin_project_exists_with_safe_scripts(self):
        expected = [
            "README.md",
            "docs/current-state.md",
            "docs/recovery.md",
            "docs/do-not-delete.md",
            "configs/Caddyfile",
            "configs/smb-MacShare.conf",
            "configs/mac-ssh-config-snippet",
            "scripts/verify-server.sh",
            "scripts/backup-uptime-kuma.sh",
            "scripts/test-smb-share.sh",
        ]
        for relative in expected:
            self.assertTrue((SERVER_ADMIN / relative).exists(), f"{relative} missing")

        readme = (SERVER_ADMIN / "README.md").read_text()
        self.assertIn("<YOUR_REPO_PATH>/thinkpad-server-admin", readme)
        self.assertIn("source of truth", readme)
        self.assertIn("/Volumes/<YOUR_SHARE_NAME>/thinkpad-server-admin", readme)
        self.assertIn("mirror", readme)
        self.assertIn("can be lost", readme)
        self.assertIn("<YOUR_IP>", readme)
        self.assertIn("ssh thinkpad", readme)
        self.assertIn("https://<YOUR_IP>", readme)
        self.assertIn("/Volumes/<YOUR_SHARE_NAME>", readme)
        self.assertIn("P0", readme)

        state = (SERVER_ADMIN / "docs/current-state.md").read_text()
        for required in [
            "Linux Mint 22.3 Zena",
            "6.17.0-35-generic",
            "Docker 29.1.3",
            "uptime-kuma",
            "127.0.0.1:3001:3001",
            "Caddy",
            "Samba",
            "Do not store actual passwords",
        ]:
            self.assertIn(required, state)

        self.assertEqual(
            (SERVER_ADMIN / "configs/Caddyfile").read_text().strip(),
            "https://<YOUR_IP> {\n    tls internal\n    reverse_proxy 127.0.0.1:3001\n}",
        )
        self.assertIn("[<YOUR_SHARE_NAME>]", (SERVER_ADMIN / "configs/smb-MacShare.conf").read_text())
        self.assertIn("Host thinkpad", (SERVER_ADMIN / "configs/mac-ssh-config-snippet").read_text())

        verify_script = (SERVER_ADMIN / "scripts/verify-server.sh")
        backup_script = (SERVER_ADMIN / "scripts/backup-uptime-kuma.sh")
        smb_script = (SERVER_ADMIN / "scripts/test-smb-share.sh")
        for script in [verify_script, backup_script, smb_script]:
            text = script.read_text()
            self.assertTrue(script.stat().st_mode & 0o111, f"{script.name} not executable")
            self.assertIn("set -u", text)
            self.assertNotIn("docker volume rm", text)
            self.assertNotIn("rm -rf", text)

        verify_text = verify_script.read_text()
        self.assertIn("PASS", verify_text)
        self.assertIn("FAIL", verify_text)
        self.assertIn("ssh thinkpad", verify_text)
        self.assertIn("docker is-active", verify_text)
        self.assertIn("docker inspect", verify_text)
        self.assertIn("caddy is-active", verify_text)
        self.assertIn("curl", verify_text)
        self.assertIn("nc -z", verify_text)

        backup_text = backup_script.read_text()
        self.assertIn("/home/<YOUR_USERNAME>/server-backups", backup_text)
        self.assertIn("uptime-kuma-backup-", backup_text)
        self.assertIn("tar -czf", backup_text)
        self.assertIn("Refusing to overwrite", backup_text)
        self.assertNotIn("docker stop", backup_text)

        smb_text = smb_script.read_text()
        self.assertIn("/Volumes/<YOUR_SHARE_NAME>", smb_text)
        self.assertIn("/home/<YOUR_USERNAME>/<YOUR_SHARE_NAME>", smb_text)
        self.assertIn("Delete test files", smb_text)
        self.assertIn("read -r", smb_text)

        safety = (SERVER_ADMIN / "docs/do-not-delete.md").read_text()
        self.assertIn("Do not delete backups", safety)
        self.assertIn("Do not delete Docker volumes", safety)
        self.assertIn("Do not delete `/home/<YOUR_USERNAME>/<YOUR_SHARE_NAME>`", safety)
        project_text = "\n".join((SERVER_ADMIN / relative).read_text() for relative in expected)
        self.assertNotRegex(project_text, r"(?i)(password|secret)\s*=\s*\S+")
        self.assertNotRegex(project_text, r"(?i)(actual password|real password)\s*:\s*\S+")

    def test_ssh_runbook_exists_and_covers_mac_to_lenovo_access(self):
        path = ROOT / "LENOVA-SSH.md"
        self.assertTrue(path.exists(), "SSH runbook missing")
        text = path.read_text()
        self.assertIn("ssh <linux-username>@<thinkpad-ip-address>", text)
        self.assertIn("ssh <linux-username>@<hostname>.local", text)
        self.assertIn("sudo systemctl enable --now ssh", text)
        self.assertIn("sudo -i", text)
        self.assertIn("hostname -I", text)
        self.assertIn("hostname", text)
        self.assertNotIn("root ssh", text.lower())

    def test_windows_download_helper_exists_and_targets_official_sources(self):
        path = ROOT / "download-mint-and-rufus.bat"
        self.assertTrue(path.exists(), "download helper missing")
        text = path.read_text()
        self.assertIn("Linux-Mint-Download", text)
        self.assertIn("https://www.linuxmint.com/download.php", text)
        self.assertIn("https://www.linuxmint.com/edition.php?id=327", text)
        self.assertIn("https://rufus.ie/", text)
        self.assertIn("https://rufus.ie/downloads/?pubDate=20260128", text)
        self.assertIn("Rufus 3.22", text)
        self.assertIn("start", text.lower())
        self.assertNotIn("diskpart", text.lower())
        self.assertNotIn("format ", text.lower())

    def test_preflight_batch_exists_and_is_safe(self):
        path = ROOT / "thinkpad-linux-preflight.bat"
        self.assertTrue(path.exists(), "batch script missing")
        text = path.read_text()
        self.assertIn("ThinkPad-Linux-Install-Info", text)
        self.assertIn("systeminfo", text)
        self.assertIn("wmic computersystem", text)
        self.assertIn("wmic cpu", text)
        self.assertIn("wmic bios", text)
        self.assertIn("wmic diskdrive", text)
        self.assertIn("wmic logicaldisk", text)
        self.assertIn("wmic memorychip", text)
        self.assertIn("wmic path win32_videocontroller", text.lower())
        self.assertIn("wmic nic", text.lower())
        self.assertIn("102400", text)
        self.assertIn("153600", text)
        self.assertIn("Disk Management", text)
        self.assertIn("Do not continue without cleanup", text)
        self.assertNotIn("diskpart /s", text.lower())
        self.assertNotIn("format ", text.lower())
        self.assertNotIn("delete partition", text.lower())

    def test_shrink_script_exists_and_is_manual_only(self):
        path = ROOT / "shrink-c-for-linux.txt"
        self.assertTrue(path.exists(), "diskpart instructions missing")
        text = path.read_text()
        command_lines = [
            line.strip().lower()
            for line in text.splitlines()
            if line.strip() and not line.strip().lower().startswith("rem ")
        ]
        self.assertIn("WARNING", text)
        self.assertIn("select volume C", text)
        self.assertIn("shrink desired=102400", text)
        self.assertIn("153600", text)
        self.assertFalse(any(line.startswith("create partition") for line in command_lines))
        self.assertFalse(any(line.startswith("format") for line in command_lines))
        self.assertFalse(any(line.startswith("assign") for line in command_lines))

    def test_post_install_script_exists_and_has_requested_packages(self):
        path = ROOT / "mint-post-install.sh"
        self.assertTrue(path.exists(), "post-install script missing")
        text = path.read_text()
        self.assertIn("apt update", text)
        self.assertIn("apt upgrade", text)
        for package in [
            "openssh-server",
            "git",
            "curl",
            "wget",
            "htop",
            "neofetch",
            "build-essential",
            "avahi-daemon",
        ]:
            self.assertIn(package, text)
        self.assertIn("systemctl enable --now ssh", text)
        self.assertIn("systemctl enable --now avahi-daemon", text)
        self.assertIn(".local", text)
        self.assertIn("ssh <", text)

    def test_readme_exists_and_covers_manual_flow(self):
        path = ROOT / "README.md"
        self.assertTrue(path.exists(), "README missing")
        text = path.read_text()
        self.assertIn("thinkpad-linux-preflight.bat", text)
        self.assertIn("download-mint-and-rufus.bat", text)
        self.assertIn("LENOVA-SSH.md", text)
        self.assertIn("shrink-c-for-linux.txt", text)
        self.assertIn("mint-post-install.sh", text)
        self.assertIn("150 GB", text)
        self.assertIn("alongside Windows 7", text)
        self.assertIn("<YOUR_IP>", text)
        self.assertIn("<YOUR_USERNAME>", text)
        self.assertIn("<YOUR_SHARE_NAME>", text)
        self.assertNotIn("erase the disk", text.lower())
        self.assertNotIn("delete windows", text.lower())


    def test_auto_update_assets_exist_and_notify_mac(self):
        expected = [
            "docs/updates.md",
            "scripts/linux-setup-auto-updates.sh",
            "scripts/mac-setup-auto-updates.sh",
            "scripts/mac-notify-updates.sh",
        ]
        for relative in expected:
            self.assertTrue((SERVER_ADMIN / relative).exists(), f"{relative} missing")

        scripts = [SERVER_ADMIN / r for r in expected if r.startswith("scripts/")]
        for script in scripts:
            text = script.read_text()
            self.assertTrue(script.stat().st_mode & 0o111, f"{script.name} not executable")
            self.assertRegex(text, r"set -(u|euo pipefail)")
            self.assertNotIn("ufw allow", text.lower())
            self.assertNotIn("0.0.0.0", text)
            self.assertNotRegex(text, r"(?i)(password|secret)\s*=\s*\S+")

        setup_text = (SERVER_ADMIN / "scripts/linux-setup-auto-updates.sh").read_text()
        self.assertIn("unattended-upgrades", setup_text)
        self.assertIn("apt-get install", setup_text)
        self.assertIn("crontab", setup_text)
        self.assertIn("apt-get update", setup_text)
        self.assertIn("PASS", setup_text)

        mac_setup_text = (SERVER_ADMIN / "scripts/mac-setup-auto-updates.sh").read_text()
        self.assertIn("ssh", mac_setup_text)
        self.assertIn("linux-setup-auto-updates.sh", mac_setup_text)
        self.assertIn("thinkpad", mac_setup_text)
        self.assertNotRegex(mac_setup_text, r"(?i)(password|secret)\s*=\s*\S+")

        notify_text = (SERVER_ADMIN / "scripts/mac-notify-updates.sh").read_text()
        self.assertIn("osascript", notify_text)
        self.assertIn("display notification", notify_text)
        self.assertIn("ssh", notify_text)
        self.assertIn("apt list --upgradable", notify_text)
        self.assertIn("thinkpad", notify_text)
        self.assertIn("sudo apt upgrade -y", notify_text)
        self.assertNotIn("password", notify_text.lower())

        doc_text = (SERVER_ADMIN / "docs/updates.md").read_text()
        for required in [
            "unattended-upgrades",
            "sudo apt upgrade -y",
            "mac-notify-updates.sh",
            "linux-setup-auto-updates.sh",
            "osascript",
            "crontab",
            "Do not store",
            "ssh thinkpad",
        ]:
            self.assertIn(required, doc_text)


if __name__ == "__main__":
    unittest.main()
