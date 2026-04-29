# Architecture Overview

## Current Phase Boundary

LunaLighthouse phase-1 relaunch is mobile-first:

- Active runtime scope: Flutter app for iOS/Android.
- Phase-2/deferred runtime scope: hosted cloud account features and webhook relay dependency paths.
- Frozen scope: non-mobile distribution targets (Linux/macOS/Web/Windows) for release gating.

## Repository Topology

- `luna_lighthouse/`: primary Flutter application and mobile CI/CD workflows.
- `luna_lighthouse-docs/`: user documentation content.
- `luna_lighthouse-notification-service/`: webhook relay service (phase-2/deferred runtime).
- `luna_lighthouse-cloud-functions/`: cloud function support services (phase-2/deferred runtime).
- `DEV-DOCS/`: engineering handoff docs for active implementation and recovery context.

## Data and Control Flow (Phase 1)

1. User configures local service endpoints in mobile app.
2. App communicates directly with supported service APIs (Lidarr/Radarr/Sonarr/etc.).
3. User backup/restore remains local-device workflow.
4. Cloud account and hosted webhook routes are feature-gated off.

## Deferred Reactivation Boundary

Cloud/webhook re-enable requires separate go/no-go criteria:

- supported runtime upgrades (Node/Firebase/tooling),
- secrets and infra ownership transfer,
- security review and incident runbook validation,
- end-to-end integration tests on production-like infrastructure.
