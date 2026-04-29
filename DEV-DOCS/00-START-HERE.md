# Start Here

## Current State

- Branch model: `development` is the active integration branch; `master` is the protected/release branch.
- Current phase: phase-1 mobile-first relaunch.
- Active runtime scope: Flutter app for iOS and Android in `luna_lighthouse/`.
- Deferred runtime scope: cloud account flows and hosted webhook relay, gated off by `LunaFeatureFlags.cloudIntegrationsEnabled = false`.
- Existing docs roles: `DEV-DOCS/` for engineering handoff, `docs/` for maintainer runbooks, `luna_lighthouse-docs/` for end-user docs.

## Immediate Priorities

1. Keep iOS/Android reliability and release readiness ahead of non-mobile work.
2. Keep generated Flutter artifacts deterministic through `scripts/mobile-build-check`.
3. Preserve clear user and maintainer messaging that hosted cloud/webhook features are deferred.
4. Expand test coverage around routes, profile storage, API serialization, and module state as changes touch those areas.

## Current Blockers And Risks

- Test coverage is narrow for the size of the app.
- Cloud/webhook services exist but need phase-2 security, runtime, secrets, and integration validation before reactivation.
- CI branch policy needs to stay aligned with `development` integration and `master` release flow.
- API keys and custom headers are stored through profile data; secret handling needs explicit review before new sync/cloud work.

## Next Reads

- `ARCHITECTURE.md`
- `DEVELOPMENT-STATUS.md`
- `01-task-list.md`
- `features/cloud-webhook-deferral.md`
- `implementation/flutter-generation.md`
