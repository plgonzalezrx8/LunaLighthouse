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
2. Upload build via fastlane lane or App Store Connect transport.
3. Assign internal testers, then external testers after smoke pass.

## Go/No-Go Checks

- App installs and launches on supported iOS versions.
- Branding, iconography, and support links are LunaLighthouse-only.
- No critical crashes in first validation cohort.

## Rollback

- Keep previous approved TestFlight build available.
- If severe regression occurs, expire current build and promote previous build.
- Open incident using `docs/runbooks/incident-rollback.md`.
