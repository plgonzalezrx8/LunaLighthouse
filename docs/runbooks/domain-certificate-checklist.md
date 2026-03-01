# Domain and Certificate Ownership Checklist

## Required Domains

- `www.lunarr.app`
- `docs.lunarr.app`
- `builds.lunarr.app`
- `notify.lunarr.app`

## Ownership Checks

- [ ] Registrar account is controlled by Lunarr maintainer org.
- [ ] DNS provider account ownership is documented.
- [ ] Recovery email and MFA ownership are documented.

## TLS and Certificates

- [ ] Certificate issuance and renewal owner identified.
- [ ] Expiry alerting configured.
- [ ] Automated renewal process tested.

## Service Mapping

- [ ] `www.lunarr.app` -> primary web presence.
- [ ] `docs.lunarr.app` -> documentation hosting.
- [ ] `builds.lunarr.app` -> release artifact index/bucket.
- [ ] `notify.lunarr.app` -> webhook relay host (deferred in phase 1).

## Validation Cadence

- Run this checklist before every stable mobile release.
