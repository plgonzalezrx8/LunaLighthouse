# Security Guidelines

## Current Trust Boundaries

- Mobile app talks directly to user-configured self-hosted services using stored hosts, API keys, and custom headers.
- Cloud account and hosted webhook paths are deferred and should not be treated as active production flows.
- Notification relay and cloud functions require Firebase, Redis, API keys, domain ownership, and secrets before reactivation.

## Secrets

- Never commit Android keystores, `key.properties`, Apple signing credentials, Firebase service-account keys, Redis credentials, TMDB keys, Fanart.tv keys, or GitHub secrets.
- GitHub Actions release secrets are documented in `docs/owner-requirements.md`.
- Notification-service runtime secrets are documented by `luna_lighthouse-notification-service/.env.sample` and `DEV-DOCS/ENV-CONTRACT.md`.

## Mobile Storage

Profiles store service hosts, API keys, and custom headers through Hive-backed models. Treat changes to profile storage, backup, restore, or migration as security-sensitive.

## Deferred Webhook Reactivation Requirements

Before enabling hosted webhooks:

- Finish and review webhook authentication.
- Redact request headers and token-like fields from logs.
- Validate Redis TLS/password configuration.
- Validate Firebase IAM, service-account scope, Firestore paths, Messaging access, and backup bucket access.
- Run E2E tests against production-like infrastructure.
