# iOS Release Runbook

## Preconditions

- Apple Developer account access is available.
- App Store Connect app exists for `app.lunalighthouse.lunalighthouse`.
- Match repository and `MATCH_GIT_URL` are configured.
- `scripts/doctor` and `scripts/mobile-build-check` pass on macOS.

## Build and Sign

1. Set required env vars (`APPLE_ID`, team IDs, match credentials).
2. Run `cd luna_lighthouse/ios && bundle install`.
3. Run `cd luna_lighthouse/ios && bundle exec fastlane build_appstore build_number:<N>`.
4. Verify output IPA in `luna_lighthouse/output/` is named with LunaLighthouse convention.

## TestFlight Upload

1. Confirm release notes mention:
   - LunaLighthouse relaunch identity,
   - cloud/webhook temporarily unavailable,
   - fresh-start migration expectation.
2. Run final iPad 13-inch visual QA:
   - `scripts/ipad-visual-qa`
   - Review raw captures in `app-store-assets/screenshots/ipad-visual-qa/raw/`.
   - Review exported App Store Connect screenshots in `app-store-assets/screenshots/appstore-ipad-13-2048x2732/`.
3. Upload build via fastlane lane or App Store Connect transport.
4. Assign internal testers, then external testers after smoke pass.

## App Store Screenshots

- Apple currently requires 13-inch iPad screenshots when the app runs on iPad. The helper exports portrait PNGs at `2048x2732`, one of the accepted 13-inch sizes: `scripts/export-ipad-appstore-screenshots`.
- To export from an alternate capture directory:

```bash
scripts/export-ipad-appstore-screenshots \
  --input-dir app-store-assets/screenshots/ipad-visual-qa/raw \
  --output-dir app-store-assets/screenshots/appstore-ipad-13-2048x2732
```

- The script scales and pads source PNGs; it does not modify the source captures.

## Go/No-Go Checks

- App installs and launches on supported iOS versions.
- Branding, iconography, and support links are LunaLighthouse-only.
- iPad 13-inch simulator visual QA has current screenshots attached to release evidence.
- No critical crashes in first validation cohort.

## Rollback

- Keep previous approved TestFlight build available.
- If severe regression occurs, expire current build and promote previous build.
- Open incident using `docs/runbooks/incident-rollback.md`.
