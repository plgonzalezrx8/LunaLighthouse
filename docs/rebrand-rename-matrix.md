# Rebrand Rename Matrix (Source of Truth)

Use this matrix for all rename/rebrand PRs.

## Canonical Values

| Area | Canonical value |
| --- | --- |
| Product name | `Lunarr` |
| iOS bundle ID | `app.lunarr.lunarr` |
| Android application ID | `app.lunarr.lunarr` |
| Website | `https://www.lunarr.app` |
| Docs | `https://docs.lunarr.app` |
| Build bucket | `https://builds.lunarr.app` |
| Notification host | `https://notify.lunarr.app` |
| Backup bucket naming prefix | `backup.lunarr.app` |
| Notification relay repo/image | `lunarr-notification-service` |
| Cloud functions naming | `lunarr-cloud-functions` |

## Public-Facing Rename Scope

| Category | From | To |
| --- | --- | --- |
| App display strings | LunaSea | Lunarr |
| Package/bundle IDs | `app.lunasea.lunasea` | `app.lunarr.lunarr` |
| Domains | `*.lunasea.app` | `*.lunarr.app` |
| CI artifacts | `lunasea-*` | `lunarr-*` |
| Docker/container labels | `lunasea*` | `lunarr*` |
| Support links | old owner endpoints | Lunarr-owned endpoints |

## Deferred Internal Rename Boundary (Phase 1)

The following can remain unchanged during relaunch if user-facing behavior is unaffected:

- Localization key prefixes such as `lunasea.*`.
- Internal class names/types (for example `LunaSeaDatabase`).
- Historical changelog references to pre-fork commits.

These are phase-2 cleanup tasks and must not block mobile relaunch stability.
