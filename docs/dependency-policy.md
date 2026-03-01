# Dependency Update Policy

## Cadence

- Weekly: security patch review for mobile dependencies.
- Bi-weekly: routine dependency updates (Flutter/Dart/Node/Ruby ecosystem).
- Monthly: toolchain baseline review in `lunasea/toolchain.env`.

## Rules

- Keep updates scoped and testable.
- Do not combine major runtime upgrades with branding/release-critical changes.
- For major upgrades, open a dedicated tracking issue with rollback notes.

## Required Validation for Dependency PRs

- `scripts/doctor`
- `scripts/mobile-build-check`
- Android signing lane dry-run (if dependency touches build pipeline)
- iOS signing lane dry-run on macOS (if dependency touches Apple toolchain)
