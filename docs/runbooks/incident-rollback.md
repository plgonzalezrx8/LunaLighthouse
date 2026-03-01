# Incident and Rollback Runbook

## Severity

- `SEV-1`: widespread launch failure, data loss risk, or auth/sign-in outage.
- `SEV-2`: major workflow broken with workaround.
- `SEV-3`: non-critical regression.

## Immediate Actions

1. Assign incident commander and scribe.
2. Stop active rollout (Play staged rollout / TestFlight external rollout).
3. Communicate user impact and current mitigation status.

## Triage Checklist

- Identify first bad version/build number.
- Confirm whether issue is platform-specific.
- Check crash logs and reproducibility path.
- Verify if issue intersects deferred cloud/webhook gating.

## Rollback Paths

- Android: reduce/stop rollout and promote previous stable AAB.
- iOS: pause external testing or submit hotfix build; direct testers to previous build when possible.

## Post-Incident Requirements

- Write incident summary (timeline, root cause, fix, follow-up tasks).
- Add regression test or validation step to prevent recurrence.
- Update release runbook if process gap was identified.
