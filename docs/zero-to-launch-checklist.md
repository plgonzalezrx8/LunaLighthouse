# LunaLighthouse Zero-to-Launch Checklist (Monorepo-First)

This checklist is the executable version of the 14-day launch plan. It assumes this repository is your launch control plane.

## Required Accounts and Services (Create Before Day 7)

- Apple Developer Program account (active team membership)
- App Store Connect app for `app.lunalighthouse.lunalighthouse`
- Google Play Console app for `app.lunalighthouse.lunalighthouse`
- GitHub repo admin access
- DNS/TLS control for `lunalighthouse.app`
- Artifact hosting for `builds.lunalighthouse.app` (S3/R2/GCS + HTTPS)
- Docs hosting for `docs.lunalighthouse.app`
- Website hosting for `www.lunalighthouse.app`
- Support mailbox (`hello@lunalighthouse.app`)
- Secret manager vault (for signing keys and API credentials)

## Day 1 — Local Toolchain Baseline

```bash
cd /path/to/LunaLighthouse

brew install --cask temurin
brew install nvm rbenv cocoapods jq

mkdir -p ~/.nvm
export NVM_DIR="$HOME/.nvm"
source "$(brew --prefix nvm)/nvm.sh"
nvm install 20
nvm alias default 20

rbenv install 2.7.6
rbenv global 2.7.6
gem install bundler -v "~>2.0"

mkdir -p ~/.sdk
git clone https://github.com/flutter/flutter.git ~/.sdk/flutter
git -C ~/.sdk/flutter checkout ea121f8859e4b13e47a8f845e4586164519588bc
echo 'export PATH="$HOME/.sdk/flutter/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

./scripts/doctor
./scripts/bootstrap
```

Manual: install full Xcode from App Store, open once, accept license.

## Day 2 — Account Ownership and Security

- Create/verify all required accounts and service ownership.
- Enable MFA everywhere.
- Store recovery codes in secret vault.

## Day 3 — Android Signing + Local Release Build

```bash
cd /path/to/LunaLighthouse/luna_lighthouse/android

keytool -genkeypair \
  -v \
  -keystore key.jks \
  -alias lunalighthouse \
  -keyalg RSA \
  -keysize 4096 \
  -validity 3650

cat > key.properties <<'EOF2'
storePassword=<STORE_PASSWORD>
keyPassword=<KEY_PASSWORD>
keyAlias=lunalighthouse
storeFile=key.jks
EOF2

bundle install
bundle exec fastlane build_aab build_number:1000000001
bundle exec fastlane build_apk build_number:1000000001
```

Manual: create Play Console app record for `app.lunalighthouse.lunalighthouse`.

## Day 4 — iOS Signing + Match Setup + Local IPA

```bash
# Create signing storage repo
# Replace <ORG> before running
gh repo create <ORG>/lunalighthouse-match --private

cd /path/to/LunaLighthouse/luna_lighthouse/ios
bundle install

export MATCH_GIT_URL=git@github.com:<ORG>/lunalighthouse-match.git
export MATCH_KEYCHAIN_NAME=lunalighthouse-signing
export MATCH_KEYCHAIN_PASSWORD=<KEYCHAIN_PASSWORD>
export MATCH_PASSWORD=<MATCH_ENCRYPTION_PASSWORD>
export FASTLANE_USER=<APPLE_ID_EMAIL>

ssh-keygen -t ed25519 -f ~/.ssh/lunalighthouse_match -C "lunalighthouse-match"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/lunalighthouse_match

bundle exec fastlane keychain_create
bundle exec fastlane keychain_setup

export IOS_CODESIGNING_IDENTITY="Apple Distribution: <TEAM NAME> (<TEAM_ID>)"
bundle exec fastlane build_appstore build_number:1000000001
```

Manual:
- Add `~/.ssh/lunalighthouse_match.pub` as write-enabled deploy key on `<ORG>/lunalighthouse-match`.
- Create App Store Connect app record for bundle ID `app.lunalighthouse.lunalighthouse`.

## Day 5 — Domains + Well-Known Files

Get Android cert fingerprint:

```bash
cd /path/to/LunaLighthouse/luna_lighthouse/android
keytool -list -v -keystore key.jks -alias lunalighthouse | rg SHA256
```

Prepare `.well-known` files using templates:

- `docs/templates/assetlinks.json.template`
- `docs/templates/apple-app-site-association.template`

Manual:
- Configure DNS for `www`, `docs`, `builds`, `notify`.
- Enable TLS + expiry monitoring.
- Deploy files to:
  - `https://www.lunalighthouse.app/.well-known/assetlinks.json`
  - `https://www.lunalighthouse.app/.well-known/apple-app-site-association`

## Day 6 — Final Brand Asset Generation

```bash
cd /path/to/LunaLighthouse

# Put final source files into brand-assets/v2-launch first.
./scripts/generate-brand-assets
git status
```

Manual: capture final app-store screenshots/graphics.

## Day 7 — GitHub Secrets + Branch Protection

Encode Android signing files:

```bash
cd /path/to/LunaLighthouse/luna_lighthouse/android
base64 -i key.jks > /tmp/KEY_JKS.b64
base64 -i key.properties > /tmp/KEY_PROPERTIES.b64
```

Set secrets (replace placeholders):

```bash
cd /path/to/LunaLighthouse

gh secret set KEY_JKS < /tmp/KEY_JKS.b64
gh secret set KEY_PROPERTIES < /tmp/KEY_PROPERTIES.b64
gh secret set APPLE_ID --body "<APPLE_ID_EMAIL>"
gh secret set APPLE_ITC_TEAM_ID --body "<APPLE_ITC_TEAM_ID>"
gh secret set APPLE_TEAM_ID --body "<APPLE_TEAM_ID>"
gh secret set IOS_CODESIGNING_IDENTITY --body "Apple Distribution: <TEAM NAME> (<TEAM_ID>)"
gh secret set MATCH_KEYCHAIN_NAME --body "lunalighthouse-signing"
gh secret set MATCH_KEYCHAIN_PASSWORD --body "<KEYCHAIN_PASSWORD>"
gh secret set MATCH_PASSWORD --body "<MATCH_ENCRYPTION_PASSWORD>"
gh secret set MATCH_GIT_URL --body "git@github.com:<ORG>/lunalighthouse-match.git"
gh secret set MATCH_SSH_PRIVATE_KEY < ~/.ssh/lunalighthouse_match
```

Protect `master`:

```bash
gh api \
  -X PUT \
  repos/<ORG>/<REPO>/branches/master/protection \
  -f required_status_checks.strict=true \
  -F required_status_checks.contexts[]='mobile-analyze' \
  -F required_status_checks.contexts[]='mobile-generation-check' \
  -F required_status_checks.contexts[]='mobile-build-android' \
  -F required_status_checks.contexts[]='mobile-build-ios' \
  -f enforce_admins=true \
  -f required_pull_request_reviews.dismiss_stale_reviews=true \
  -f required_pull_request_reviews.required_approving_review_count=1 \
  -f restrictions=
```

## Day 8 — CI Dry Runs

```bash
cd /path/to/LunaLighthouse

gh workflow run "Mobile CI"
gh workflow run "Build Mobile" -f flavor=edge

gh run list --limit 20
gh run watch
```

## Day 9 — Internal QA + Internal Store Uploads

```bash
cd /path/to/LunaLighthouse
./scripts/mobile-build-check
```

Manual:
- Upload AAB to Play internal track.
- Upload IPA to TestFlight internal group.
- Execute `docs/relaunch-qa-scenarios.md`.

## Day 10 — Closed Beta

Manual:
- Promote Android internal -> closed beta.
- Promote TestFlight internal -> external testing.
- Publish beta notes with cloud/webhook deferred status.

## Day 11–12 — Fixes + Release Candidate

```bash
cd /path/to/LunaLighthouse

# Repeat per fix
git checkout development
git pull --ff-only
git checkout -b features/hotfix-<topic>
# implement fix
git add .
git commit -m "fix(mobile): <summary>"
git push -u origin HEAD
```

Manual: merge PRs, rerun CI, generate RC artifacts.

## Day 13 — Production Release

Manual:
- Android staged rollout to production.
- iOS App Store submission/release.
- Publish production release notes.

## Day 14 — Stabilization Start

Manual:
- Daily triage rotation begins.
- Use `docs/runbooks/incident-rollback.md` for incident handling.
- Weekly dependency/security patch review.

## Required CI Workflows for This Plan

- `.github/workflows/mobile_ci.yml`
- `.github/workflows/build_mobile.yml`

These workflow names are used directly by Day 8 commands.
