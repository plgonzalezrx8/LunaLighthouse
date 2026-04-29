# Development Status

## Phase

Phase-1 mobile relaunch. iOS and Android are the active release targets. Non-mobile packaging remains present in the repo but is frozen for release gating.

## Observed Baseline

- Flutter app: `luna_lighthouse/`, version `11.0.0+1`, package identity `app.lunalighthouse.lunalighthouse`.
- Runtime stack: Flutter, GoRouter, Provider/ChangeNotifier, Hive, Dio/Retrofit, Easy Localization.
- Toolchain contract: `luna_lighthouse/toolchain.env` pins Flutter revision, Java 17, Node 20, Ruby 2.7.6, Bundler 2, and Xcode 15+.
- CI gates: mobile analyze, generation check, Android debug build, and iOS debug no-codesign build.
- Cloud/webhook: code exists but is disabled for phase 1.

## Open Gaps

- Coverage is improved but still incomplete: API serialization fixtures, broader module UI tests, and older profile migration payloads remain open.
- Hosted webhook relay needs auth, logging, Redis, Firebase, domain, and E2E validation before reactivation.
- Firebase cloud functions need runtime/dependency modernization review before phase-2 use.
- Branch policy and CI triggers must stay aligned with `development` integration and `master` release.

## Done Criteria For Phase-1 Docs

- Root README clearly points contributors to DEV-DOCS.
- Maintainer docs and user docs do not imply cloud/webhook production availability.
- Branch and release policy language is consistent across docs.
