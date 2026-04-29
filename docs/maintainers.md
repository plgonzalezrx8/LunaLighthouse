# LunaLighthouse Maintainers

This document defines day-to-day ownership for the LunaLighthouse monorepo revival.

## Active Maintainers

| Area | Owner | Backup | Scope |
| --- | --- | --- | --- |
| Mobile app (Flutter/iOS/Android) | @plgonzalezrx8 | Unassigned | `luna_lighthouse/` runtime, releases, signing setup |
| Documentation/runbooks | @plgonzalezrx8 | Unassigned | `docs/`, `luna_lighthouse-docs/`, release notes |
| Notification relay (deferred) | @plgonzalezrx8 | Unassigned | `luna_lighthouse-notification-service/` |
| Cloud functions (deferred) | @plgonzalezrx8 | Unassigned | `luna_lighthouse-cloud-functions/` |

## Maintenance Expectations

- Mobile issues in `stable` are triaged daily during active release windows.
- Security and dependency updates are reviewed weekly.
- Every release PR must include:
  - runbook references,
  - rollback notes,
  - explicit statement about cloud/webhook deferred status.

## Escalation

- Production mobile incident: open a `release` issue and ping the mobile owner.
- Store blocking issue (Apple/Google): prioritize hotfix branch from `master`, then merge the fix back into `development`.
- Deferred backend issue: document as backlog unless it blocks a mobile release.
