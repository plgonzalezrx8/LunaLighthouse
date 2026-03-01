# Release Channels

## Active Channels (Phase 1)

- `edge`: commit-level technical validation builds.
- `beta`: pre-release validation builds.
- `stable`: production release builds.

## Frozen Channels

Non-mobile platform release channels are frozen during phase-1 and are not release-blocking.

## Promotion Policy

1. Build lands in `edge`.
2. Move to `beta` after baseline checks pass.
3. Promote to `stable` after beta defect budget is cleared.
