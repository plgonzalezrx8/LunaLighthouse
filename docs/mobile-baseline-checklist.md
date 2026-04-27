# Mobile Baseline Checklist

Use this checklist before opening relaunch and release PRs.

## Environment

- [ ] `scripts/doctor` passes on the build host.
- [ ] `scripts/bootstrap` completes without dependency errors.
- [ ] Flutter toolchain matches `luna_lighthouse/toolchain.env`.

## Generation and Analysis

- [ ] `dart run environment_config:generate` succeeds.
- [ ] `dart ./scripts/generate_localization.dart` succeeds.
- [ ] `dart run build_runner build --delete-conflicting-outputs` succeeds.
- [ ] `flutter analyze` succeeds.

## Build Viability

- [ ] `flutter build apk --debug` succeeds.
- [ ] `flutter build apk --release` succeeds (signing configured).
- [ ] `flutter build ios --debug --no-codesign` succeeds on macOS.
- [ ] `bundle exec fastlane build_aab` succeeds with signing.
- [ ] `bundle exec fastlane build_appstore` succeeds with signing.

## Relaunch Scope Compliance

- [ ] No user-visible `LunaLighthouse` strings in core mobile flows.
- [ ] No `*.luna_lighthouse.app` production URLs in runtime paths.
- [ ] Cloud/webhook flows are disabled or marked unavailable.
- [ ] Local backup/restore works using LunaLighthouse backup extension.
