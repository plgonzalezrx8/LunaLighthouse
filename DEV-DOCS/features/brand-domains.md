# Brand Domains

## Canonical Values

The repo source of truth is `docs/rebrand-rename-matrix.md`. Current canonical public values are:

- Product name: `LunaLighthouse`
- iOS bundle ID: `app.lunalighthouse.lunalighthouse`
- Android application ID: `app.lunalighthouse.lunalighthouse`
- Website: `https://www.lunalighthouse.app`
- Docs: `https://docs.lunalighthouse.app`
- Build bucket: `https://builds.lunalighthouse.app`
- Notification host: `https://notify.lunalighthouse.app`
- Backup bucket: `backup.lunalighthouse.app`

## Code Anchors

Android uses `namespace` and `applicationId` `app.lunalighthouse.lunalighthouse` in `luna_lighthouse/android/app/build.gradle`.

iOS uses `PRODUCT_BUNDLE_IDENTIFIER = app.lunalighthouse.lunalighthouse` in `luna_lighthouse/ios/Runner.xcodeproj/project.pbxproj`.

The cloud backup bucket is hard-coded as `backup.lunalighthouse.app` in `luna_lighthouse-cloud-functions/functions/src/services/storage/index.ts`.

## Deferred Internal Names

Internal names such as `luna_lighthouse` package paths, localization key prefixes, and `LunaLighthouseDatabase` remain acceptable phase-1 internals when they do not affect user-facing branding.
