# Phase 1/2 Release Readiness Evidence - 2026-04-30

This file records execution evidence for `ROADMAP.md` Phase 1 and Phase 2 on branch `features/phase-1-2-release-readiness`.

## Branch Sync

- Local branch at start: `development`.
- Evidence branch: `features/phase-1-2-release-readiness`.
- `HEAD`: `03a47b9d846387a5ab21b2148b74d5078a3b89aa`.
- `origin/development`: `03a47b9d846387a5ab21b2148b74d5078a3b89aa`.
- `origin/master`: `8bd5b8610667c7bfd542454f76cc015a7d9e38ae`.
- Result: `development` matched `origin/development` before the evidence branch was created.

## GitHub Governance

`master` initially returned `Branch not protected` from:

```bash
gh api repos/plgonzalezrx8/LunaLighthouse/branches/master/protection
```

Branch protection was applied with:

- strict required status checks enabled,
- required checks: `mobile-analyze`, `mobile-generation-check`, `mobile-test`, `mobile-build-android`, `mobile-build-ios`,
- admin enforcement enabled,
- stale approval dismissal enabled,
- CODEOWNERS review required,
- one approving review required,
- conversation resolution required,
- force pushes disabled,
- branch deletion disabled.

Post-configuration summary:

```json
{
  "strict": true,
  "contexts": [
    "mobile-analyze",
    "mobile-generation-check",
    "mobile-test",
    "mobile-build-android",
    "mobile-build-ios"
  ],
  "enforce_admins": true,
  "allow_force_pushes": false,
  "allow_deletions": false,
  "conversation_resolution": true,
  "reviews": {
    "dismiss_stale_reviews": true,
    "require_code_owner_reviews": true,
    "required_approving_review_count": 1
  }
}
```

## Self-Hosted Runners

Runner inventory from:

```bash
gh api repos/plgonzalezrx8/LunaLighthouse/actions/runners --paginate
```

- `github-runner-01-lunalighthouse`: `online`, not busy, labels include `self-hosted`, `Linux`, `lunalighthouse`.
- `github-runner-mac-mini-lunalighthouse`: `online`, not busy, labels include `self-hosted`, `macOS`, `lunalighthouse`.

Result: required Linux and macOS runner labels are present and online.

## Local Validation

Commands were run with the pinned LunaLighthouse toolchain environment:

- Flutter framework revision `ea121f8859e4b13e47a8f845e4586164519588bc`.
- Java 17.
- Node 20.
- Ruby 2.7.6.
- Bundler 2.
- Xcode 15+.

Results:

- `scripts/doctor`: passed.
- `scripts/bootstrap`: passed after escalation for Flutter SDK cache lockfile access.
- `cd luna_lighthouse && flutter test --coverage`: passed with 130 tests.
- `scripts/check-flutter-coverage luna_lighthouse/coverage/lcov.info 2`: passed at 3.71% line coverage (`1373/37026`).
- `cd luna_lighthouse && flutter analyze`: passed with no issues.
- `scripts/mobile-build-check`: passed. It completed doctor, dependency fetch, generation, 130 tests, analyzer, Android debug build, and iOS debug no-codesign build.

Notes:

- `scripts/bootstrap` rewrote `luna_lighthouse/android/Gemfile.lock` and `luna_lighthouse/ios/Gemfile.lock` as a validation side effect. Those changes were restored to keep this branch docs/evidence-only.
- `flutter test --coverage` emitted expected malformed JSON import-reset logs from profile import regression tests while still passing.
- Bootstrap reported existing npm audit findings: 17 vulnerabilities. This did not fail bootstrap and is outside Phase 1/2 scope.

## Maestro Smoke Evidence

Syntax checks:

- `cd luna_lighthouse && maestro check-syntax .maestro/flows/android/launch_smoke.yaml`: passed.
- `cd luna_lighthouse && maestro check-syntax .maestro/flows/ios/launch_smoke.yaml`: passed.

iOS launch smoke:

- Booted simulator: `iPhone 17 Pro`, UDID `000D55D0-93BA-45B5-988D-2D4CED040A4E`.
- `cd luna_lighthouse && flutter build ios --simulator --debug`: passed.
- `xcrun simctl install 000D55D0-93BA-45B5-988D-2D4CED040A4E luna_lighthouse/build/ios/iphonesimulator/Runner.app`: passed.
- `cd luna_lighthouse && maestro --platform ios --device 000D55D0-93BA-45B5-988D-2D4CED040A4E test --include-tags ios .maestro`: passed.
- Result: `[Passed] iOS launch smoke (7s)`, `1/1 Flow Passed`.

Android launch smoke:

- Existing Android emulator targets were listed, including `Pixel_8`.
- `flutter emulators --launch Pixel_8`: returned successfully.
- `adb wait-for-device` did not find a reachable device after roughly 90 seconds.
- `adb kill-server` was used to stop the stuck wait.
- Follow-up `adb devices` failed to start the daemon because the ADB smartsocket listener was already in use.
- Result: Android Maestro execution is blocked by local ADB daemon/socket state, not by the Maestro flow syntax.

## Remote Mobile CI

PR-triggered Mobile CI ran because `.github/workflows/mobile_ci.yml` has no `workflow_dispatch` trigger.

- Pull request: `https://github.com/plgonzalezrx8/LunaLighthouse/pull/15`.
- Run URL: `https://github.com/plgonzalezrx8/LunaLighthouse/actions/runs/25194846125`.
- Event: `pull_request`.
- Head SHA: `fe9ebdcd6b5d9186a201584acb3b6fb4ba9276e9`.
- Created: `2026-04-30T23:41:53Z`.
- Updated: `2026-04-30T23:52:13Z`.
- Conclusion: `success`.

Gate results:

- `mobile-analyze`: passed in 3m19s, job `73873021449`.
- `mobile-generation-check`: passed in 2m58s, job `73873021471`.
- `mobile-test`: passed in 3m50s, job `73873021452`.
- `mobile-build-android`: passed in 3m58s, job `73873021473`.
- `mobile-build-ios`: passed in 1m47s, job `73873021462`.

Coverage artifact:

- Artifact: `flutter-coverage-lcov`.
- Created: `2026-04-30T23:45:42Z`.
- Size: 50095 bytes.
- Expired: `false`.
- Archive URL: `https://api.github.com/repos/plgonzalezrx8/LunaLighthouse/actions/artifacts/6742419372/zip`.

CI warning:

- GitHub Actions emitted a Node.js 20 action deprecation warning for `actions/checkout@v4`, `actions/setup-java@v4`, and `android-actions/setup-android@v3`. This did not fail the run, but it should be tracked before GitHub forces JavaScript actions to Node.js 24 by default on 2026-06-02.

## Open Blockers

- Android Maestro launch smoke needs a clean local ADB/emulator session before it can be marked complete.
