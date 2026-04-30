# Project Structure

## Top-Level Directories

- `luna_lighthouse/`: primary Flutter app and mobile release workflows.
- `luna_lighthouse-docs/`: end-user documentation.
- `luna_lighthouse-notification-service/`: deferred hosted notification relay.
- `luna_lighthouse-cloud-functions/`: deferred Firebase support functions.
- `docs/`: maintainer governance, runbooks, and launch checklists.
- `DEV-DOCS/`: engineering operating docs for codebase handoff.
- `brand-assets/`: source and placeholder branding assets.
- `scripts/`: repo-level bootstrap, doctor, mobile build check, Flutter coverage threshold, and brand tooling.

## Flutter App Internals

- `lib/main.dart`: app bootstrap and recovery-mode boundary.
- `lib/router/`: GoRouter route definitions.
- `lib/modules/`: user-facing module surfaces and module state.
- `lib/api/`: service API clients and generated models.
- `lib/database/`: Hive boxes, tables, and profile models.
- `lib/system/`: platform services, feature flags, cache, filesystem, network, quick actions, and window manager.
- `assets/localization/`: generated merged localization assets.
- `test/fixtures/api/`: sanitized API JSON fixtures for launch-touched serialization contracts.

## Generated Areas

Do not hand-edit generated Dart files or merged localization outputs. Regenerate through:

- `dart run environment_config:generate`
- `dart ./scripts/generate_localization.dart`
- `dart run build_runner build --delete-conflicting-outputs`

Use `scripts/mobile-build-check` for the full generation/analyze/debug-build path.
