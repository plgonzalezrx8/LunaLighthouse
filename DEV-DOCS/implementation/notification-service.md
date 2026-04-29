# Notification Service

## Purpose

`luna_lighthouse-notification-service/` is a TypeScript Express service for hosted webhook notifications. It is present in the repo but phase-1 app access is deferred by `LunaFeatureFlags.cloudIntegrationsEnabled = false` in the Flutter client.

## Runtime Flow

`src/server/server.ts` registers JSON parsing, `/health`, a docs redirect, and the `/v1` module router.

`src/modules/index.ts` attaches shared middleware and enables controllers for Custom, Lidarr, Overseerr, Radarr, Sonarr, and Tautulli.

Shared middleware in `src/server/middleware.ts` extracts notification options, profile information, device tokens, user device tokens, and validates Firebase user IDs.

## Dependencies

The service uses:

- Firebase Admin for Auth, Firestore, and Cloud Messaging in `src/services/firebase/index.ts`.
- Redis through `ioredis` in `src/services/redis/index.ts`.
- TMDB poster lookup and Redis image caching in `src/api/the_movie_db/`.
- Fanart.tv artist/album image lookup in `src/api/fanart_tv/index.ts`.

## Relaunch Boundary

Do not assume hosted notifications are available to app users while the Flutter cloud integration flag is false.

