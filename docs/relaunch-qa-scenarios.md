# Relaunch QA Scenarios

Use these checks for beta and production go/no-go decisions.

1. Android debug/release builds install successfully with `LunaLighthouse` name and icon.
2. iOS debug/release/TestFlight builds install successfully with `LunaLighthouse` name and icon.
3. Core in-app strings and permission prompts show `LunaLighthouse` (no user-visible `LunaLighthouse` leakage).
4. App links resolve to `lunalighthouse.app` domains.
5. Cloud/webhook paths are gated and do not produce dead-end runtime failures.
6. Core module connectivity works (Lidarr/Radarr/Sonarr/NZBGet/SABnzbd/Tautulli/WOL).
7. Local backup/restore works within LunaLighthouse builds.
8. CI runs from LunaLighthouse-owned workflows without upstream workflow dependencies.
9. Signed artifacts can be uploaded to Play internal track and TestFlight.
10. Frozen non-mobile targets do not block mobile release gates.
