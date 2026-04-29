# Start Here

## Current State

- Branch model: `development` is the active integration branch; `master` is the protected/release branch.
- Current phase: phase-1 mobile-first relaunch, after the phase-one coverage PRs landed on `development`.
- Active runtime scope: Flutter app for iOS and Android in `luna_lighthouse/`.
- Current automated Flutter coverage: 68 local tests across eight focused test files, plus Maestro Android/iOS launch-smoke flows.
- Deferred runtime scope: cloud account flows and hosted webhook relay, gated off by `LunaFeatureFlags.cloudIntegrationsEnabled = false`.
- Existing docs roles: `DEV-DOCS/` for engineering handoff, `docs/` for maintainer runbooks, `luna_lighthouse-docs/` for end-user docs.

## Immediate Priorities

1. Keep the new `mobile-test` CI gate and `scripts/mobile-build-check` test step green.
2. Keep iOS/Android reliability and release readiness ahead of non-mobile work.
3. Preserve clear user and maintainer messaging that hosted cloud/webhook features are deferred.
4. Expand API/profile coverage only where it reduces release risk, not as generic test-padding.

## Current Blockers And Risks

- The repository now has meaningful local tests and a dedicated `mobile-test` CI gate; keep it required alongside analyze/generation/build checks.
- `scripts/mobile-build-check` now includes `flutter test` before analyze/builds; release-impacting changes should run it locally when the full mobile toolchain is available.
- Cloud/webhook services exist but need phase-2 security, runtime, secrets, and integration validation before reactivation.
- API keys and custom headers are stored through profile data; secret handling needs explicit review before new sync/cloud work.

## Next Reads

- `ARCHITECTURE.md`
- `DEVELOPMENT-STATUS.md`
- `01-task-list.md`
- `features/cloud-webhook-deferral.md`
- `implementation/flutter-generation.md`
