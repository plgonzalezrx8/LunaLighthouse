# Coding Standards

## General

- Prefer existing Flutter, Provider, Hive, Dio, and GoRouter patterns over new abstractions.
- Keep phase-1 changes scoped to mobile reliability unless the task explicitly targets deferred services.
- Do not expose cloud/webhook UI or routes while `LunaFeatureFlags.cloudIntegrationsEnabled` remains false.

## Dart And Flutter

- Keep stateful module behavior in existing `ChangeNotifier` state classes.
- Keep routing centralized through `luna_lighthouse/lib/router/`.
- Preserve generated file workflow for Hive, JSON, Retrofit, environment config, and localization.
- Avoid broad barrel imports in new code when a narrower import is practical, even though legacy `core.dart` remains in use.

## TypeScript Services

- Keep notification-service and cloud-functions changes isolated from the mobile relaunch unless they are documentation or phase-2 preparation.
- Validate environment variables through the existing environment helper before service startup.
- Do not log secrets, request credentials, webhook tokens, or Firebase service-account material.

## Comments

Use comments for non-obvious rollout, platform, generation, or security constraints. Avoid comments that restate the code.
