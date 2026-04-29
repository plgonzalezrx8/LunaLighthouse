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

Only narrow Flutter tests are present:

- `luna_lighthouse/test/modules/configuration/module_state_test.dart`
- `luna_lighthouse/test/widgets/ui/scaffold_test.dart`

## Backlog Coverage

- Route smoke tests for GoRouter surfaces.
- API serialization and command tests for generated clients.
- Profile storage and migration tests for Hive models.
- Module UI tests for launch-critical flows.
- Deferred service integration tests before cloud/webhook reactivation.

## Performance Notes

Keep module state caches, image caching, and generated API models deterministic. Do not add startup work before `LunaBIOS` without measuring bootstrap and recovery-mode impact.
