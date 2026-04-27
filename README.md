# <img width="40px" src="./luna_lighthouse/assets/images/branding_logo.png" alt="LunaLighthouse"></img>&nbsp;&nbsp;LunaLighthouse

LunaLighthouse is an actively maintained, mobile-first self-hosted controller project.

## Repository Layout

- `luna_lighthouse/`: Flutter application (iOS/Android relaunch priority)
- `luna_lighthouse-docs/`: end-user documentation
- `luna_lighthouse-notification-service/`: hosted notification relay (phase-2 re-enable)
- `luna_lighthouse-cloud-functions/`: cloud support services (phase-2 re-enable)
- `docs/`: maintainer governance, runbooks, and operational checklists

## Phase-1 Relaunch Scope

- Primary focus: iOS and Android app reliability, signing, and store releases.
- Cloud account and hosted webhook features: deferred and feature-gated off.
- Non-mobile distribution targets: frozen for release gating in phase 1.

## Maintainer Workflow

- Run `scripts/bootstrap` for deterministic setup.
- Run `scripts/mobile-build-check` before release-impacting PRs.
- Follow runbooks in `docs/runbooks/` for release and incident operations.
- Follow the step-by-step launch sequence in `docs/zero-to-launch-checklist.md`.
