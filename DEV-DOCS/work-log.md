# Work Log

## 2026-04-30 - Settings About And Open Source Detour

### Context

- A quick phase-1 detour added user-visible app metadata without changing runtime integrations, feature flags, schemas, signing, or package versions.
- `ROADMAP.md` was intentionally left untouched.

### Work

- Added a Settings `About` destination with the app icon, version, build, package, and license information.
- Added an `Open Source` screen backed by Flutter's license registry so package/license entries render inside the app.
- Added widget coverage for the Settings About route registration and About/Open Source rendering.
- Added Android and iOS Maestro Settings About smoke flows.
- Updated maintainer and user docs to identify where users can find app version and open-source package information.

### Validation

- `flutter test` passes with 137 tests.
- `flutter test --coverage` passes with 137 tests and reports 4.74% line coverage (`1761/37142`).
- `scripts/check-flutter-coverage luna_lighthouse/coverage/lcov.info 2` passes.
- `flutter analyze --no-pub` passes.
- `flutter build apk --debug --no-pub` and `flutter build ios --simulator --debug --no-pub` pass.
- `maestro --platform android --device emulator-5554 test --include-tags android .maestro` passes both Android launch and Settings About smoke flows.
- `maestro --platform ios --device 000D55D0-93BA-45B5-988D-2D4CED040A4E test --include-tags ios .maestro` passes both iOS launch and Settings About smoke flows.

## 2026-04-30 - Current-State Review And Documentation Refresh

### Context

- `development` is synced with `origin/development` at `18107f8e`.
- `origin/master` remains at `8bd5b861`; `development` contains PRs #12, #13, and #14.
- The only local untracked item is `.hermes/`, which was left untouched.

### Work

- Reviewed branch sync, recent drift from `master`, Mobile CI, Build Mobile, self-hosted runner workflow coverage, DEV-DOCS, maintainer docs, user docs, notification service, and cloud function deferral docs.
- Confirmed the current automated Flutter baseline is 130 tests across eleven focused test files with a 3.71% LCOV baseline and a 2% coverage floor.
- Recorded PR #14 `Mobile CI` evidence at `https://github.com/plgonzalezrx8/LunaLighthouse/actions/runs/25192467035`.
- Updated operational docs with post-PR #14 state, the current five-gate Mobile CI contract, self-hosted runner queue troubleshooting, and prioritized next steps.
- Corrected stale root/review docs that omitted `mobile-test` from the required CI gate list.

### Next Steps

- Run or capture a `Build Mobile` dry run for the selected release flavor.
- Verify GitHub branch protection requires all five current mobile gates.
- Review API key/custom-header storage before new account, sync, or cloud work.
- Keep cloud/webhook reactivation in phase-2 backlog until security/runtime validation is complete.

## 2026-04-29 - DEV-DOCS Bootstrap

### Context

- `development` was synced to `master` and is the active integration branch.
- The repo did not have a `DEV-DOCS/` folder.
- Current maintained docs lived under `docs/`, with end-user docs in `luna_lighthouse-docs/`.

### Work

- Bootstrapped DEV-DOCS core, feature, and implementation structure.
- Captured phase-1 mobile-first scope and phase-2 cloud/webhook deferral.
- Recorded codebase review findings around Flutter generation, Hive storage, CI, notification service, Firebase functions, and testing gaps.

### Follow-Up

- Keep operational docs current as relaunch tasks complete.
- Re-run doc impact checks after future behavior, CI, security, or architecture changes.

## 2026-04-28 - Phase-One Test Coverage Plan

### Context

- Phase-one relaunch confidence needs stronger automated coverage before release work continues.
- Existing Flutter tests cover only narrow module-state and scaffold behavior.
- Cloud/webhook features must stay deferred while route, profile, and API contracts are hardened.

### Work

- Created `docs/plans/2026-04-28-phase-one-test-coverage.md` as the checkpoint-by-checkpoint implementation plan.
- Moved route, cloud/webhook feature-gate, profile storage, and API serialization tests into active phase-one work.
- Established `codex/phase-one-test-coverage` as the implementation branch.

### Follow-Up

- Implement the plan with TDD and frequent commits.
- Update `TESTING-PERFORMANCE.md`, `DEVELOPMENT-STATUS.md`, and this work log as coverage lands.

## 2026-04-28 - Phase-One Test Coverage Checkpoints

### Context

- Work continued on `codex/phase-one-test-coverage` after the plan checkpoint.
- Baseline Flutter test suite passed before adding new coverage.

### Work

- Added route registry smoke coverage in `luna_lighthouse/test/router/routes_smoke_test.dart`.
- Added phase-one cloud/webhook feature-gate coverage in `luna_lighthouse/test/system/cloud_webhook_feature_flag_test.dart`.
- Added profile JSON serialization coverage in `luna_lighthouse/test/database/profile_serialization_test.dart`.
- Added Hive-backed profile storage and selected-profile coverage in `luna_lighthouse/test/database/profile_storage_test.dart`.
- Added fixture-driven API serialization coverage in `luna_lighthouse/test/api/api_serialization_fixture_test.dart` with sanitized fixtures in `luna_lighthouse/test/fixtures/api/`.
- Added module enablement and provider registry coverage in `luna_lighthouse/test/modules/configuration/module_enablement_test.dart`.
- Expanded scaffold UI coverage in `luna_lighthouse/test/widgets/ui/scaffold_test.dart` for non-Android behavior, profile-change hooks, and focus clearing.
- Added Maestro Android and iOS launch-smoke flows under `luna_lighthouse/.maestro/`.
- Updated testing/status docs to reflect the new coverage surface.

### Validation

- `flutter test` passes with 41 tests.
- `flutter analyze` passes with no issues.
- `maestro check-syntax .maestro/flows/android/launch_smoke.yaml` passes.
- `maestro check-syntax .maestro/flows/ios/launch_smoke.yaml` passes.
- `maestro --platform android --device emulator-5554 test --include-tags android .maestro` passes on `Pixel_8`.
- `maestro --platform ios --device 219C2460-FB14-4BB6-93E0-09B511432A4D test --include-tags ios .maestro` passes on iPhone 16 Pro simulator.

### Follow-Up

- Expand generated API model/client fixtures beyond the initial Radarr, Sonarr, and Tautulli coverage.
- Add older profile migration payload coverage.
- Run `scripts/mobile-build-check` before final release-impacting handoff.

## 2026-04-29 - Coverage PR Merge And Next Gate

### Context

- PR #5 merged the phase-one mobile coverage branch into `development`.
- PR #6 was generated against the pre-PR-5 tree and targeted `master`, so it conflicted with current `development`.
- PR #7 replaced PR #6 with a clean branch from `development` and kept only the useful generated coverage.

### Work

- Closed PR #6 as superseded by PR #7.
- Merged PR #7 into `development` with conflict-resolved generated coverage.
- Updated DEV-DOCS to reflect the current 68-test Flutter suite and Maestro Android/iOS launch-smoke coverage.
- Rechecked CI and local scripts: `.github/workflows/mobile_ci.yml` has analyze/generation/build jobs, but no dedicated `flutter test` job; `scripts/mobile-build-check` also omits `flutter test`.

### Validation

- `flutter test` passes with 68 tests from `luna_lighthouse/`.
- PR #7 checks passed: `mobile-analyze`, `mobile-generation-check`, `mobile-build-android`, `mobile-build-ios`, Socket, CodeRabbit, and Devin Review.

### Follow-Up

- Add a dedicated `flutter test` CI gate and make it required with the existing mobile checks.
- Update `scripts/mobile-build-check` to run `flutter test` before analyze/builds.
- After tests are CI-enforced, continue with older profile migration payload coverage or release-signing readiness, depending on launch priority.

## 2026-04-29 - Mobile Test Gate

### Context

- The phase-one Flutter test suite existed locally, but CI did not run `flutter test`.
- `scripts/mobile-build-check` also omitted `flutter test`, so release-impacting local validation did not fully match the coverage surface.

### Work

- Added `mobile-test` to `.github/workflows/mobile_ci.yml` to run `flutter test` on pull requests and pushes to `development`/`master`.
- Updated `scripts/mobile-build-check` to run `flutter test` before `flutter analyze` and platform builds.
- Updated DEV-DOCS and launch docs so the mobile release checklist names the test gate as release-critical.

### Validation

- Run the full local verification suite before merging this work.
- Confirm PR checks include the new `mobile-test` gate.

### Follow-Up

- If branch protection is managed manually in GitHub, add `mobile-test` to required checks alongside `mobile-analyze`, `mobile-generation-check`, `mobile-build-android`, and `mobile-build-ios`.
- Continue with older profile migration payload coverage once the test gate is enforced.


## 2026-04-29 - Next Sprint Planning

### Context

- PR #9 added and enforced the `mobile-test` CI gate for the current Flutter suite.
- PR #10 updated the branch-protection checklist so `mobile-test` is required with the other mobile checks.
- The current suite has 68 Flutter tests across eight files, but coverage visibility and legacy import coverage are still incomplete.

### Work

- Added `docs/plans/2026-04-29-next-sprint-release-confidence.md` as the next sprint plan.
- Reprioritized active DEV-DOCS tasks around legacy profile/config import coverage, measured coverage artifacts, launch-touched API fixtures, and release dry-run evidence.
- Updated status/testing docs to distinguish enforced test execution from actual line-coverage metrics.

### Follow-Up

- Start the sprint with legacy profile/config import tests.
- Measure `flutter test --coverage` before setting any threshold.
- Keep cloud/webhook reactivation out of phase-one scope until the phase-2 security/runtime checklist exists.

## 2026-04-30 - PR #14 Self-Hosted Runner Workflow Test Review

### Context

- PR #14 was generated against `master`, but the requested merge target is `development`.
- `development` already contains the two-job Linux/macOS self-hosted runner workflow from PR #13.

### Work

- Retargeted PR #14 to `development`.
- Merged `origin/development` into the PR branch with no textual conflicts.
- Updated `luna_lighthouse/test/ci/self_hosted_runner_workflow_test.dart` to assert the current Linux and macOS self-hosted runner jobs.
- Updated DEV-DOCS and the sprint plan with the current 130-test suite and unchanged 3.71% LCOV baseline.

### Validation

- `flutter test test/ci/self_hosted_runner_workflow_test.dart` passes with 39 tests.
- `flutter test` passes with 130 tests.
- `flutter test --coverage` passes with 130 tests.
- `flutter analyze` passes with no issues.
- `scripts/check-flutter-coverage luna_lighthouse/coverage/lcov.info 2` passes at 3.71% line coverage.
- `git diff --check` passes.

## 2026-04-29 - Release Confidence Sprint Implementation

### Context

- The next sprint plan was implemented from `development` on `features/release-confidence-sprint`.
- The sprint stayed within docs/test/CI hygiene scope and did not reactivate cloud/webhook services.

### Work

- Added legacy profile/config import tests covering missing profile keys, missing header maps, partial legacy payloads, invalid selected-profile fallback, and invalid import reset behavior.
- Added launch-touched API fixtures for Radarr queue status, Sonarr empty queue page, NZBGet status/version, and SABnzbd version.
- Updated `mobile-test` to run `flutter test --coverage`, enforce `scripts/check-flutter-coverage coverage/lcov.info 2`, and upload `flutter-coverage-lcov`.
- Stabilized scaffold widget tests by avoiding the Hive clear race in setup and by simulating PopScope behavior directly.
- Added release dry-run evidence requirements and exact signing secret names to launch runbooks.
- Updated DEV-DOCS with the measured 91-test suite and 3.71% LCOV baseline.
- Updated `scripts/bootstrap` to skip nested app npm lifecycle hooks during `npm ci`; the app package prepare hook is not safe when run below the git root.

### Validation

- `flutter test test/database/profile_import_test.dart` passes with 10 tests.
- `flutter test test/database/box_clear_test.dart` passes with 9 tests.
- `flutter test test/api/api_serialization_fixture_test.dart` passes with 11 tests.
- `flutter test test/widgets/ui/scaffold_test.dart` passes with 11 tests.
- `flutter test --coverage` passes with 91 tests.
- `flutter analyze` passes with no issues.
- `scripts/check-flutter-coverage luna_lighthouse/coverage/lcov.info 2` passes at 3.71% line coverage.
- `scripts/bootstrap` passes with the pinned toolchains selected.
- `luna_lighthouse-notification-service`: `npm ci --ignore-scripts`, `npm run build`, `npm run lint`, and `npm test --if-present` pass.
- `luna_lighthouse-cloud-functions/functions`: `npm ci --ignore-scripts`, `npm run build`, `npm run lint`, and `npm test --if-present` pass.
- Maestro syntax checks pass for Android and iOS flows.
- Maestro Android launch smoke passes on `emulator-5554`.
- Maestro iOS launch smoke passes on iPhone 16 Pro simulator `219C2460-FB14-4BB6-93E0-09B511432A4D`.
- `scripts/mobile-build-check` passes when the pinned Java 17, Node 20, Ruby 2.7.6, Bundler 2, and Flutter paths are selected.

### Follow-Up

- Capture live `Mobile CI` and `Build Mobile` run URLs for the release dry-run evidence checklist.
- Keep cloud/webhook reactivation in phase-2 backlog until security/runtime validation is complete.
