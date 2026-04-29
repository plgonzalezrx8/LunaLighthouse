# Git Workflow

## Branch Model

- `development`: active integration branch.
- `master`: protected/release branch.
- Feature branches: use a scoped prefix such as `features/<topic>` or the existing project-specific Codex branch pattern.
- Hotfix branches: branch from `master`, merge back to `master`, then sync into `development`.

## Pull Requests

- Use PRs for behavior, CI, release, signing, routing, and documentation changes.
- Require mobile CI checks for release-impacting changes.
- Update DEV-DOCS when code changes alter architecture, behavior, security posture, tests, CI, or operations.

## Merge Expectations

- Keep generated files committed when generation commands change outputs.
- Avoid unrelated refactors in release-readiness fixes.
- Do not bypass review for signing, domain, cloud/webhook, or branch-policy changes.
