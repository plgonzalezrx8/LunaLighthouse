# Notifications

Hosted webhook relay notifications are **temporarily unavailable** in the phase-1 Lunarr relaunch.

{% hint style="warning" %}
Cloud account and hosted webhook flows are intentionally gated off while backend/runtime ownership migration is completed.
{% endhint %}

## Current Phase Behavior

- No in-app hosted webhook URL flow is exposed for production relaunch builds.
- Existing webhook setup guides are retained in this section for phase-2 reactivation work.
- Core module functionality remains available without notification relay features.

## Future Endpoint Contract (Phase 2)

When notifications are re-enabled, Lunarr will use:

- `https://notify.lunarr.app/v1/{module}/user/{token}`
- `https://notify.lunarr.app/v1/{module}/device/{token}`

Do not rely on hosted notification behavior until the phase-2 announcement is published.
