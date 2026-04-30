# Cloud/Webhook Phase-1 Status

## Decision

Cloud account and hosted webhook features are intentionally phase-2/deferred for the LunaLighthouse mobile relaunch.

## Implementation Contract

- Feature gate defaults to disabled in `luna_lighthouse/lib/system/feature_flags.dart`.
- Settings/routes must not expose broken cloud/webhook entry points.
- Docs and release notes must explicitly state temporary unavailability.

## User Messaging

- Provide clear "temporarily unavailable" wording.
- Do not imply continuity for legacy cloud accounts or hosted webhook subscriptions.
- Keep local backup/restore available and documented.

## Re-enable Prerequisites (Phase 2)

- Runtime modernization complete for relay/functions stack.
- Secrets and domain ownership confirmed.
- End-to-end integration test pass.
- Security review completed.
