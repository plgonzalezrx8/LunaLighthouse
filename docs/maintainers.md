# Lunarr Maintainers

This document defines day-to-day ownership for the Lunarr monorepo revival.

## Active Maintainers

| Area | Owner | Backup | Scope |
| --- | --- | --- | --- |
| Mobile app (Flutter/iOS/Android) | @pedrogonzalez | Unassigned | `lunasea/` runtime, releases, signing setup |
| Documentation/runbooks | @pedrogonzalez | Unassigned | `docs/`, `lunasea-docs/`, release notes |
| Notification relay (deferred) | @pedrogonzalez | Unassigned | `lunasea-notification-service/` |
| Cloud functions (deferred) | @pedrogonzalez | Unassigned | `lunasea-cloud-functions/` |

## Maintenance Expectations

- Mobile issues in `stable` are triaged daily during active release windows.
- Security and dependency updates are reviewed weekly.
- Every release PR must include:
  - runbook references,
  - rollback notes,
  - explicit statement about cloud/webhook deferred status.

## Escalation

- Production mobile incident: open a `release` issue and ping the mobile owner.
- Store blocking issue (Apple/Google): prioritize hotfix branch from `main`.
- Deferred backend issue: document as backlog unless it blocks a mobile release.
