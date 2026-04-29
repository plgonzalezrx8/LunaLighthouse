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
