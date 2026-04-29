# Phase One Test Coverage Implementation Plan

> **For Hermes:** Use test-driven-development and frequent commits to implement this plan checkpoint-by-checkpoint.

**Goal:** Substantially increase LunaLighthouse phase-one mobile relaunch confidence by adding automated Flutter coverage around routing, cloud/webhook feature gating, profile storage/serialization, and launch-critical module behavior.

**Implementation status as of 2026-04-29:** PR #5 and PR #7 are merged into `development`. The Flutter suite now passes 68 local tests across eight focused files, and Maestro Android/iOS launch-smoke flows exist under `luna_lighthouse/.maestro/`. Remaining follow-up is test-infrastructure enforcement: add a dedicated CI `flutter test` gate and align `scripts/mobile-build-check` with that local test requirement.

**Architecture:** Phase one does not reactivate cloud/webhook services or expand product scope. The work adds focused tests around existing Flutter app behavior, preserving current generated-code and feature-flag contracts. Each checkpoint should be small, independently verifiable, and committed before moving to the next area.

**Tech Stack:** Flutter test, Dart, GoRouter, Provider/ChangeNotifier, Hive/Hive Flutter, json_serializable/Hive generated adapters, existing LunaLighthouse scripts.

---

## Branch And Commit Discipline

- Branch: `codex/phase-one-test-coverage`
- Base: `development`
- Commit after each coherent checkpoint.
- Prefer commit types:
  - `docs:` for plan/status updates
  - `test:` for pure test coverage
  - `fix:` only if tests expose an actual production bug that must be corrected
- Do not enable cloud/webhook features during phase one.
- Do not change generated files unless a test or build command proves generation drift.

## Validation Commands

Run focused checks during the TDD loop and broader checks at checkpoints:

```bash
cd luna_lighthouse
flutter test test/<specific_test_file>.dart
flutter test
flutter analyze
```

Before any release-impacting claim, run from repo root:

```bash
scripts/mobile-build-check
```

If `scripts/mobile-build-check` is too expensive for an intermediate checkpoint, record that clearly in the commit/PR notes and run it before final handoff.

## Checkpoint 0: Plan And Baseline

**Objective:** Record this implementation plan and establish the branch baseline.

**Files:**
- Create: `docs/plans/2026-04-28-phase-one-test-coverage.md`
- Modify: `DEV-DOCS/01-task-list.md`
- Modify: `DEV-DOCS/work-log.md`

**Steps:**
1. Create this plan.
2. Update DEV-DOCS task tracking to mark phase-one coverage as active.
3. Run the existing focused Flutter test suite if local dependencies are ready.
4. Commit: `docs: add phase-one test coverage plan`

## Checkpoint 1: Route Smoke Coverage

**Objective:** Prove every active root route registered in `LunaRoutes` can build or redirect without throwing under a minimal app harness.

**Files:**
- Test: `luna_lighthouse/test/router/routes_smoke_test.dart`
- Reference: `luna_lighthouse/lib/router/routes.dart`
- Reference: `luna_lighthouse/lib/router/router.dart`
- Reference: `luna_lighthouse/lib/system/state.dart`

**TDD cycle:**
1. Add a failing test that enumerates `LunaRoutes.values` and asserts each route has a non-empty key/root path.
2. Run only `flutter test test/router/routes_smoke_test.dart` and verify it fails for missing file/test registration first.
3. Implement the minimal test harness/helper needed to pass without changing production routing.
4. Add one route build/navigation smoke test at a time.
5. Run focused test, then full `flutter test`.
6. Commit: `test: add route smoke coverage`

**Acceptance criteria:**
- Tests cover all current `LunaRoutes.values` roots.
- Disabled modules render `NotEnabledPage` instead of throwing.
- The initial BIOS location remains covered.

## Checkpoint 2: Cloud/Webhook Feature-Gate Coverage

**Objective:** Prove hosted cloud/webhook behavior remains inert while `LunaFeatureFlags.cloudIntegrationsEnabled` is `false`.

**Files:**
- Test: `luna_lighthouse/test/system/cloud_webhook_feature_flag_test.dart`
- Reference: `luna_lighthouse/lib/system/feature_flags.dart`
- Reference: `luna_lighthouse/lib/modules.dart`
- Reference: `luna_lighthouse/lib/system/webhooks.dart`

**TDD cycle:**
1. Add a failing test asserting `LunaFeatureFlags.cloudIntegrationsEnabled` is `false` for phase one.
2. Add module-level tests proving `hasWebhooks` is false and `webhookDocs` is null for every module while the flag is off.
3. Run focused test and watch it fail before any production change.
4. Prefer no production change if current behavior already satisfies the tests after the test compiles.
5. Run focused test, then full `flutter test`.
6. Commit: `test: lock cloud webhook feature gate behavior`

**Acceptance criteria:**
- No hosted webhook surface is exposed by module metadata while the flag is off.
- URL builder behavior may remain documented for phase two, but tests must not imply active production availability.

## Checkpoint 3: Profile Serialization And Storage Coverage

**Objective:** Protect profile-backed configuration fields that store service hosts, API keys, passwords, and custom headers.

**Files:**
- Test: `luna_lighthouse/test/database/profile_serialization_test.dart`
- Test: `luna_lighthouse/test/database/profile_storage_test.dart`
- Reference: `luna_lighthouse/lib/database/models/profile.dart`
- Reference: `luna_lighthouse/lib/database/box.dart`
- Reference: `luna_lighthouse/lib/database/database.dart`

**TDD cycle:**
1. Add failing serialization tests for a representative fully-populated `LunaProfile`.
2. Verify JSON round trip preserves host/key/header/password fields for Lidarr, Radarr, Sonarr, SABnzbd, NZBGet, Tautulli, Overseerr, and Wake on LAN fields.
3. Add Hive-backed storage tests using an isolated temp directory.
4. Run focused tests and verify failure before any production change.
5. Fix only real bugs exposed by the tests; otherwise keep production code unchanged.
6. Run focused tests, then full `flutter test`.
7. Commit: `test: cover profile serialization and storage`

**Acceptance criteria:**
- Custom headers survive serialization.
- Existing Hive field defaults are protected by tests.
- Tests do not log real keys, hosts, passwords, or token-like values.

## Checkpoint 4: API Serialization Fixture Coverage

**Objective:** Add fixture-driven coverage for generated model/client contracts most likely to regress during relaunch work.

**Files:**
- Create directory: `luna_lighthouse/test/fixtures/api/`
- Test examples:
  - `luna_lighthouse/test/api/sonarr_serialization_test.dart`
  - `luna_lighthouse/test/api/radarr_serialization_test.dart`
  - `luna_lighthouse/test/api/tautulli_serialization_test.dart`
- Reference: `luna_lighthouse/lib/api/**/models/**/*.dart`

**TDD cycle:**
1. Pick one high-value model per service touched by launch-critical flows.
2. Add minimal JSON fixtures representing realistic API responses.
3. Write failing `fromJson`/`toJson` round-trip tests.
4. Run focused tests and verify failure before any production change.
5. Fix only real serialization defects exposed by the tests.
6. Commit per service or small group, e.g. `test: add sonarr api serialization fixtures`.

**Acceptance criteria:**
- Fixtures are sanitized and small.
- Tests cover generated model behavior without hitting live services.
- No network calls are introduced.

## Checkpoint 5: Module State And Launch-Critical UI Coverage

**Objective:** Expand confidence around module state reset/loading behavior and minimal launch-critical UI scaffolding.

**Files:**
- Extend: `luna_lighthouse/test/modules/configuration/module_state_test.dart`
- Add as needed: `luna_lighthouse/test/modules/<module>/state_test.dart`
- Extend: `luna_lighthouse/test/widgets/ui/scaffold_test.dart`

**TDD cycle:**
1. Add one failing behavior test per state object or UI behavior.
2. Run focused test and verify expected failure.
3. Implement the smallest production fix only when needed.
4. Run focused test, then full `flutter test`.
5. Commit: `test: expand module state coverage`

**Acceptance criteria:**
- Existing state behavior is preserved.
- Tests avoid brittle golden/UI snapshot dependence unless intentionally added later.
- UI tests focus on phase-one launch-critical rendering and disabled/deferred messaging.

## Checkpoint 6: Final Verification And Documentation Sync

**Objective:** Finish the branch with trustworthy evidence and updated docs.

**Files:**
- Modify: `DEV-DOCS/01-task-list.md`
- Modify: `DEV-DOCS/DEVELOPMENT-STATUS.md`
- Modify: `DEV-DOCS/TESTING-PERFORMANCE.md`
- Modify: `DEV-DOCS/work-log.md`

**Steps:**
1. Run `flutter test` from `luna_lighthouse/`.
2. Run `flutter analyze` from `luna_lighthouse/`.
3. Run `scripts/mobile-build-check` from repo root if toolchain is available.
4. Update DEV-DOCS with the new coverage state and any remaining gaps.
5. Commit: `docs: update test coverage status`.

**Final acceptance criteria:**
- New tests are committed in multiple reviewable checkpoints.
- Full Flutter test suite passes locally or any local toolchain limitation is documented honestly.
- `flutter analyze` passes or known pre-existing issues are documented honestly.
- Cloud/webhook features remain disabled for phase one.
- PR body lists exact validation commands and results.
