# New Files Guide

## App Code

- Add module UI, routes, and state under `luna_lighthouse/lib/modules/<module>/`.
- Add shared API clients, commands, and models under `luna_lighthouse/lib/api/<service>/`.
- Add persistent settings through Hive table/model patterns under `luna_lighthouse/lib/database/`.
- Add shared platform or service utilities under `luna_lighthouse/lib/system/`.

## Docs

- Add contributor handoff and implementation decisions under `DEV-DOCS/`.
- Add maintainer release and operational procedures under `docs/`.
- Add user-facing product help under `luna_lighthouse-docs/`.

## DEV-DOCS Annexes

- Use `features/` for user-facing behavior and launch scope.
- Use `implementation/` for reusable technical patterns, pitfalls, and reactivation contracts.
- Update `ARCHITECTURE.md`, `project-structure.md`, and `work-log.md` when adding a new subsystem.

## Generated Files

Do not create generated Dart or localization outputs manually. Update source annotations/templates and run the documented generation commands.
