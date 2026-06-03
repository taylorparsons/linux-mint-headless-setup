# Feature Spec: 20260602-thinkpad-linux-mint-dual-boot

Status: Done

## Functional Requirements

- FR-001: The repo must include `thinkpad-linux-preflight.bat`, which creates `%USERPROFILE%\Desktop\ThinkPad-Linux-Install-Info`, writes system inventory reports into that folder, evaluates C: free space, prints shrink recommendations for `102400` MB and `153600` MB when free space exceeds `200 GB`, warns against continuing when free space is lower, and never changes partitions. (Sources: CR-20260602-1253; D-20260602-1304)
- FR-005: The repo must include `download-mint-and-rufus.bat`, which creates a Desktop download folder, opens the official Linux Mint XFCE, Rufus, and archived Rufus 3.22 pages in the default browser, guides the user to the Windows 7-compatible `Rufus 3.22` archive entry, and keeps all disk and boot changes manual. (Sources: CR-20260602-1330, CR-20260602-1342; D-20260602-1332, D-20260602-1344)
- FR-006: The repo documentation must reflect the live Lenovo result that entering `153600` MB in Disk Management produced about `150 GB` unallocated space and that the archived Rufus 3.22 page is the working source when the older direct EXE URL is unavailable. (Sources: CR-20260602-1342; D-20260602-1344)
- FR-002: The repo must include `shrink-c-for-linux.txt`, which contains warnings, selects C:, shrinks by `102400` MB by default, shows the `153600` MB alternative as commented guidance, and leaves resulting space unallocated. (Sources: CR-20260602-1253; D-20260602-1304)
- FR-003: The repo must include `mint-post-install.sh`, which updates apt metadata, upgrades packages, installs the requested tools, enables SSH and Avahi, prints an IP-based SSH command, and prints a `.local` SSH option when hostname discovery is available. (Sources: CR-20260602-1253)
- FR-004: The repo must include `README.md`, which leads with the scripts, then lists the exact run order, official Linux Mint and Rufus download locations, Rufus settings, manual boot/install steps, Mac SSH commands, and a stop instruction before risky partition actions or ambiguous installer options. (Sources: CR-20260602-1253; D-20260602-1258, D-20260602-1304)

## Acceptance Scenarios

- Given the batch script in the repo, when a user opens it, then it shows only information-gathering and recommendation logic with no partition-changing command. (Verifies: FR-001)
- Given the download helper in the repo, when a user opens it, then it creates a Desktop download folder, opens the official Mint, Rufus, and archived Rufus 3.22 pages, and points the user at the Windows 7-compatible archive entry. (Verifies: FR-005)
- Given the DiskPart file in the repo, when a user reviews it, then it clearly warns before use and contains only a manual shrink flow that leaves free space unallocated. (Verifies: FR-002)
- Given the Linux Mint helper script in the repo, when a user runs a shell syntax check or reads it, then it shows the requested package install and service enablement flow plus SSH guidance. (Verifies: FR-003)
- Given the README in the repo, when a user follows it, then they can complete the Windows preflight, optional manual shrink, USB creation, live boot testing, install decision point, and SSH follow-up without instructions to erase Windows. (Verifies: FR-004)
- Given the updated docs, when a user follows them after a successful shrink, then they see the observed `150 GB` unallocated result and the official archived Rufus 3.22 path recorded in the runbook. (Verifies: FR-006)
