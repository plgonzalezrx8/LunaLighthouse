# Next Sprint Release Confidence Plan

> **For Hermes:** Use test-driven-development for code changes and keep this plan updated as checkpoints land.

**Goal:** Convert the current enforced test suite into launch-grade release confidence by covering profile import/migration risk, adding coverage visibility, expanding only launch-touched API fixtures, and proving release operations are executable.

**Sprint length:** 1 focused engineering sprint.

**Base branch:** `development`

**Non-goals:** Do not reactivate cloud/webhook services, do not broaden desktop/web packaging, and do not chase arbitrary 100% line coverage if it does not reduce launch risk.

---

## Current Baseline

- `development` includes PR #9's enforced `mobile-test` CI gate and `scripts/mobile-build-check` now runs `flutter test` before analyze/builds.
- `development` includes PR #10's branch-protection checklist update requiring `mobile-test` beside analyze/generation/platform build checks.
- Flutter coverage now passes 91 tests across ten test files.
- `flutter test --coverage` measured 3.71% line coverage from `1373/37026` LCOV lines; the initial threshold is 2%.
- Remaining release-risk gaps are mostly around release-operation dry runs and broader phase-2 service validation.

## Sprint Outcomes

By the end of the sprint:

1. Legacy profile/config imports have focused regression coverage. Done.
2. CI produces Flutter coverage artifacts and fails below the measured minimum threshold. Done.
3. Launch-touched API model fixtures cover the next highest-risk services beyond the current Radarr/Sonarr tag and Tautulli user-name checkpoint. Done.
4. Release-signing and store-upload documentation has a dry-run checklist with explicit evidence requirements. Done.
5. DEV-DOCS reflects the actual test count, CI gates, and remaining phase-1 blockers. Done.

## Checkpoint 1: Profile Import And Legacy Payload Coverage

**Objective:** Prove `LunaConfig.import` and `LunaProfile.fromJson` tolerate old or partial payloads without losing safe defaults or selected-profile behavior.

**Files:**
- Test: `luna_lighthouse/test/database/profile_import_test.dart`
- Reference: `luna_lighthouse/lib/database/config.dart`
- Reference: `luna_lighthouse/lib/database/models/profile.dart`
- Reference: `luna_lighthouse/test/database/profile_storage_test.dart`

**Steps:**
1. Create an isolated Hive-backed test harness matching `profile_storage_test.dart`.
2. Add sanitized legacy payload fixtures inline or under `luna_lighthouse/test/fixtures/config/`.
3. Cover missing `key` fallback to `default`.
4. Cover missing newer header fields defaulting to empty maps.
5. Cover selected-profile fallback when the imported selected key does not exist.
6. Run `flutter test test/database/profile_import_test.dart`.
7. Run full `flutter test`.
8. Commit: `test: cover legacy profile imports`.

**Acceptance criteria:**
- No real hosts, keys, passwords, or custom header values appear in fixtures.
- Import failure behavior remains bootstrap/reset-safe.
- Tests prove old payloads do not crash current app startup assumptions.

## Checkpoint 2: Coverage Artifact And Threshold Gate

**Objective:** Make coverage measurable in CI before claiming anything like complete coverage.

**Files:**
- Modify: `.github/workflows/mobile_ci.yml`
- Optionally modify: `scripts/mobile-build-check`
- Create: `scripts/check-flutter-coverage` if threshold parsing is not already available.
- Modify: `DEV-DOCS/TESTING-PERFORMANCE.md`

**Steps:**
1. Run `flutter test --coverage` locally and inspect `luna_lighthouse/coverage/lcov.info`.
2. Add a CI step to upload LCOV as an artifact from `mobile-test`.
3. Add a conservative initial minimum line-coverage threshold only after measuring the current baseline.
4. Document how to raise the threshold over time.
5. Run `flutter test --coverage` and the threshold script locally.
6. Commit: `ci: publish flutter coverage artifacts`.

**Acceptance criteria:**
- CI exposes coverage data for every PR.
- Threshold is based on measured baseline, not vibes.
- The threshold blocks regressions without forcing meaningless test-padding.

## Checkpoint 3: Launch-Touched API Fixture Expansion

**Objective:** Add fixture coverage for API models most likely to be exercised during mobile relaunch flows.

**Files:**
- Extend: `luna_lighthouse/test/api/api_serialization_fixture_test.dart`
- Fixtures: `luna_lighthouse/test/fixtures/api/*.json`
- Reference: `luna_lighthouse/lib/api/radarr/models/**`
- Reference: `luna_lighthouse/lib/api/sonarr/models/**`
- Reference: `luna_lighthouse/lib/api/nzbget/models/**`
- Reference: `luna_lighthouse/lib/api/sabnzbd/models/**`

**Priority order:**
1. Radarr/Sonarr queue or system status models used by core health/availability views.
2. NZBGet and SABnzbd status/version models used by downloader availability views.
3. Tautulli notification/log models only if launch UI touches those paths.

**Steps:**
1. Pick one service/model pair.
2. Add the smallest sanitized JSON fixture that reflects realistic API shape.
3. Add fromJson/toJson round-trip or normalization assertions.
4. Run the focused API fixture test.
5. Repeat for only the launch-touched models.
6. Run full `flutter test`.
7. Commit in small groups, e.g. `test: add downloader status fixtures`.

**Acceptance criteria:**
- No network calls.
- Fixtures are small and sanitized.
- Tests guard generated model contracts without hard-coding volatile registry counts.

## Checkpoint 4: Release Operations Dry Run

**Objective:** Turn the zero-to-launch runbook from plausible text into an executable pre-release checklist.

**Files:**
- Modify: `docs/zero-to-launch-checklist.md`
- Modify: `docs/mobile-baseline-checklist.md`
- Modify: `DEV-DOCS/CI-TROUBLESHOOTING.md` if CI behavior changes.

**Steps:**
1. Run read-only checks for required workflows, branch protection, and required status-check names.
2. Verify signing secret names in docs match workflow references.
3. Add a dry-run evidence section for Android and iOS build/upload preparation.
4. Record any manual-only steps explicitly.
5. Commit: `docs: add release dry-run evidence checklist`.

**Acceptance criteria:**
- A maintainer can follow the checklist without guessing status-check names or secret names.
- No secrets are copied into docs.
- Manual-only steps are marked as manual, not implied automated coverage.

## Checkpoint 5: Sprint Closeout And Handoff

**Objective:** Keep docs honest after the sprint lands.

**Files:**
- Modify: `DEV-DOCS/00-START-HERE.md`
- Modify: `DEV-DOCS/01-task-list.md`
- Modify: `DEV-DOCS/DEVELOPMENT-STATUS.md`
- Modify: `DEV-DOCS/TESTING-PERFORMANCE.md`
- Modify: `DEV-DOCS/work-log.md`

**Steps:**
1. Update test counts and coverage threshold status from actual command output.
2. Move completed tasks to Recently Completed.
3. List remaining blockers in priority order.
4. Run `git diff --check`.
5. Commit: `docs: update sprint closeout status`.

## Required Verification Before Sprint PRs

For code/test changes:

```bash
cd luna_lighthouse
flutter test
flutter analyze
```

Before a release-impacting handoff from repo root:

```bash
scripts/mobile-build-check
```

For docs-only changes:

```bash
git diff --check
```
