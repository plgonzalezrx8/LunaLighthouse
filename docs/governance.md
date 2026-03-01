# Governance Baseline (Phase 0)

This file records the operational decisions for the Lunarr mobile relaunch.

## Program Decisions

- Product name: `Lunarr`
- Mobile identifier namespace: `app.lunarr.lunarr`
- Mobile strategy: iOS and Android first
- Deferred features for relaunch: cloud account and hosted webhooks
- Domain strategy: `*.lunarr.app`

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
