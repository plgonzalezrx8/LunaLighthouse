# Task List

## Active

- [ ] Execute `docs/plans/2026-04-29-next-sprint-release-confidence.md` checkpoint-by-checkpoint.
- [ ] Add older profile/config import coverage for legacy or partial payloads.
- [ ] Add Flutter coverage artifact generation and a measured baseline threshold.
- [ ] Expand generated API model/client fixtures only for launch-touched models.
- [ ] Add release dry-run evidence requirements to launch runbooks.

## Backlog

- [ ] Review API key/custom-header storage and document an encryption or platform-secure-storage direction.
- [ ] Build phase-2 hosted webhook reactivation checklist: Firebase SDK upgrades, Node 20 deployability, webhook auth, Redis provisioning, domain validation, secret restoration, and E2E webhook tests.
- [ ] Audit notification-service request logging before reactivation.
- [ ] Review Redis failure behavior before treating the notification service as production-ready.

## Recently Completed

- [x] Added `mobile-test` to the branch-protection checklist required checks.
- [x] Added `mobile-test` CI coverage for `flutter test` and wired `flutter test` into `scripts/mobile-build-check` before analyze/builds.
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
