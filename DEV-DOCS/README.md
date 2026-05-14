# LunaLighthouse DEV-DOCS

`DEV-DOCS/` is the engineering operating layer for LunaLighthouse. It is for contributors, maintainers, and AI coding sessions that need the current codebase state, active priorities, and implementation contracts without rediscovering them from scratch.

## Reading Order

1. `00-START-HERE.md` for current phase, blockers, and immediate priorities.
2. `DEVELOPMENT-STATUS.md` for the observed baseline and open gaps.
3. `ARCHITECTURE.md` and `project-structure.md` for repo boundaries.
4. `TESTING-PERFORMANCE.md`, `SECURITY-GUIDELINES.md`, and `ENV-CONTRACT.md` before release-impacting changes.
5. Feature and implementation annexes for focused work.

## Folder Roles

- Core files: session handoff, task tracking, standards, architecture, testing, security, environment, CI, and git workflow.
- `features/`: product behavior, launch scope, supported surfaces, and acceptance boundaries.
- `implementation/`: reusable technical patterns and deferred-service reactivation notes.

Existing `docs/` remains the maintainer runbook and launch operations folder. `luna_lighthouse-docs/` remains end-user documentation.

## Maintenance Rules

- Update DEV-DOCS in the same change set as behavior, architecture, CI, security, or workflow changes.
- Review `00-START-HERE.md`, `01-task-list.md`, `DEVELOPMENT-STATUS.md`, and `work-log.md` every meaningful development session.
- Keep planned work labeled as backlog or phase-2; do not imply deferred cloud/webhook services are production-ready.
