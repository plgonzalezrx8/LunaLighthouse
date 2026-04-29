# Governance Baseline (Phase 0)

This file records the operational decisions for the LunaLighthouse mobile relaunch.

## Program Decisions

- Product name: `LunaLighthouse`
- Mobile identifier namespace: `app.lunalighthouse.lunalighthouse`
- Mobile strategy: iOS and Android first
- Phase-2/deferred features for relaunch: cloud account and hosted webhooks
- Domain strategy: `*.lunalighthouse.app`

## Release Channels

- `edge`: every commit candidate for maintainers and technical testers.
- `beta`: release candidate channel for closed testing.
- `stable`: public release channel.

Non-mobile channels are frozen for phase-1 and cannot block mobile releases.

## Repository Rules

- `development` is the active integration branch for relaunch work.
- `master` is the protected release branch and requires mobile checks.
- Ownership enforced via `CODEOWNERS`.
- Issues/PRs use root `.github` templates.
- Maintainer responsibilities are documented in `docs/maintainers.md`.
