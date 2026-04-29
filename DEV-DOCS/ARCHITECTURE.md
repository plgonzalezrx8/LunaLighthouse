# Architecture

## Runtime Boundary

LunaLighthouse is currently a mobile-first Flutter relaunch. The active runtime is the iOS/Android app in `luna_lighthouse/`. Hosted cloud account and webhook features are present in code and services but deferred for phase 2.

## Mobile App

- Entry point: `luna_lighthouse/lib/main.dart`.
- Bootstrap initializes Hive, logging, theme, window manager, network, image cache, GoRouter, and memory cache.
- Recovery mode is used when bootstrap fails.
- Routing uses GoRouter through `luna_lighthouse/lib/router/`.
- State uses Provider and `ChangeNotifier`, with module providers registered in `luna_lighthouse/lib/system/state.dart`.
- Local storage uses Hive boxes, typed database tables, and profile models under `luna_lighthouse/lib/database/`.

## Modules And APIs

Supported module surfaces include dashboard, settings, Lidarr, Radarr, Sonarr, SABnzbd, NZBGet, Search/indexers, Tautulli, external modules, and Wake-on-LAN. API clients live under `luna_lighthouse/lib/api/` and use Dio/Retrofit plus generated JSON model code.

## Deferred Services

- `luna_lighthouse-notification-service/`: Express notification relay backed by Firebase Admin, Firestore, Firebase Messaging, Redis, TMDB, and Fanart.tv.
- `luna_lighthouse-cloud-functions/`: Firebase functions for account deletion cleanup in Firestore and Cloud Storage.
- App webhook URLs still target `https://notify.lunalighthouse.app`, but exposure is gated off by `LunaFeatureFlags.cloudIntegrationsEnabled = false`.

## Documentation Boundary

- `DEV-DOCS/`: engineering handoff and implementation contracts.
- `docs/`: maintainer runbooks, release checklists, and operational governance.
- `luna_lighthouse-docs/`: end-user documentation content.
