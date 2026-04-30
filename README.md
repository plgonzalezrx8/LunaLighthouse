# <img width="40px" src="./luna_lighthouse/assets/images/branding_logo.png" alt="LunaLighthouse"></img>&nbsp;&nbsp;LunaLighthouse

LunaLighthouse is an actively maintained, mobile-first self-hosted controller project.

## Repository Layout

- `luna_lighthouse/`: Flutter application (iOS/Android relaunch priority)
- `luna_lighthouse-docs/`: end-user documentation
- `luna_lighthouse-notification-service/`: hosted notification relay (phase-2 deferred service)
- `luna_lighthouse-cloud-functions/`: cloud support services (phase-2 deferred service)
- `docs/`: maintainer governance, runbooks, and operational checklists
- `DEV-DOCS/`: engineering handoff docs for active implementation context

## Phase-1 Relaunch Scope

- Primary focus: iOS and Android app reliability, signing, and store releases.
- Cloud account and hosted webhook features: phase-2/deferred and feature-gated off.
- Non-mobile distribution targets: frozen for release gating in phase 1.

## Contributor Start

Start with `DEV-DOCS/00-START-HERE.md` for the current engineering state, then read `DEV-DOCS/ARCHITECTURE.md` and the relevant feature or implementation annex before changing code. Use `docs/zero-to-launch-checklist.md` for release execution.

## Maintainer Workflow

- Use `development` as the active integration branch.
- Treat `master` as the protected release branch.
- Use `ROADMAP.md` for the phase-1 release-readiness path and phase-2 external service requirements.
- Run `scripts/bootstrap` for deterministic setup.
- Run `scripts/mobile-build-check` before release-impacting PRs.
- Follow runbooks in `docs/runbooks/` for release and incident operations.
- Follow the step-by-step launch sequence in `docs/zero-to-launch-checklist.md`.

## Validation

- Local setup: `scripts/doctor`, then `scripts/bootstrap`.
- Release-impacting mobile changes: `scripts/mobile-build-check`.
- CI gates: `mobile-analyze`, `mobile-generation-check`, `mobile-test`, `mobile-build-android`, and `mobile-build-ios`.
