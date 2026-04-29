# Testing And Performance

## Required Local Checks

- `scripts/doctor`
- `scripts/bootstrap`
- `scripts/mobile-build-check`

`scripts/mobile-build-check` runs toolchain validation, Flutter dependency fetch, environment generation, localization generation, build runner, `flutter analyze`, Android debug build, and iOS debug no-codesign build on macOS.

## CI Gates

- `mobile-analyze`
- `mobile-generation-check`
- `mobile-build-android`
- `mobile-build-ios`

These gates should protect release branches and run on active integration paths.

## Current Test Coverage

Flutter coverage now includes seven focused test files:

- `luna_lighthouse/test/api/api_serialization_fixture_test.dart`
- `luna_lighthouse/test/database/profile_serialization_test.dart`
- `luna_lighthouse/test/database/profile_storage_test.dart`
- `luna_lighthouse/test/modules/configuration/module_state_test.dart`
- `luna_lighthouse/test/router/routes_smoke_test.dart`
- `luna_lighthouse/test/system/cloud_webhook_feature_flag_test.dart`
- `luna_lighthouse/test/widgets/ui/scaffold_test.dart`

Covered phase-one risks include route registry drift, cloud/webhook feature-gate behavior, profile JSON serialization, Hive-backed profile selection/storage, module-state host validation, Android scaffold back behavior, and fixture-driven API model serialization for selected Radarr, Sonarr, and Tautulli contracts.

## Backlog Coverage

- Broader generated client/model serialization fixtures beyond the initial API checkpoint.
- Broader module UI tests for launch-critical flows.
- Additional profile migration tests for older Hive payloads.
- Deferred service integration tests before cloud/webhook reactivation.

## Performance Notes

Keep module state caches, image caching, and generated API models deterministic. Do not add startup work before `LunaBIOS` without measuring bootstrap and recovery-mode impact.
