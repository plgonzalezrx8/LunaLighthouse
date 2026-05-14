# Release Channels

## Channels

The public docs define three active phase-1 channels in `luna_lighthouse-docs/getting-started/build-channels.md`:

- Stable: store-quality releases with no in-progress features.
- Beta: early previews for work-in-progress feature testing.
- Edge: per-commit/candidate builds for maintainers and technical testers.

## Build Metadata

`luna_lighthouse/environment_config.yaml` defines generated environment fields for `BUILD`, `COMMIT`, and `FLAVOR`, with a default flavor of `edge`.

`luna_lighthouse/package.json` includes empty-commit helpers for TestFlight channel markers:

- `release:flavor:edge`
- `release:flavor:beta`

## Artifact Expectations

The public build-channel docs point users to `https://builds.lunalighthouse.app/` for channel artifacts and to GitHub releases for stable artifacts. Edge builds may include unfinished work and should not be presented as stable.
