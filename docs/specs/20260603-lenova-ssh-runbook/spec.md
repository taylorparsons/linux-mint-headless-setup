# Feature Spec: 20260603-lenova-ssh-runbook

Status: Done

## Functional Requirements

- FR-001: The repo must include `LENOVA-SSH.md`, a dedicated markdown runbook that explains how to start SSH on the Lenovo, how to connect from macOS with the Lenovo IP address or `.local` hostname, and how to use `sudo` for admin access instead of enabling root SSH login. (Sources: CR-20260603-0930; D-20260603-0932)

## Acceptance Scenarios

- Given the root SSH runbook in the repo, when a user opens it, then it tells them how to enable SSH on the Lenovo, connect from the Mac with either the IP address or `.local` hostname, and use `sudo` for admin work without root SSH. (Verifies: FR-001)
