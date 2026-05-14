# Cloud and Webhook Deferral

## Current State

Hosted cloud integrations are disabled at compile time:

`luna_lighthouse/lib/system/feature_flags.dart` sets `LunaFeatureFlags.cloudIntegrationsEnabled = false`.

That flag gates webhook behavior in `luna_lighthouse/lib/modules.dart`:

- `hasWebhooks` returns `false` before module-specific webhook support is evaluated.
- `webhookDocs` returns `null`.
- `handleWebhook` returns without dispatching module handlers.

## Deferred Services

The repository still contains the deferred backend surfaces:

- `luna_lighthouse-notification-service/` implements hosted webhook notification routing.
- `luna_lighthouse-cloud-functions/` implements Firebase account cleanup functions.
- Public notification docs under `luna_lighthouse-docs/luna_lighthouse/notifications/` mark hosted relay notifications as temporarily unavailable.

## In-App Treatment

Phase-one builds include a Settings > Coming Soon page so users can see that hosted cloud and notification features are planned without being offered inactive setup flows. The page uses disabled cards for Cloud Account, Cloud Sync, Hosted Push Notifications, and Notification Relay.

Do not add setup buttons, webhook URL display, push-permission prompts, Firebase client initialization, Redis-backed relay calls, or cloud-account sign-in until the phase-2 reactivation work changes this contract.

## Relaunch Rule

Do not treat cloud account or hosted webhook behavior as part of phase-1 mobile readiness while the feature flag is false. Keep local module control and local backup/restore behavior independent from the deferred hosted services.
