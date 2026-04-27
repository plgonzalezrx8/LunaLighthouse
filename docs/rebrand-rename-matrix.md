# Rebrand Rename Matrix (Source of Truth)

Use this matrix for all rename/rebrand PRs.

## Canonical Values

| Area | Canonical value |
| --- | --- |
| Product name | `LunaLighthouse` |
| iOS bundle ID | `app.lunalighthouse.lunalighthouse` |
| Android application ID | `app.lunalighthouse.lunalighthouse` |
| Website | `https://www.lunalighthouse.app` |
| Docs | `https://docs.lunalighthouse.app` |
| Build bucket | `https://builds.lunalighthouse.app` |
| Notification host | `https://notify.lunalighthouse.app` |
| Backup bucket naming prefix | `backup.lunalighthouse.app` |
| Notification relay repo/image | `lunalighthouse-notification-service` |
| Cloud functions naming | `lunalighthouse-cloud-functions` |

## Public-Facing Rename Scope

| Category | From | To |
| --- | --- | --- |
| App display strings | LunaLighthouse | LunaLighthouse |
| Package/bundle IDs | `app.luna_lighthouse.luna_lighthouse` | `app.lunalighthouse.lunalighthouse` |
| Domains | `*.luna_lighthouse.app` | `*.lunalighthouse.app` |
| CI artifacts | `luna_lighthouse-*` | `lunalighthouse-*` |
| Docker/container labels | `luna_lighthouse*` | `lunalighthouse*` |
| Support links | old owner endpoints | LunaLighthouse-owned endpoints |

## Deferred Internal Rename Boundary (Phase 1)

The following can remain unchanged during relaunch if user-facing behavior is unaffected:

- Localization key prefixes such as `luna_lighthouse.*`.
- Internal class names/types (for example `LunaLighthouseDatabase`).
- Historical changelog references to pre-fork commits.

These are phase-2 cleanup tasks and must not block mobile relaunch stability.
