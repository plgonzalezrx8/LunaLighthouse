# Mobile Development Setup

## Prerequisites

Use the pinned toolchain contract in `lunasea/toolchain.env`.

## First-Time Setup

1. Run `scripts/bootstrap`.
2. Run `scripts/mobile-build-check`.
3. Review `docs/mobile-baseline-checklist.md` before opening release PRs.

## Deterministic Generation Rules

The following must be regenerated when source inputs change:

- `dart run environment_config:generate` after environment template changes.
- `dart ./scripts/generate_localization.dart` after localization module changes.
- `dart run build_runner build --delete-conflicting-outputs` after model/API annotation changes.

Do not manually edit generated files.
