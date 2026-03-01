# Lunarr Brand Assets

This folder stores versioned brand source assets used to generate platform icons/splash assets.

## Versioning

- Create one folder per release set (`v1-placeholder`, `v2-launch`, ...).
- Never overwrite previous versions; add a new version folder.
- Include source files (`.svg`, `.fig`, or high-res `.png`) and export notes.

## Required Source Artifacts

- `logo_master` (horizontal lockup)
- `icon_master` (square app icon source)
- `icon_adaptive_foreground`
- `icon_adaptive_background`
- `splash_art`
- `notification_icon`
- `store_hero`

## Integration

Generated app assets are built from `lunasea/assets/icon/*` and `lunasea/assets/images/*`.
Run `scripts/generate-brand-assets` after updating source files.
