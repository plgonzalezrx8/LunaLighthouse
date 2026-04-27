# Governance Baseline (Phase 0)

This file records the operational decisions for the LunaLighthouse mobile relaunch.

## Program Decisions

- Product name: `LunaLighthouse`
- Mobile identifier namespace: `app.lunalighthouse.lunalighthouse`
- Mobile strategy: iOS and Android first
- Deferred features for relaunch: cloud account and hosted webhooks
- Domain strategy: `*.lunalighthouse.app`

## Release Channels

- `edge`: every commit candidate for maintainers and technical testers.
- `beta`: release candidate channel for closed testing.
- `stable`: public release channel.

Non-mobile channels are frozen for phase-1 and cannot block mobile releases.

## Repository Rules

- `main` is protected and requires mobile checks.
- Ownership enforced via `CODEOWNERS`.
- Issues/PRs use root `.github` templates.
- Maintainer responsibilities are documented in `docs/maintainers.md`.
