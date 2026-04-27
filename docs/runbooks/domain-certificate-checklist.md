# Domain and Certificate Ownership Checklist

## Required Domains

- `www.lunalighthouse.app`
- `docs.lunalighthouse.app`
- `builds.lunalighthouse.app`
- `notify.lunalighthouse.app`

## Ownership Checks

- [ ] Registrar account is controlled by LunaLighthouse maintainer org.
- [ ] DNS provider account ownership is documented.
- [ ] Recovery email and MFA ownership are documented.

## TLS and Certificates

- [ ] Certificate issuance and renewal owner identified.
- [ ] Expiry alerting configured.
- [ ] Automated renewal process tested.

## Service Mapping

- [ ] `www.lunalighthouse.app` -> primary web presence.
- [ ] `docs.lunalighthouse.app` -> documentation hosting.
- [ ] `builds.lunalighthouse.app` -> release artifact index/bucket.
- [ ] `notify.lunalighthouse.app` -> webhook relay host (deferred in phase 1).

## Validation Cadence

- Run this checklist before every stable mobile release.
