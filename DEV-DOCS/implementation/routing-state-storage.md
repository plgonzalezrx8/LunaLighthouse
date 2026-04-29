# Routing, State, and Storage

## Routing

`LunaRouter.initialize()` in `luna_lighthouse/lib/router/router.dart` constructs the app `GoRouter` with:

- A global navigator key.
- `ErrorRoutePage` for route errors.
- `LunaRoutes.initialLocation`.
- Route trees from `LunaRoutes.values`.

`LunaRoutesMixin` in `luna_lighthouse/lib/router/routes.dart` wraps route builders with module enablement checks and shows `NotEnabledPage` when a route's module is unavailable.

## State

`LunaState.providers()` in `luna_lighthouse/lib/system/state.dart` registers app-wide `ChangeNotifierProvider` instances for Dashboard, Settings, Search, Lidarr, Radarr, Sonarr, NZBGet, SABnzbd, and Tautulli.

`LunaModule.state()` in `luna_lighthouse/lib/modules.dart` maps supported modules back to their Provider state when a reset or module-scoped action needs it.

## Storage

`LunaDatabase.initialize()` in `luna_lighthouse/lib/database/database.dart` initializes Hive, registers tables, opens boxes, and bootstraps a default profile if needed.

`LunaBox` in `luna_lighthouse/lib/database/box.dart` owns the app boxes:

- `alerts`
- `external_modules`
- `indexers`
- `logs`
- `luna_lighthouse`
- `profiles`

