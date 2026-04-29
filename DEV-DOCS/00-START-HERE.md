# Start Here

## Current State

- Branch model: `development` is the active integration branch; `master` is the protected/release branch.
- Current phase: phase-1 mobile-first relaunch, entering the release-confidence sprint after the enforced mobile test gate landed on `development`.
- Active runtime scope: Flutter app for iOS and Android in `luna_lighthouse/`.
- Current automated Flutter coverage: 68 tests across eight focused test files, enforced by the `mobile-test` CI gate and `scripts/mobile-build-check`, plus Maestro Android/iOS launch-smoke flows.
- Deferred runtime scope: cloud account flows and hosted webhook relay, gated off by `LunaFeatureFlags.cloudIntegrationsEnabled = false`.
- Existing docs roles: `DEV-DOCS/` for engineering handoff, `docs/` for maintainer runbooks, `luna_lighthouse-docs/` for end-user docs.

## Immediate Priorities

1. Execute `docs/plans/2026-04-29-next-sprint-release-confidence.md` in small PRs from `development`.
2. Add legacy profile/config import coverage before broader feature work.
3. Add measurable Flutter coverage artifacts and a baseline threshold before claiming complete coverage.
4. Expand launch-touched API/profile coverage only where it reduces release risk, not as generic test-padding.
5. Keep hosted cloud/webhook messaging clearly deferred until the phase-2 security/runtime checklist exists.

## Current Blockers And Risks

- The repository now has meaningful tests and a dedicated `mobile-test` CI gate; the branch-protection checklist now requires it alongside analyze/generation/build checks.
- `scripts/mobile-build-check` includes `flutter test` before analyze/builds; release-impacting changes should run it locally when the full mobile toolchain is available.
- Coverage is enforced by test execution, but LCOV artifact/threshold reporting has not been added yet.
- Cloud/webhook services exist but need phase-2 security, runtime, secrets, and integration validation before reactivation.
- API keys and custom headers are stored through profile data; secret handling needs explicit review before new sync/cloud work.

## Next Reads

- `ARCHITECTURE.md`
- `DEVELOPMENT-STATUS.md`
- `01-task-list.md`
- `features/cloud-webhook-deferral.md`
- `implementation/flutter-generation.md`
- `../docs/plans/2026-04-29-next-sprint-release-confidence.md`
