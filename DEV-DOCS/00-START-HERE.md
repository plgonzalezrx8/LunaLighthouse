# Start Here

## Current State

- Branch model: `development` is the active integration branch; `master` is the protected/release branch.
- Current phase: phase-1 mobile-first relaunch, after the phase-one coverage PRs landed on `development`.
- Active runtime scope: Flutter app for iOS and Android in `luna_lighthouse/`.
- Current automated Flutter coverage: 68 local tests across eight focused test files, plus Maestro Android/iOS launch-smoke flows.
- Deferred runtime scope: cloud account flows and hosted webhook relay, gated off by `LunaFeatureFlags.cloudIntegrationsEnabled = false`.
- Existing docs roles: `DEV-DOCS/` for engineering handoff, `docs/` for maintainer runbooks, `luna_lighthouse-docs/` for end-user docs.

## Immediate Priorities

1. Add a dedicated `flutter test` CI gate and align `scripts/mobile-build-check` with that local test requirement.
2. Keep iOS/Android reliability and release readiness ahead of non-mobile work.
3. Preserve clear user and maintainer messaging that hosted cloud/webhook features are deferred.
4. Expand API/profile coverage only where it reduces release risk, not as generic test-padding.

## Current Blockers And Risks

- The repository now has meaningful local tests, but `.github/workflows/mobile_ci.yml` does not run `flutter test` as a dedicated CI gate yet.
- `scripts/mobile-build-check` validates generation, analyze, and platform builds, but currently omits the Flutter test suite.
- Cloud/webhook services exist but need phase-2 security, runtime, secrets, and integration validation before reactivation.
- API keys and custom headers are stored through profile data; secret handling needs explicit review before new sync/cloud work.

## Next Reads

- `ARCHITECTURE.md`
- `DEVELOPMENT-STATUS.md`
- `01-task-list.md`
- `features/cloud-webhook-deferral.md`
- `implementation/flutter-generation.md`
