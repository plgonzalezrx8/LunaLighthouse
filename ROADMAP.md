# LunaLighthouse Release Readiness Roadmap

This roadmap defines what must happen from the current `development` state until LunaLighthouse is release-ready for phase 1.

Phase-1 release-ready means the iOS and Android Flutter app can be signed, tested, submitted, released, supported, and recovered without relying on hosted cloud account flows or hosted webhook push notifications. Cloud account and hosted webhook notification services remain phase-2/deferred while `LunaFeatureFlags.cloudIntegrationsEnabled = false`.

## Current Baseline

- Active integration branch: `development`.
- Protected/release branch: `master`.
- Mobile app: `luna_lighthouse/`, package identity `app.lunalighthouse.lunalighthouse`, version `11.0.0+1`.
- CI gates expected for release protection:
  - `mobile-analyze`
  - `mobile-generation-check`
  - `mobile-test`
  - `mobile-build-android`
  - `mobile-build-ios`
- Automated test baseline: 130 Flutter tests across eleven focused test files.
- Coverage baseline: 3.71% LCOV line coverage (`1373/37026`) with `scripts/check-flutter-coverage` enforcing an initial 2% minimum.
- Current release risk: `Build Mobile` dry-run evidence, branch protection verification, store account setup, signing secrets, domain evidence, and launch QA signoff still need to be captured.

## Phase 1: Sync And Governance Verification

Goal: prove the repository is protected, reviewable, and synchronized before release work starts.

Checklist:

- [x] Confirm local `development` matches `origin/development`.
- [x] Confirm `master` remains the protected release branch.
- [x] Verify branch protection on `master` requires:
  - `mobile-analyze`
  - `mobile-generation-check`
  - `mobile-test`
  - `mobile-build-android`
  - `mobile-build-ios`
- [x] Verify branch protection requires at least one PR approval.
- [x] Verify branch protection requires conversation resolution before merge.
- [x] Verify force pushes and branch deletion are disabled for `master`.
- [x] Verify `CODEOWNERS` review behavior is active if CODEOWNERS is used for release-sensitive paths.
- [x] Confirm self-hosted runner capacity:
  - Linux jobs require `[self-hosted, lunalighthouse, Linux]`.
  - iOS jobs require `[self-hosted, lunalighthouse, macOS]`.

Commands:

```bash
git checkout development
git fetch origin
git status -sb
git rev-parse HEAD origin/development origin/master
git ls-remote origin refs/heads/development refs/heads/master
gh pr status
gh api repos/<ORG>/<REPO>/branches/master/protection
```

Evidence to save:

- `git status -sb` output showing `development...origin/development`.
- Commit SHAs for `HEAD`, `origin/development`, and `origin/master`.
- Branch protection JSON or screenshots.
- Runner list/screenshot showing online Linux and macOS self-hosted runners.

References:

- GitHub protected branches: https://docs.github.com/articles/about-required-status-checks

## Phase 2: CI And Local Validation Confidence

Goal: prove the release candidate passes the same checks locally and in GitHub Actions.

Checklist:

- [x] Run the local toolchain baseline.
- [x] Run bootstrap from a clean dependency state where practical.
- [x] Run Flutter tests with coverage.
- [x] Run the coverage gate at the current 2% threshold.
- [x] Run Flutter analyzer.
- [x] Run the full mobile build check before release-impacting handoff.
- [ ] Run or capture Maestro Android and iOS launch-smoke evidence on real or emulator/simulator devices. iOS passed on simulator; Android is blocked by local ADB daemon startup failure.
- [x] Confirm Mobile CI passes all five gates on the release candidate branch or commit. PR #15 run `25194846125` passed `mobile-analyze`, `mobile-generation-check`, `mobile-test`, `mobile-build-android`, and `mobile-build-ios`.
- [x] Confirm `mobile-test` uploads the `flutter-coverage-lcov` artifact. Run `25194846125` uploaded artifact `flutter-coverage-lcov`.
- [x] Raise the coverage threshold only after meaningful launch-focused tests improve the measured baseline. No threshold change made; current 3.71% baseline still supports the 2% floor.

Commands:

```bash
scripts/doctor
scripts/bootstrap

cd luna_lighthouse
flutter test --coverage
flutter analyze
cd ..

scripts/check-flutter-coverage luna_lighthouse/coverage/lcov.info 2
scripts/mobile-build-check
gh workflow run "Mobile CI"
gh run list --limit 20
```

Evidence to save:

- Local command output for `scripts/doctor`, `scripts/bootstrap`, `flutter test --coverage`, coverage gate, analyzer, and `scripts/mobile-build-check`.
- Mobile CI run URL showing green `mobile-analyze`, `mobile-generation-check`, `mobile-test`, `mobile-build-android`, and `mobile-build-ios`.
- Downloaded or linked `flutter-coverage-lcov` artifact.
- Maestro run logs/screenshots for Android and iOS launch smoke.

## Phase 3: Signing, Store, And Artifact Release Dry Runs

Goal: prove Android and iOS release artifacts can be built, signed, uploaded, and retrieved.

### GitHub Release Secrets

Why this is needed: `.github/workflows/build_mobile.yml` builds signed Android and iOS artifacts. Missing or misnamed secrets will fail release dry runs even if Mobile CI is green.

Required repository secrets:

| Secret | Needed For | How To Get It |
| --- | --- | --- |
| `KEY_JKS` | Android signing | Base64-encode the production `key.jks`. |
| `KEY_PROPERTIES` | Android signing | Base64-encode Android `key.properties`. |
| `APPLE_ID` | Fastlane/App Store Connect | Apple ID email used by the release maintainer. |
| `APPLE_ITC_TEAM_ID` | App Store Connect upload routing | App Store Connect team identifier. |
| `APPLE_TEAM_ID` | Apple Developer signing | Apple Developer team identifier. |
| `IOS_CODESIGNING_IDENTITY` | iOS signing | Distribution identity string, for example `Apple Distribution: <TEAM NAME> (<TEAM_ID>)`. |
| `MATCH_GIT_URL` | Fastlane Match | SSH URL for the private signing repo. |
| `MATCH_KEYCHAIN_NAME` | Fastlane Match | Release keychain name, for example `lunalighthouse-signing`. |
| `MATCH_KEYCHAIN_PASSWORD` | Fastlane Match | Password for the temporary CI keychain. |
| `MATCH_PASSWORD` | Fastlane Match | Encryption password for Match signing assets. |
| `MATCH_SSH_PRIVATE_KEY` | Fastlane Match | Private SSH key with read access to the Match repo. |

Secret handling rules:

- Store original signing material and passwords in a secret manager such as 1Password or Bitwarden.
- Do not commit `key.jks`, `key.properties`, Match keys, certificates, provisioning profiles, or decoded secrets.
- Record owner, creation date, rotation date, and recovery contact for each secret.

### Android Signing And Google Play

Why this is needed: Android production releases require a Play Console app, package identity ownership, an upload/signing key path, and an Android App Bundle.

Requirements:

- [ ] Google Play Console developer account with MFA enabled.
- [ ] Play Console app created for package `app.lunalighthouse.lunalighthouse`.
- [ ] Play App Signing decision recorded:
  - Recommended: enroll in Play App Signing and protect the upload key separately.
  - Alternative: owner-managed app signing key with stronger backup obligations.
- [ ] Production Android keystore generated and backed up.
- [ ] `key.properties` created locally and stored only in secret manager/GitHub secret form.
- [ ] SHA-256 certificate fingerprint recorded for Android App Links.
- [ ] Store listing prepared: app name, short description, full description, icon, feature graphic, screenshots, category, contact email, privacy policy URL.
- [ ] Data safety and content rating forms completed.
- [ ] Internal testing track configured and tester list created.
- [ ] Closed testing track configured if required by the Play account.

Commands:

```bash
cd luna_lighthouse/android
keytool -genkeypair \
  -v \
  -keystore key.jks \
  -alias lunalighthouse \
  -keyalg RSA \
  -keysize 4096 \
  -validity 3650

keytool -list -v -keystore key.jks -alias lunalighthouse | rg SHA256
base64 -i key.jks > /tmp/KEY_JKS.b64
base64 -i key.properties > /tmp/KEY_PROPERTIES.b64
```

Evidence to save:

- Play Console app screenshot.
- Internal testing track screenshot.
- Keystore fingerprint.
- GitHub secret names present.
- Successful Android artifact from `Build Mobile`.
- AAB upload confirmation.

References:

- Google Play release management: https://support.google.com/googleplay/android-developer/answer/9859348
- Google Play internal/closed testing: https://support.google.com/googleplay/android-developer/answer/9845334

### iOS Signing And App Store Connect

Why this is needed: iOS release artifacts require Apple Developer membership, App Store Connect app metadata, distribution signing assets, and TestFlight upload readiness.

Requirements:

- [ ] Apple Developer Program membership active.
- [ ] App Store Connect access with Account Holder, Admin, or App Manager permissions.
- [ ] Bundle ID/app record created for `app.lunalighthouse.lunalighthouse`.
- [ ] Fastlane Match private repo created, for example `<ORG>/lunalighthouse-match`.
- [ ] Match SSH deploy key generated, added to the Match repo, and stored in secret manager.
- [ ] Apple Distribution certificate and provisioning profile created through Match.
- [ ] App Store metadata prepared: app name, privacy policy URL, support URL, category, age rating, export compliance, screenshots, and release notes.
- [ ] TestFlight internal group created.
- [ ] External testing metadata prepared if beta release uses external TestFlight testers.

Commands:

```bash
gh repo create <ORG>/lunalighthouse-match --private
ssh-keygen -t ed25519 -f ~/.ssh/lunalighthouse_match -C "lunalighthouse-match"

cd luna_lighthouse/ios
bundle install
bundle exec fastlane keychain_create
bundle exec fastlane keychain_setup
bundle exec fastlane build_appstore build_number:1000000001
```

Evidence to save:

- Apple Developer membership screenshot.
- App Store Connect app record screenshot.
- Match repo URL and deploy-key evidence.
- Successful iOS artifact from `Build Mobile`.
- TestFlight upload confirmation.

References:

- Apple Developer enrollment: https://developer.apple.com/programs/enroll/
- App Store Connect app creation: https://developer.apple.com/help/app-store-connect/create-an-app-record/add-a-new-app

### Build Mobile Dry Run

Checklist:

- [ ] Trigger `Build Mobile` with `flavor=edge`.
- [ ] Confirm `Prepare`, `Build Android`, and `Build iOS` complete.
- [ ] Download Android and iOS artifacts.
- [ ] Confirm artifact names:
  - `lunalighthouse-android-edge`
  - `lunalighthouse-ios-edge`
- [ ] Store run URL and artifact links in release evidence.

Commands:

```bash
gh workflow run "Build Mobile" -f flavor=edge
gh run list --workflow "Build Mobile" --limit 10
gh run watch <RUN_ID>
```

## Phase 4: Domains, Docs, Website, Support, And Compliance

Goal: prove users, stores, and devices can reach required public surfaces.

### Domains And Hosting

Why this is needed: store listings, privacy/support links, universal links/app links, docs, build artifacts, and phase-2 notification reservation all depend on controlled HTTPS domains.

Required hosts:

| Host | Phase-1 Requirement | Purpose |
| --- | --- | --- |
| `www.lunalighthouse.app` | Required | Website, privacy/support links, `.well-known` files. |
| `docs.lunalighthouse.app` | Required | User documentation. |
| `builds.lunalighthouse.app` | Required | Release artifact distribution or internal artifact handoff. |
| `notify.lunalighthouse.app` | Placeholder required | Reserved phase-2 hosted webhook relay host. |

Checklist:

- [ ] DNS records exist for every required host.
- [ ] TLS is active and auto-renewing for every required host.
- [ ] Certificate expiration alerts are configured.
- [ ] `notify.lunalighthouse.app` resolves to a placeholder and does not imply hosted notifications are active.
- [ ] `www.lunalighthouse.app/.well-known/assetlinks.json` is deployed with the production Android SHA-256 fingerprint.
- [ ] `www.lunalighthouse.app/.well-known/apple-app-site-association` is deployed with the Apple Team ID and app identifier.
- [ ] Website and docs clearly state cloud account and hosted webhook features are temporarily unavailable in phase 1.

Evidence to save:

- DNS provider screenshot.
- TLS certificate check output or screenshot.
- Browser/network output for both `.well-known` files.
- Website/docs URLs.

### Support And Compliance

Requirements:

- [ ] Support mailbox `hello@lunalighthouse.app` exists, receives mail, and has MFA on its admin account.
- [ ] Privacy policy URL exists and matches store listing URLs.
- [ ] Support URL exists and matches store listing URLs.
- [ ] Release notes include cloud/webhook deferred status.
- [ ] Incident rollback runbook is reviewed before production release.
- [ ] Crash reporting is selected or consciously deferred with a documented owner decision.
- [ ] Billing owner and backup owner are recorded for domain, hosting, Apple, Google, and optional monitoring services.

Evidence to save:

- Test email to support mailbox.
- Privacy/support page URLs.
- Release notes draft.
- Billing owner record in the secret manager or maintainer docs.

## Phase 5: Internal QA, Beta, Release Candidate, And Production Release

Goal: move from signed artifacts to tested store releases.

Checklist:

- [ ] Upload Android AAB to Play internal testing.
- [ ] Upload iOS IPA to TestFlight internal testing.
- [ ] Execute `docs/relaunch-qa-scenarios.md`.
- [ ] Verify local module setup for supported launch modules.
- [ ] Verify local backup/restore behavior.
- [ ] Verify cloud/webhook UI remains hidden, disabled, or clearly unavailable.
- [ ] Promote Android internal testing to closed testing after internal signoff.
- [ ] Promote TestFlight internal testing to external testing if needed.
- [ ] Fix only release-blocking defects on small branches from `development`.
- [ ] Re-run Mobile CI and `Build Mobile` after every release-candidate fix.
- [ ] Merge release candidate into `master` only after all required checks pass and conversations are resolved.
- [ ] Submit Android staged rollout.
- [ ] Submit iOS App Store release.
- [ ] Publish production release notes.

Evidence to save:

- QA checklist with pass/fail notes.
- Store upload confirmations.
- TestFlight/internal testing screenshots.
- Closed beta feedback summary.
- Final Mobile CI URL.
- Final `Build Mobile` URL.
- Production submission screenshots.

## Phase 6: Post-Launch Stabilization

Goal: make launch support operational rather than ad hoc.

Checklist:

- [ ] Start daily triage during the stabilization window.
- [ ] Track store reviews, support mailbox, crash reports if configured, and GitHub issues.
- [ ] Use `docs/runbooks/incident-rollback.md` for incident handling.
- [ ] Keep phase-1 release notes clear that hosted cloud/webhook notifications are deferred.
- [ ] Run weekly dependency/security review.
- [ ] Run monthly access and secret audit.
- [ ] Record any launch incidents and fixes in maintainer docs.

Exit criteria:

- No unresolved release-blocking app defects.
- Support mailbox is monitored.
- Store crash/review signals are understood.
- A first post-launch patch path has been rehearsed or documented.

## Phase 7: Phase-2 Cloud, Webhook, And Push Notification Readiness

Goal: define what must be true before hosted cloud account flows or hosted webhook push notifications can be reactivated. This phase is not required for phase-1 mobile release readiness.

Current phase-2 boundary:

- The Flutter app currently has no Firebase client dependency in `luna_lighthouse/pubspec.yaml`.
- `luna_lighthouse/lib/system/feature_flags.dart` sets `LunaFeatureFlags.cloudIntegrationsEnabled = false`.
- `luna_lighthouse-notification-service/` and `luna_lighthouse-cloud-functions/` exist, but are deferred runtime surfaces.
- Public docs must not imply hosted push/webhook production availability until this phase is completed.

### Firebase And FCM

Why this is needed: Firebase/FCM is required only when LunaLighthouse reactivates cloud accounts, device registration, hosted notification delivery, or Firebase-backed account cleanup. Firebase client API keys are configuration identifiers used by Firebase client SDKs; they are not the same as server secrets. Firebase service-account private keys and APNs keys are secrets and must be protected.

Future client setup requirements:

- [ ] Create or select a Firebase project for LunaLighthouse.
- [ ] Add Android app `app.lunalighthouse.lunalighthouse`.
- [ ] Add iOS app `app.lunalighthouse.lunalighthouse`.
- [ ] Generate Firebase client configuration artifacts:
  - Android: `google-services.json`.
  - iOS: `GoogleService-Info.plist`.
- [ ] Add FlutterFire/Firebase client dependencies in a dedicated implementation PR, not in this roadmap pass.
- [ ] Enable Firebase Cloud Messaging.
- [ ] For iOS push, create an APNs authentication key in Apple Developer and upload it in Firebase Console under Project Settings > Cloud Messaging.
- [ ] Define how device tokens are registered, refreshed, deleted, and protected.
- [ ] Add E2E tests for notification opt-in, token registration, token deletion, and push delivery.

Future Firebase Admin/service requirements for the notification relay:

- [ ] Generate a Firebase Admin service account for the server runtime.
- [ ] Store the service-account JSON in a secret manager.
- [ ] Provide runtime values:
  - `FIREBASE_PROJECT_ID`
  - `FIREBASE_CLIENT_EMAIL`
  - `FIREBASE_PRIVATE_KEY`
  - `FIREBASE_DATABASE_URL`
- [ ] Scope IAM permissions to Auth, Firestore, Cloud Messaging, and any required Storage bucket access.
- [ ] Validate service-account key rotation and emergency revocation.
- [ ] Avoid printing user IDs, tokens, headers, private keys, or notification payload secrets in logs.

Future cloud-functions requirements:

- [ ] Confirm `luna_lighthouse-cloud-functions/functions` deploys on the intended Firebase runtime.
- [ ] Review `firebase-functions` and `firebase-admin` versions for current runtime support.
- [ ] Test Auth `onDelete` cleanup behavior in a staging Firebase project.
- [ ] Validate Firestore and Storage deletion behavior awaits nested async work correctly before production use.
- [ ] Deploy through Firebase CLI only after staging tests pass.

References:

- Firebase Flutter setup: https://firebase.google.com/docs/flutter/setup
- FCM Flutter setup: https://firebase.google.com/docs/cloud-messaging/flutter/get-started
- Firebase Admin setup/service accounts: https://firebase.google.com/docs/admin/setup
- Firebase Cloud Functions: https://firebase.google.com/docs/functions/get-started
- FCM iOS APNs key upload: https://firebase.google.com/docs/cloud-messaging/ios/get-started

### Redis

Why this is needed: the notification service uses Redis for cache/device-token-related behavior and artwork caching. Redis must be stable, authenticated, monitored, and failure-tested before hosted notifications are production-ready.

Requirements:

- [ ] Provision managed Redis or a production-operated Redis instance.
- [ ] Record connection values:
  - `REDIS_HOST`
  - `REDIS_PORT`
  - `REDIS_USER`
  - `REDIS_PASS`
  - `REDIS_USE_TLS`
- [ ] Enable TLS when the provider and plan support it.
- [ ] Restrict network access with IP allow lists, VPC controls, or equivalent provider controls.
- [ ] Use a least-privilege Redis user where supported.
- [ ] Configure alerts for availability, memory, connection count, and error rate.
- [ ] Test notification-service behavior when Redis is slow, unavailable, or returns auth failures.
- [ ] Document whether Redis data is disposable cache data or requires backup/restore.

References:

- Redis Cloud security: https://redis.io/docs/latest/operate/rc/security/database-security/
- Redis Cloud connectivity: https://redis.io/docs/latest/operate/rc/databases/connect/

### TMDB And Fanart.tv

Why this is needed: the notification relay uses TMDB and Fanart.tv to enrich notification artwork. These are external dependencies with API keys, terms, availability risk, and rate limits.

Requirements:

- [ ] Create or verify a TMDB developer account.
- [ ] Request a TMDB API key from account settings.
- [ ] Store the key as `THEMOVIEDB_API_KEY`.
- [ ] Create or verify a Fanart.tv account.
- [ ] Request the appropriate Fanart.tv project API key.
- [ ] Store the key as `FANART_TV_API_KEY`.
- [ ] Document attribution or terms obligations for artwork usage.
- [ ] Test relay behavior when TMDB/Fanart.tv are unavailable, rate-limited, or return no artwork.
- [ ] Ensure notification payloads degrade gracefully without artwork.

References:

- TMDB API key setup: https://developer.themoviedb.org/docs/getting-started
- Fanart.tv API entry point: https://webservice.fanart.tv/

### Hosted Notification Relay

Requirements before enabling hosted webhooks:

- [ ] Finish and review webhook authentication.
- [ ] Redact request headers, API keys, webhook tokens, Firebase tokens, and user/device identifiers from logs.
- [ ] Validate CORS, request size limits, and JSON parser limits.
- [ ] Validate `/health` behavior and deployment readiness checks.
- [ ] Add E2E tests for Custom, Lidarr, Overseerr, Radarr, Sonarr, and Tautulli webhook paths.
- [ ] Validate Firebase Messaging success/failure handling.
- [ ] Validate Redis failure behavior.
- [ ] Deploy to `notify.lunalighthouse.app` only after staging E2E tests pass.
- [ ] Update user docs and release notes only after the feature flag is intentionally changed in a reviewed implementation PR.

## Release-Ready Definition

LunaLighthouse is phase-1 release-ready when:

- `development` has a release candidate with all local and CI checks passing.
- `master` branch protection is verified with all five required mobile gates.
- `Build Mobile` has produced signed Android and iOS artifacts.
- Android internal testing and iOS TestFlight internal testing have accepted the release artifacts.
- Store listing, compliance, privacy/support URLs, domains, and release notes are ready.
- QA has signed off on launch-critical scenarios.
- Cloud account and hosted webhook notification deferral is explicit in docs, store notes, and support messaging.
- A post-launch stabilization owner and incident path are assigned.

## Documentation Links

- Engineering start: `DEV-DOCS/00-START-HERE.md`
- Current development status: `DEV-DOCS/DEVELOPMENT-STATUS.md`
- Test and CI status: `DEV-DOCS/TESTING-PERFORMANCE.md`
- Owner requirements: `docs/owner-requirements.md`
- Launch checklist: `docs/zero-to-launch-checklist.md`
- Release QA scenarios: `docs/relaunch-qa-scenarios.md`
- Cloud/webhook phase-1 status: `docs/cloud-webhook-phase1-status.md`
- Incident rollback: `docs/runbooks/incident-rollback.md`
