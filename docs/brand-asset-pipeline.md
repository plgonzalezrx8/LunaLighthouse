# Brand Asset Pipeline

## Source of Truth

- Versioned source packs live in `brand-assets/`.
- Current placeholder pack: `brand-assets/v1-placeholder/`.

## Generation Workflow

1. Update source files in a new versioned pack.
2. Export required icon/splash inputs into `lunasea/assets/icon/` and `lunasea/assets/images/`.
3. Run `scripts/generate-brand-assets`.
4. Verify regenerated assets on Android and iOS simulator/device.

## Guardrails

- Do not manually edit generated platform icon outputs.
- All brand asset updates must include before/after screenshots in PR.
- Production launch requires final reviewed asset pack (not placeholder).
