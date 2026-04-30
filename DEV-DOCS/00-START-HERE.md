# Start Here

## Current State

- Branch model: `development` is the active integration branch; `master` is the protected/release branch.
- Current phase: phase-1 mobile-first relaunch, entering the release-confidence sprint after the enforced mobile test gate landed on `development`.
- Active runtime scope: Flutter app for iOS and Android in `luna_lighthouse/`.
- Current automated Flutter coverage: 130 tests across eleven focused test files, enforced by the `mobile-test` CI gate and `scripts/mobile-build-check`, plus Maestro Android/iOS launch-smoke flows.
- Current line coverage baseline: `flutter test --coverage` reports 3.71% line coverage (`1373/37026`), with `scripts/check-flutter-coverage` initially enforcing a 2% minimum.
- Deferred runtime scope: cloud account flows and hosted webhook relay, gated off by `LunaFeatureFlags.cloudIntegrationsEnabled = false`.
- Existing docs roles: `DEV-DOCS/` for engineering handoff, `docs/` for maintainer runbooks, `luna_lighthouse-docs/` for end-user docs.

## Immediate Priorities

1. Capture release dry-run evidence for `Mobile CI` and `Build Mobile` before release handoff.
2. Keep `scripts/check-flutter-coverage` threshold ratcheting deliberate and tied to meaningful launch tests.
3. Run `scripts/mobile-build-check` before release-impacting merges.
4. Keep hosted cloud/webhook messaging clearly deferred until the phase-2 security/runtime checklist exists.

## Current Blockers And Risks

- The repository now has meaningful tests and a dedicated `mobile-test` CI gate; the branch-protection checklist requires it alongside analyze/generation/build checks.
- `scripts/mobile-build-check` includes `flutter test` before analyze/builds; release-impacting changes should run it locally when the full mobile toolchain is available.
- CI now publishes the `flutter-coverage-lcov` artifact and enforces the measured 2% coverage floor.
- Cloud/webhook services exist but need phase-2 security, runtime, secrets, and integration validation before reactivation.
- API keys and custom headers are stored through profile data; secret handling needs explicit review before new sync/cloud work.

## Next Reads

- `ARCHITECTURE.md`
- `DEVELOPMENT-STATUS.md`
- `01-task-list.md`
- `features/cloud-webhook-deferral.md`
- `implementation/flutter-generation.md`
- `../docs/plans/2026-04-29-next-sprint-release-confidence.md`
