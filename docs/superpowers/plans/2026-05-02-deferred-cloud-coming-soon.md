# Deferred Cloud Coming Soon Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a disabled Coming Soon Settings page for deferred hosted cloud, webhook, and push-notification features while preserving the existing phase-1 feature gate.

**Architecture:** Add one focused Settings route and one focused route widget. The route uses existing `LunaBlock(disabled: true)` styling and localized strings, with no service calls or setup actions. Tests verify routing and rendering without activating cloud/webhook behavior.

**Tech Stack:** Flutter, GoRouter, Easy Localization, existing Luna UI widgets, Maestro YAML smoke flows, Markdown documentation.

---

### Task 1: Add The Settings Route

**Files:**
- Modify: `luna_lighthouse/lib/router/routes/settings.dart`
- Create: `luna_lighthouse/lib/modules/settings/routes/coming_soon/route.dart`

- [ ] **Step 1: Add `COMING_SOON` to the settings route enum**

Add `COMING_SOON('coming_soon')` after `SYSTEM_LOGS_DETAILS`.

- [ ] **Step 2: Import and wire the route widget**

Import `package:luna_lighthouse/modules/settings/routes/coming_soon/route.dart`, return `const ComingSoonRoute()` from the enum switch, and include `SettingsRoutes.COMING_SOON.routes` in `SettingsRoutes.HOME.subroutes`.

- [ ] **Step 3: Implement `ComingSoonRoute`**

Create a stateful route using `LunaScaffold`, `LunaAppBar`, and `LunaListView`. Add four disabled blocks: Cloud Account, Cloud Sync, Hosted Push Notifications, and Notification Relay.

### Task 2: Add Settings Home Entry And Localization

**Files:**
- Modify: `luna_lighthouse/lib/modules/settings/routes/settings/route.dart`
- Modify: `luna_lighthouse/localization/settings/en.json`
- Generate: `luna_lighthouse/assets/localization/en.json`

- [ ] **Step 1: Add the Settings home block**

Add a `Coming Soon` block between System and About with `Icons.upcoming_rounded` and `SettingsRoutes.COMING_SOON.go`.

- [ ] **Step 2: Add English localization keys**

Add strings for the page title, page description, and each disabled feature card.

- [ ] **Step 3: Regenerate localization**

Run from `luna_lighthouse/`:

```bash
dart ./scripts/generate_localization.dart
```

### Task 3: Add Tests And Smoke Coverage

**Files:**
- Create: `luna_lighthouse/test/modules/settings/coming_soon_route_test.dart`
- Create: `luna_lighthouse/.maestro/flows/android/settings_coming_soon_smoke.yaml`
- Create: `luna_lighthouse/.maestro/flows/ios/settings_coming_soon_smoke.yaml`

- [ ] **Step 1: Add Flutter coverage**

Assert route registration, Settings home rendering, Coming Soon page rendering, and absence of active setup text.

- [ ] **Step 2: Add Maestro syntax-valid smoke flows**

Navigate from Settings to Coming Soon and assert Cloud Account, Cloud Sync, Hosted Push Notifications, and Notification Relay are visible.

### Task 4: Update Documentation

**Files:**
- Modify: `docs/cloud-webhook-phase1-status.md`
- Modify: `docs/mobile-baseline-checklist.md`
- Modify: `DEV-DOCS/features/cloud-webhook-deferral.md`
- Modify: `DEV-DOCS/TESTING-PERFORMANCE.md`
- Modify: `luna_lighthouse-docs/luna_lighthouse/cloud-account.md`
- Modify: `luna_lighthouse-docs/luna_lighthouse/notifications/README.md`

- [ ] **Step 1: Document in-app Coming Soon treatment**

State that phase-1 builds show disabled Coming Soon cards for hosted cloud and notification features.

- [ ] **Step 2: Preserve the deferred-service wording**

Keep docs clear that no hosted cloud or push notification backend is production-active.

- [ ] **Step 3: Do not modify `ROADMAP.md`**

Verify with `git diff --name-only`.

### Task 5: Validate, Commit, Push, And Open PR

**Files:**
- All changed files.

- [ ] **Step 1: Run focused and full checks**

```bash
cd luna_lighthouse
flutter test --no-pub test/modules/settings/coming_soon_route_test.dart
flutter test --coverage --no-pub
flutter analyze --no-pub
```

- [ ] **Step 2: Run coverage and diff checks**

```bash
scripts/check-flutter-coverage luna_lighthouse/coverage/lcov.info 2
git diff --check
```

- [ ] **Step 3: Validate Maestro syntax**

```bash
cd luna_lighthouse
maestro check-syntax .maestro/flows/android/settings_coming_soon_smoke.yaml
maestro check-syntax .maestro/flows/ios/settings_coming_soon_smoke.yaml
```

- [ ] **Step 4: Commit and push**

Commit all changes with `feat: add deferred cloud coming soon settings` and push `features/settings-coming-soon-deferred-cloud`.

- [ ] **Step 5: Open a PR to `development`**

Open a ready PR and do not merge it.
