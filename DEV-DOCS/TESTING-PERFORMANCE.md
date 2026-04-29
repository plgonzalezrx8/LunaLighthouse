# Testing And Performance

## Required Local Checks

- `scripts/doctor`
- `scripts/bootstrap`
- `flutter test` from `luna_lighthouse/`
- `scripts/mobile-build-check`

`scripts/mobile-build-check` runs toolchain validation, Flutter dependency fetch, environment generation, localization generation, build runner, `flutter test`, `flutter analyze`, Android debug build, and iOS debug no-codesign build on macOS.

## CI Gates

- `mobile-analyze`
- `mobile-generation-check`
- `mobile-test`
- `mobile-build-android`
- `mobile-build-ios`

These gates protect active integration paths. `mobile-test` runs `flutter test` so the current Flutter test suite is enforced in CI instead of only locally.

## Current Test Coverage

Flutter coverage now passes 68 tests across eight focused test files plus Maestro launch-smoke flows:

- `luna_lighthouse/test/api/api_serialization_fixture_test.dart`
- `luna_lighthouse/test/database/profile_serialization_test.dart`
- `luna_lighthouse/test/database/profile_storage_test.dart`
- `luna_lighthouse/test/modules/configuration/module_enablement_test.dart`
- `luna_lighthouse/test/modules/configuration/module_state_test.dart`
- `luna_lighthouse/test/router/routes_smoke_test.dart`
- `luna_lighthouse/test/system/cloud_webhook_feature_flag_test.dart`
- `luna_lighthouse/test/widgets/ui/scaffold_test.dart`

Maestro launch-smoke coverage lives under:

- `luna_lighthouse/.maestro/config.yaml`
- `luna_lighthouse/.maestro/flows/android/launch_smoke.yaml`
- `luna_lighthouse/.maestro/flows/ios/launch_smoke.yaml`

Covered phase-one risks include route registry drift, cloud/webhook feature-gate behavior, profile JSON serialization, Hive-backed profile selection/storage, module-state host validation, module enablement/provider registry wiring, Android and non-Android scaffold behavior, focus/profile-change scaffold hooks, Android/iOS Maestro launch smoke, and fixture-driven API model serialization for selected Radarr, Sonarr, and Tautulli contracts.

## Backlog Coverage

- Add older profile migration tests for legacy Hive payloads.
- Expand generated client/model serialization fixtures beyond the initial API checkpoint only for launch-touched models.
- Add deferred service integration tests before cloud/webhook reactivation.

## Performance Notes

Keep module state caches, image caching, and generated API models deterministic. Do not add startup work before `LunaBIOS` without measuring bootstrap and recovery-mode impact.
