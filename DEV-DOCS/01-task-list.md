# Task List

## Active

- [ ] Add a dedicated `flutter test` CI gate, then require it with the other mobile checks.
- [ ] Update `scripts/mobile-build-check` so release-impacting local validation includes `flutter test` before analyze/builds.
- [ ] Add older profile migration payload coverage.
- [ ] Expand generated API model/client fixtures beyond the current Radarr, Sonarr, and Tautulli checkpoint only for launch-touched models.
- [ ] Keep `development` and `master` branch policy reflected in docs, CI, and release runbooks.

## Backlog

- [ ] Review API key/custom-header storage and document an encryption or platform-secure-storage direction.
- [ ] Build phase-2 hosted webhook reactivation checklist: Firebase SDK upgrades, Node 20 deployability, webhook auth, Redis provisioning, domain validation, secret restoration, and E2E webhook tests.
- [ ] Audit notification-service request logging before reactivation.
- [ ] Review Redis failure behavior before treating the notification service as production-ready.

## Recently Completed

- [x] Merged PR #5 into `development`: phase-one coverage plan, route/cloud/profile/API/module/scaffold tests, and Maestro Android/iOS smoke flows.
- [x] Merged PR #7 into `development`: conflict-resolved generated test coverage from PR #6, excluding brittle hard-coded registry-count assertions.
- [x] Closed PR #6 as superseded by PR #7.
- [x] Added module enablement/provider registry tests and expanded scaffold UI behavior tests.
- [x] Added Maestro Android and iOS launch-smoke flows under `luna_lighthouse/.maestro/`.
- [x] Added fixture-driven API serialization tests for Radarr, Sonarr, and Tautulli models.
- [x] Added phase-one route registry smoke coverage on `codex/phase-one-test-coverage`.
- [x] Added cloud/webhook feature-gate tests proving deferred services stay inert.
- [x] Added profile serialization and Hive-backed storage tests for credentials/custom headers.
- [x] Synced `development` to `master` at commit `8bd5b861`.
- [x] Bootstrapped DEV-DOCS as the engineering handoff layer.
