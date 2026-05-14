# Supported Modules

## Module Registry

Supported modules are declared by `LunaModule` in `luna_lighthouse/lib/modules.dart`. The current enum includes:

- `DASHBOARD`
- `EXTERNAL_MODULES`
- `LIDARR`
- `NZBGET`
- `OVERSEERR`
- `RADARR`
- `SABNZBD`
- `SEARCH`
- `SETTINGS`
- `SONARR`
- `TAUTULLI`
- `WAKE_ON_LAN`

## Enabled Surface

`LunaModule.active` excludes Dashboard and Settings, then filters by each module's `featureFlag`. Most modules return `true`; Overseerr currently returns `false`, and Wake on LAN depends on `LunaWakeOnLAN.isSupported`.

Runtime enablement is profile-backed through `LunaProfile.current` for Lidarr, Radarr, Sonarr, NZBGet, SABnzbd, Tautulli, Overseerr, Wake on LAN, and external modules. Search is enabled when `LunaBox.indexers` is not empty.

## State and Routes

Provider-backed state exists for Dashboard, Settings, Search, Lidarr, Radarr, Sonarr, NZBGet, SABnzbd, and Tautulli in `luna_lighthouse/lib/system/state.dart`. Route roots are registered in `luna_lighthouse/lib/router/routes.dart`; Overseerr and Wake on LAN do not currently have route roots in that enum.
