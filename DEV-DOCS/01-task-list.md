# Task List

## Active

- [ ] Continue the phase-one test coverage plan in `docs/plans/2026-04-28-phase-one-test-coverage.md`.
- [ ] Expand generated API model/client fixtures beyond the initial Radarr, Sonarr, and Tautulli coverage.
- [ ] Add older profile migration payload coverage.
- [ ] Keep `development` and `master` branch policy reflected in docs, CI, and release runbooks.
- [ ] Use `scripts/mobile-build-check` before release-impacting Flutter changes.

## Backlog

- [ ] Review API key/custom-header storage and document an encryption or platform-secure-storage direction.
- [ ] Build phase-2 hosted webhook reactivation checklist: Firebase SDK upgrades, Node 20 deployability, webhook auth, Redis provisioning, domain validation, secret restoration, and E2E webhook tests.
- [ ] Audit notification-service request logging before reactivation.
- [ ] Review Redis failure behavior before treating the notification service as production-ready.

## Recently Completed

- [x] Added module enablement/provider registry tests and expanded scaffold UI behavior tests.
- [x] Added Maestro Android and iOS launch-smoke flows under `luna_lighthouse/.maestro/`.
- [x] Added fixture-driven API serialization tests for Radarr, Sonarr, and Tautulli models.
- [x] Added phase-one route registry smoke coverage on `codex/phase-one-test-coverage`.
- [x] Added cloud/webhook feature-gate tests proving deferred services stay inert.
- [x] Added profile serialization and Hive-backed storage tests for credentials/custom headers.
- [x] Synced `development` to `master` at commit `8bd5b861`.
- [x] Bootstrapped DEV-DOCS as the engineering handoff layer.
