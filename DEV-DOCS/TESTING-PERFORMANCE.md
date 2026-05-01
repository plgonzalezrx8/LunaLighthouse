# Testing And Performance

## Required Local Checks

- `scripts/doctor`
- `scripts/bootstrap`
- `flutter test` from `luna_lighthouse/`
- `flutter test --coverage` from `luna_lighthouse/`
- `scripts/check-flutter-coverage luna_lighthouse/coverage/lcov.info 2`
- `scripts/mobile-build-check`

`scripts/mobile-build-check` runs toolchain validation, Flutter dependency fetch, environment generation, localization generation, build runner, `flutter test`, `flutter analyze`, Android debug build, and iOS debug no-codesign build on macOS.

## CI Gates

- `mobile-analyze`
- `mobile-generation-check`
- `mobile-test`
- `mobile-build-android`
- `mobile-build-ios`

These gates protect active integration paths. `mobile-test` runs `flutter test --coverage`, enforces `scripts/check-flutter-coverage coverage/lcov.info 2`, and uploads the `flutter-coverage-lcov` artifact. The zero-to-launch branch-protection checklist requires `mobile-test` with the other mobile checks.

PR #14's post-merge `Mobile CI` run on `development` passed all five mobile gates: `https://github.com/plgonzalezrx8/LunaLighthouse/actions/runs/25192467035`. Treat that as current CI evidence for analyze, generation, coverage test, Android debug build, and iOS debug no-codesign build until the next release-impacting change lands.

## Current Test Coverage

Flutter coverage now passes 137 tests across twelve focused test files plus Maestro launch and Settings About smoke flows. The measured LCOV baseline is 4.74% line coverage (`1761/37142`); the initial enforced threshold is 2%.

- `luna_lighthouse/test/api/api_serialization_fixture_test.dart`
- `luna_lighthouse/test/ci/self_hosted_runner_workflow_test.dart`
- `luna_lighthouse/test/database/box_clear_test.dart`
- `luna_lighthouse/test/database/profile_import_test.dart`
- `luna_lighthouse/test/database/profile_serialization_test.dart`
- `luna_lighthouse/test/database/profile_storage_test.dart`
- `luna_lighthouse/test/modules/configuration/module_enablement_test.dart`
- `luna_lighthouse/test/modules/configuration/module_state_test.dart`
- `luna_lighthouse/test/modules/settings/about_route_test.dart`
- `luna_lighthouse/test/router/routes_smoke_test.dart`
- `luna_lighthouse/test/system/cloud_webhook_feature_flag_test.dart`
- `luna_lighthouse/test/widgets/ui/scaffold_test.dart`

Maestro launch-smoke coverage lives under:

- `luna_lighthouse/.maestro/config.yaml`
- `luna_lighthouse/.maestro/flows/android/launch_smoke.yaml`
- `luna_lighthouse/.maestro/flows/android/settings_about_smoke.yaml`
- `luna_lighthouse/.maestro/flows/ios/launch_smoke.yaml`
- `luna_lighthouse/.maestro/flows/ios/settings_about_smoke.yaml`

Covered phase-one risks include route registry drift, cloud/webhook feature-gate behavior, profile JSON serialization, legacy/partial profile import behavior, Hive-backed profile selection/storage and box clearing, self-hosted runner workflow routing, module-state host validation, module enablement/provider registry wiring, Settings About/Open Source rendering, Android and non-Android scaffold behavior, focus/profile-change scaffold hooks, Android/iOS Maestro launch and Settings About smoke, and fixture-driven API model serialization for selected Radarr, Sonarr, Tautulli, NZBGet, and SABnzbd contracts.

## Backlog Coverage

The next sprint plan lives at `docs/plans/2026-04-29-next-sprint-release-confidence.md`.

- Capture `Build Mobile` dry-run evidence for the selected release flavor.
- Verify GitHub branch protection requires all five current mobile gates.
- Ratchet `scripts/check-flutter-coverage` only after meaningful launch-focused coverage improves the measured baseline.
- Review API key/custom-header storage before adding account, sync, or cloud work.
- Add deferred service integration tests before cloud/webhook reactivation.

## Performance Notes

Keep module state caches, image caching, and generated API models deterministic. Do not add startup work before `LunaBIOS` without measuring bootstrap and recovery-mode impact.
