# Documentation Site

## Current Structure

The user-facing docs live in `luna_lighthouse-docs/`. The structure is GitBook-style Markdown with navigation in `luna_lighthouse-docs/SUMMARY.md`.

Top-level doc sections currently include:

- Getting Started
- LunaLighthouse
- Modules
- Releases

## Relaunch-Relevant Pages

Important phase-1 pages include:

- `luna_lighthouse-docs/getting-started/build-channels.md`
- `luna_lighthouse-docs/getting-started/platform-restrictions.md`
- `luna_lighthouse-docs/luna_lighthouse/cloud-account.md`
- `luna_lighthouse-docs/luna_lighthouse/local-backup-and-restore.md`
- `luna_lighthouse-docs/luna_lighthouse/notifications/README.md`
- `luna_lighthouse-docs/modules/*.md`
- `luna_lighthouse-docs/releases/*.md`

## Maintenance Notes

Public docs should keep cloud and notification relay behavior aligned with the Flutter feature flag. While `cloudIntegrationsEnabled` is false, docs should describe hosted notifications and cloud account flows as unavailable or deferred, while preserving local module setup and local backup/restore instructions.
