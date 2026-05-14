# Review Policy

## Branch Strategy

- `development`: active integration branch for mobile relaunch work.
- `master`: protected release branch.
- `features/*`: implementation branches for rebrand and mobile recovery work, merged through `development`.
- `hotfix/*`: emergency production fixes, merged into `master` and then back into `development` immediately.

## Required Checks (Mobile-First)

The following checks should be required on `master` and run on `development`:

1. `mobile-analyze`
2. `mobile-generation-check`
3. `mobile-test`
4. `mobile-build-android`
5. `mobile-build-ios` (required when macOS runner capacity exists)

Non-mobile checks remain optional during phase-1 relaunch.

## Pull Request Requirements

- At least one maintainer approval.
- Passing required mobile checks.
- Updated documentation when behavior or release process changes.
- Clear risk statement for user-facing changes.

## Merge Rules

- Squash-merge by default to keep release history readable.
- Do not merge PRs with failing required checks.
- Do not bypass review for branding, signing, routing, or domain changes.
