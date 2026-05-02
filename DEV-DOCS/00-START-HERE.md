# Start Here

## Current State

- Planning source: [LunaLighthouse in Linear](https://linear.app/blueforce-innovations/project/lunalighthouse-d6fd89f22aa5) owns active task state, sprint selection, and project sequencing.
- Branch model: `development` is the active integration branch; `master` is the protected/release branch.
- Current phase: phase-1 mobile-first relaunch, closing out release-confidence work after PR #14 landed on `development`.
- Active runtime scope: Flutter app for iOS and Android in `luna_lighthouse/`.
- Current automated Flutter coverage: 139 tests across thirteen focused test files, enforced by the `mobile-test` CI gate and `scripts/mobile-build-check`, plus Maestro Android/iOS launch, Settings About, and Settings Coming Soon smoke flows.
- Current line coverage baseline: `flutter test --coverage` reports 4.96% line coverage (`1844/37201`), with `scripts/check-flutter-coverage` initially enforcing a 2% minimum.
- Deferred runtime scope: cloud account flows and hosted webhook relay, gated off by `LunaFeatureFlags.cloudIntegrationsEnabled = false`.
- Existing docs roles: `DEV-DOCS/` for engineering handoff, `docs/` for maintainer runbooks, `luna_lighthouse-docs/` for end-user docs.

## Immediate Priorities

1. Capture and attach release dry-run evidence for `Build Mobile`; PR #14 provides green `Mobile CI` evidence at `https://github.com/plgonzalezrx8/LunaLighthouse/actions/runs/25192467035`.
2. Verify GitHub branch protection requires `mobile-analyze`, `mobile-generation-check`, `mobile-test`, `mobile-build-android`, and `mobile-build-ios`.
3. Keep `scripts/check-flutter-coverage` threshold ratcheting deliberate and tied to meaningful launch tests.
4. Review API key/custom-header storage before adding new sync, account, or cloud work.
5. Keep hosted cloud/webhook messaging clearly deferred until the phase-2 security/runtime checklist exists.

## Current Blockers And Risks

- The repository now has meaningful tests and dedicated CI gates for analyze, generation, Flutter coverage tests, Android build, and iOS build; branch protection still needs live verification in GitHub settings.
- `scripts/mobile-build-check` includes `flutter test` before analyze/builds; release-impacting changes should run it locally when the full mobile toolchain is available.
- CI now publishes the `flutter-coverage-lcov` artifact and enforces the measured 2% coverage floor.
- PR #14 added regression coverage for self-hosted runner workflow routing.
- Cloud/webhook services exist but need phase-2 security, runtime, secrets, and integration validation before reactivation.
- API keys and custom headers are stored through profile data; secret handling needs explicit review before new sync/cloud work.

## Next Reads

- `ARCHITECTURE.md`
- `DEVELOPMENT-STATUS.md`
- `01-task-list.md`
- `features/cloud-webhook-deferral.md`
- `implementation/flutter-generation.md`
- `../docs/plans/2026-04-29-next-sprint-release-confidence.md`
