# Mobile Baseline Checklist

Use this checklist before opening relaunch and release PRs.

## Environment

- [ ] `scripts/doctor` passes on the build host.
- [ ] `scripts/bootstrap` completes without dependency errors.
- [ ] Flutter toolchain matches `luna_lighthouse/toolchain.env`.

## Generation, Tests, and Analysis

- [ ] `dart run environment_config:generate` succeeds.
- [ ] `dart ./scripts/generate_localization.dart` succeeds.
- [ ] `dart run build_runner build --delete-conflicting-outputs` succeeds.
- [ ] `flutter test` succeeds.
- [ ] `flutter test --coverage` succeeds and writes `luna_lighthouse/coverage/lcov.info`.
- [ ] `scripts/check-flutter-coverage luna_lighthouse/coverage/lcov.info 2` succeeds.
- [ ] `flutter analyze` succeeds.
- [ ] Maestro Android launch-smoke flow passes on a debug Android build.
- [ ] Maestro iOS launch-smoke flow passes on an iOS simulator debug build.

## Build Viability

- [ ] `flutter build apk --debug` succeeds.
- [ ] `flutter build apk --release` succeeds (signing configured).
- [ ] `flutter build ios --debug --no-codesign` succeeds on macOS.
- [ ] `bundle exec fastlane build_aab` succeeds with signing.
- [ ] `bundle exec fastlane build_appstore` succeeds with signing.

## Relaunch Scope Compliance

- [ ] User-visible `LunaLighthouse` strings match the approved product name and current brand guidance.
- [ ] No legacy placeholder domains or unapproved production URLs in runtime paths.
- [ ] Cloud/webhook flows are disabled or marked unavailable.
- [ ] Local backup/restore works using LunaLighthouse backup extension.

## CI Evidence To Capture

- [ ] `mobile-analyze` passed.
- [ ] `mobile-generation-check` passed.
- [ ] `mobile-test` passed and uploaded `flutter-coverage-lcov`.
- [ ] `mobile-build-android` passed.
- [ ] `mobile-build-ios` passed.
- [ ] Manual release workflow dry run captured `Build Android` and `Build iOS` job results from `.github/workflows/build_mobile.yml`.

## Signing Secret Names

These names must match `.github/workflows/build_mobile.yml` exactly; do not paste secret values into docs or PRs.

- Android: `KEY_JKS`, `KEY_PROPERTIES`
- iOS: `MATCH_SSH_PRIVATE_KEY`, `APPLE_ID`, `APPLE_ITC_TEAM_ID`, `APPLE_TEAM_ID`, `IOS_CODESIGNING_IDENTITY`, `MATCH_GIT_URL`, `MATCH_KEYCHAIN_NAME`, `MATCH_KEYCHAIN_PASSWORD`, `MATCH_PASSWORD`
