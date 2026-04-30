# Flutter Generation

## Generated Inputs

The Flutter app lives in `luna_lighthouse/`. Generation tasks are declared in `luna_lighthouse/package.json`:

- `generate:environment` runs `dart run environment_config:generate`.
- `generate:assets` runs `spider build`.
- `generate:build_runner` runs `dart run build_runner build --delete-conflicting-outputs`.
- `generate:localization` runs `dart ./scripts/generate_localization.dart`.
- `generate` runs all of the above in order.

## Generated Outputs

The app uses generated code for environment configuration, Hive adapters, Retrofit clients, JSON models, assets, and localization. `luna_lighthouse/pubspec.yaml` includes the relevant generator packages: `environment_config`, `hive_generator`, `retrofit_generator`, `json_serializable`, and `build_runner`.

## Relaunch Notes

Generation should be run from `luna_lighthouse/` after model, API, environment, asset, or localization changes. Documentation-only changes in `DEV-DOCS/` do not require generation.

