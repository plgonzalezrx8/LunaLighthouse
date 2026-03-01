# Commenting Standard

This repository requires concise explanatory comments for non-obvious logic in changed code.

## Required

- Add comments when behavior is surprising, risk-sensitive, or tightly coupled to platform constraints.
- Explain intent and invariants, not obvious syntax.
- Keep comments short and current.

## Avoid

- Restating what code already makes obvious.
- Leaving stale comments after refactors.
- Using comments instead of clear naming or decomposition.

## Review Rule

PR reviewers should request comment additions when changed logic would be hard to maintain without context.
