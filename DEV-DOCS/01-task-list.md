# Task List

## Active

- [ ] Keep `development` and `master` branch policy reflected in docs, CI, and release runbooks.
- [ ] Maintain phase-1 launch docs so cloud/webhook and non-mobile surfaces are not described as release blockers.
- [ ] Use `scripts/mobile-build-check` before release-impacting Flutter changes.

## Backlog

- [ ] Add route smoke tests for the GoRouter surface.
- [ ] Add API serialization tests for generated model/client contracts.
- [ ] Add profile migration/storage tests around Hive-backed configuration.
- [ ] Review API key/custom-header storage and document an encryption or platform-secure-storage direction.
- [ ] Build phase-2 hosted webhook reactivation checklist: Firebase SDK upgrades, Node 20 deployability, webhook auth, Redis provisioning, domain validation, secret restoration, and E2E webhook tests.
- [ ] Audit notification-service request logging before reactivation.
- [ ] Review Redis failure behavior before treating the notification service as production-ready.

## Recently Completed

- [x] Synced `development` to `master` at commit `8bd5b861`.
- [x] Bootstrapped DEV-DOCS as the engineering handoff layer.
