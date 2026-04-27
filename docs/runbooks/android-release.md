# Android Release Runbook

## Preconditions

- Google Play Console app exists for `app.lunalighthouse.lunalighthouse`.
- Signing material (`key.jks`, `key.properties`) is available and valid.
- `scripts/doctor` and `scripts/mobile-build-check` pass.

## Build and Sign

1. Set Android signing files/secrets.
2. Run `cd luna_lighthouse/android && bundle install`.
3. Run `cd luna_lighthouse/android && bundle exec fastlane build_aab build_number:<N>`.
4. Optional APK validation: `bundle exec fastlane build_apk build_number:<N>`.

## Upload and Track Progression

1. Upload AAB to internal testing track first.
2. Validate install/update path on real devices.
3. Promote to closed beta after blocker-free window.
4. Promote to production after defect budget is clear.

## Go/No-Go Checks

- Package name and visible app name are LunaLighthouse.
- Cloud/webhook deferred messaging is present where relevant.
- Crash-free and ANR thresholds meet team target.

## Rollback

- Halt rollout percentage immediately.
- Promote last known-good release if required.
- Log root cause and follow incident runbook.
