# Development Status

## Phase

Phase-1 mobile relaunch. iOS and Android are the active release targets. Non-mobile packaging remains present in the repo but is frozen for release gating.

## Observed Baseline

- Flutter app: `luna_lighthouse/`, version `11.0.0+1`, package identity `app.lunalighthouse.lunalighthouse`.
- Runtime stack: Flutter, GoRouter, Provider/ChangeNotifier, Hive, Dio/Retrofit, Easy Localization.
- Toolchain contract: `luna_lighthouse/toolchain.env` pins Flutter revision, Java 17, Node 20, Ruby 2.7.6, Bundler 2, and Xcode 15+.
- CI gates: mobile analyze, generation check, Flutter test, Android debug build, and iOS debug no-codesign build; the branch-protection checklist includes all five mobile gates.
- Local automated coverage: `flutter test --coverage` currently passes 139 tests across thirteen test files; Maestro has Android and iOS launch-smoke plus Settings About and Settings Coming Soon smoke flows.
- Coverage baseline: LCOV reports 4.96% line coverage (`1844/37201`), and `scripts/check-flutter-coverage` enforces a 2% minimum.
- Cloud/webhook: code exists but is disabled for phase 1; Settings exposes only disabled Coming Soon messaging for deferred hosted features.

## Open Gaps

- Coverage is still sparse overall; raise the 2% floor only with tests that cover launch-relevant behavior.
- Release dry-run evidence must still be attached for `Build Mobile`; PR #14 provides green `Mobile CI` evidence at `https://github.com/plgonzalezrx8/LunaLighthouse/actions/runs/25192467035`.
- GitHub branch protection must be verified against the five current mobile CI gates.
- API key/custom-header storage needs a security direction before new sync, account, or cloud work.
- Hosted webhook relay needs auth, logging, Redis, Firebase, domain, and E2E validation before reactivation.
- Firebase cloud functions need runtime/dependency modernization review before phase-2 use.

## Done Criteria For Phase-1 Docs

- Root README clearly points contributors to DEV-DOCS.
- Maintainer docs and user docs do not imply cloud/webhook production availability.
- Branch and release policy language is consistent across docs.
- Next sprint plan is documented in `docs/plans/2026-04-29-next-sprint-release-confidence.md`.
