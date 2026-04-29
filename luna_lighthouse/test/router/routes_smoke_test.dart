import 'package:flutter_test/flutter_test.dart';
import 'package:luna_lighthouse/modules.dart';
import 'package:luna_lighthouse/router/routes.dart';
import 'package:luna_lighthouse/router/routes/bios.dart';

void main() {
  group('LunaRoutes registry', () {
    test('starts at the BIOS route', () {
      expect(LunaRoutes.initialLocation, equals(BIOSRoutes.HOME.path));
      expect(LunaRoutes.initialLocation, equals('/'));
    });

    test('registers each root route with an absolute unique path', () {
      final rootPaths = LunaRoutes.values.map((route) => route.root.path);

      expect(rootPaths, everyElement(startsWith('/')));
      expect(rootPaths.toSet(), hasLength(LunaRoutes.values.length));
      expect(
        rootPaths,
        containsAll(<String>{
          '/',
          '/dashboard',
          '/external_modules',
          '/lidarr',
          '/nzbget',
          '/radarr',
          '/sabnzbd',
          '/search',
          '/settings',
          '/sonarr',
          '/tautulli',
        }),
      );
    });

    test('builds a GoRoute object for every registered root', () {
      for (final route in LunaRoutes.values) {
        final goRoute = route.root.routes;

        expect(goRoute.path, equals(route.root.path), reason: route.key);
        expect(goRoute.name, isNotEmpty, reason: route.key);
      }
    });
  });

  group('LunaModule route metadata', () {
    test('keeps module keys round-trippable', () {
      for (final module in LunaModule.values) {
        expect(LunaModule.fromKey(module.key), equals(module), reason: module.key);
      }

      expect(LunaModule.fromKey('unknown'), isNull);
      expect(LunaModule.fromKey(null), isNull);
    });

    test('maps routed modules to registered root paths', () {
      expect(LunaModule.DASHBOARD.homeRoute, equals('/dashboard'));
      expect(LunaModule.EXTERNAL_MODULES.homeRoute, equals('/external_modules'));
      expect(LunaModule.LIDARR.homeRoute, equals('/lidarr'));
      expect(LunaModule.NZBGET.homeRoute, equals('/nzbget'));
      expect(LunaModule.RADARR.homeRoute, equals('/radarr'));
      expect(LunaModule.SABNZBD.homeRoute, equals('/sabnzbd'));
      expect(LunaModule.SEARCH.homeRoute, equals('/search'));
      expect(LunaModule.SETTINGS.homeRoute, equals('/settings'));
      expect(LunaModule.SONARR.homeRoute, equals('/sonarr'));
      expect(LunaModule.TAUTULLI.homeRoute, equals('/tautulli'));
    });

    test('leaves unavailable phase-one modules without root routes', () {
      expect(LunaModule.OVERSEERR.homeRoute, isNull);
      expect(LunaModule.WAKE_ON_LAN.homeRoute, isNull);
    });
  });
}
