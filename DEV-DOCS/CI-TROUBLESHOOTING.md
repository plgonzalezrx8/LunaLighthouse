# CI Troubleshooting

## Mobile Analyze Fails

- Run `scripts/mobile-build-check` locally.
- If generated files changed, commit the regenerated outputs.
- Check Flutter revision against `luna_lighthouse/toolchain.env`.

## Bootstrap Fails During App NPM Install

`scripts/bootstrap` runs `npm ci --ignore-scripts` inside `luna_lighthouse/` because the app package is nested below the git root. Do not re-enable npm lifecycle hooks in that script unless the app package `prepare` hook is made safe for nested execution.

## Mobile Test Or Coverage Fails

Run from `luna_lighthouse/`:

```bash
flutter test --coverage
../scripts/check-flutter-coverage coverage/lcov.info 2
```

`mobile-test` uploads the `flutter-coverage-lcov` artifact from `luna_lighthouse/coverage/lcov.info`. If the artifact is missing, confirm the test step still uses `flutter test --coverage` and that the coverage file path has not moved. Raise the `2%` threshold only after a measured baseline increase from meaningful launch-focused tests.

## Generation Check Fails

Run from `luna_lighthouse/`:

```bash
dart run environment_config:generate
dart ./scripts/generate_localization.dart
dart run build_runner build --delete-conflicting-outputs
```

Then inspect `git status --porcelain` for generated Dart or localization diffs.

## Self-Hosted Runner Jobs Stay Queued

`mobile-analyze`, `mobile-generation-check`, and `mobile-build-android` require `[self-hosted, lunalighthouse, Linux]`; `mobile-build-ios` requires `[self-hosted, lunalighthouse, macOS]`. If a job remains queued while hosted jobs pass, inspect runner availability before changing workflow logic.

Use:

```bash
gh run view <run-id> --json jobs,status,conclusion,url
gh pr checks <pr-number>
```

The standalone `Self-hosted Runner Test` workflow is scoped to `ci/use-lunalighthouse-runner` and can be dispatched manually when validating runner host/tooling health.

## Android Build Fails

- Confirm Java 17.
- Run `flutter pub get`.
- For release builds, confirm `android/key.jks` and `android/key.properties` exist only in local/CI secret material.

## iOS Build Fails

- Confirm macOS with Xcode 15+.
- Run `bundle install` in `luna_lighthouse/ios`.
- For signed builds, confirm Fastlane Match secrets and keychain configuration.

## Branch Trigger Drift

The active integration branch is `development`; the protected/release branch is `master`. Workflow branch filters should reflect that model, and branch protection should require `mobile-analyze`, `mobile-generation-check`, `mobile-test`, `mobile-build-android`, and `mobile-build-ios`.
