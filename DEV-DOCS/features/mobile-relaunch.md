# Mobile Relaunch

## Scope

The relaunch scope is the Flutter client in `luna_lighthouse/`, with iOS and Android treated as the primary release targets. The app entry point is `luna_lighthouse/lib/main.dart`: bootstrap initializes Hive storage, logging, theme, supported desktop/window/network/cache services, GoRouter, and memory store before rendering `LunaBIOS`.

## Current Architecture

- Routing is centralized through `LunaRouter` in `luna_lighthouse/lib/router/router.dart` and route definitions in `luna_lighthouse/lib/router/routes.dart`.
- App-wide module state is registered with `Provider` in `luna_lighthouse/lib/system/state.dart`.
- Persistent app data is stored with Hive through `LunaDatabase` and `LunaBox` in `luna_lighthouse/lib/database/`.
- Cloud account and hosted webhook behavior is intentionally deferred by `LunaFeatureFlags.cloudIntegrationsEnabled = false` in `luna_lighthouse/lib/system/feature_flags.dart`.

## Relaunch Boundary

The phase-1 mobile relaunch should preserve local module connectivity, local configuration, and local backup/restore behavior. Hosted cloud, account, and webhook flows should remain hidden or inert until the feature flag is enabled in a later phase.
