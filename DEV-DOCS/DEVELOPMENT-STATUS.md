# Development Status

## Phase

Phase-1 mobile relaunch. iOS and Android are the active release targets. Non-mobile packaging remains present in the repo but is frozen for release gating.

## Observed Baseline

- Flutter app: `luna_lighthouse/`, version `11.0.0+1`, package identity `app.lunalighthouse.lunalighthouse`.
- Runtime stack: Flutter, GoRouter, Provider/ChangeNotifier, Hive, Dio/Retrofit, Easy Localization.
- Toolchain contract: `luna_lighthouse/toolchain.env` pins Flutter revision, Java 17, Node 20, Ruby 2.7.6, Bundler 2, and Xcode 15+.
- CI gates: mobile analyze, generation check, Flutter test, Android debug build, and iOS debug no-codesign build; the branch-protection checklist includes all five mobile gates.
- Local automated coverage: `flutter test --coverage` currently passes 76 tests across nine test files; Maestro has Android and iOS launch-smoke flows.
- Coverage baseline: LCOV reports 3.70% line coverage (`1369/37024`), and `scripts/check-flutter-coverage` enforces a 2% minimum.
- Cloud/webhook: code exists but is disabled for phase 1.

## Open Gaps

- Coverage is still sparse overall; raise the 2% floor only with tests that cover launch-relevant behavior.
- Release dry-run evidence must still be captured from live `Mobile CI` and `Build Mobile` runs before launch handoff.
- Hosted webhook relay needs auth, logging, Redis, Firebase, domain, and E2E validation before reactivation.
- Firebase cloud functions need runtime/dependency modernization review before phase-2 use.

## Done Criteria For Phase-1 Docs

- Root README clearly points contributors to DEV-DOCS.
- Maintainer docs and user docs do not imply cloud/webhook production availability.
- Branch and release policy language is consistent across docs.
- Next sprint plan is documented in `docs/plans/2026-04-29-next-sprint-release-confidence.md`.
