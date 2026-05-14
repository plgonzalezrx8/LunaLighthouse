# Deferred Cloud Coming Soon Design

## Goal

Expose the intentionally deferred hosted cloud, webhook, and push-notification surfaces as clear "Coming Soon" UI in Settings without enabling Firebase, Redis, TMDB, Fanart.tv, webhook URL generation, cloud account flows, or notification delivery.

## Current State

- `LunaFeatureFlags.cloudIntegrationsEnabled` is `false`.
- `LunaModule.hasWebhooks`, `webhookDocs`, and `handleWebhook` are inert while that flag is false.
- Settings currently shows Configuration, Profiles, System, and About.
- Local device backup/restore remains active under Settings > System.
- User docs already describe hosted cloud accounts and hosted webhook notifications as temporarily unavailable.

## Product Decision

Use Option B: visible but disabled Coming Soon cards. This is more transparent than hiding the features and safer than exposing inactive setup forms. The first release should communicate that hosted cloud sync and push notification features are planned, while keeping all launch-critical local server control paths usable.

## User Experience

Settings home adds a `Coming Soon` entry between System and About. The page contains disabled `LunaBlock` cards:

- `Cloud Account`: hosted sign-in and account-backed data are planned for a later release.
- `Cloud Sync`: cloud backup/restore is planned; local backup/restore remains available in Settings > System.
- `Hosted Push Notifications`: webhook-based mobile push is planned after Firebase, Redis, and notification relay validation.
- `Notification Relay`: `notify.lunalighthouse.app` is reserved but unavailable for phase-1 builds.

Cards use existing disabled styling, expose no setup actions, and do not navigate to inactive setup flows.

## Architecture

- Add a Settings subroute, `SettingsRoutes.COMING_SOON`, backed by a focused `ComingSoonRoute`.
- Keep the existing cloud/webhook feature flag unchanged.
- Keep the route additive and UI-only: no service clients, Firebase packages, push-permission prompts, or webhook setup calls.
- Add localized English strings to `luna_lighthouse/localization/settings/en.json` and regenerate `assets/localization/en.json`.

## Testing

- Add a focused Flutter widget/route test that proves:
  - Settings registers the Coming Soon route.
  - The Settings home renders the Coming Soon entry.
  - The Coming Soon page renders the disabled feature cards.
  - No "set up" or webhook URL action text appears while the feature flag is off.
- Keep existing cloud/webhook feature-gate tests unchanged.
- Add Maestro smoke coverage for Settings > Coming Soon if local E2E time is reasonable.

## Documentation

Update docs to say phase-1 builds now surface deferred hosted cloud and notification features as disabled Coming Soon cards. Do not update `ROADMAP.md` in this pass.

## Non-Goals

- No Firebase, Redis, TMDB, Fanart.tv, or notification relay setup.
- No feature flag changes.
- No webhook URL generation.
- No push-notification permission prompts.
- No runtime behavior changes outside Settings UI and documentation.
