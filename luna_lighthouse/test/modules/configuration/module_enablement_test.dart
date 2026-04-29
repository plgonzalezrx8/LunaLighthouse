import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:luna_lighthouse/database/box.dart';
import 'package:luna_lighthouse/database/models/external_module.dart';
import 'package:luna_lighthouse/database/models/indexer.dart';
import 'package:luna_lighthouse/database/models/profile.dart';
import 'package:luna_lighthouse/database/table.dart';
import 'package:luna_lighthouse/database/tables/luna_lighthouse.dart';
import 'package:luna_lighthouse/modules.dart';
import 'package:luna_lighthouse/modules/dashboard/core/state.dart';
import 'package:luna_lighthouse/modules/lidarr/core/state.dart';
import 'package:luna_lighthouse/modules/nzbget/core/state.dart';
import 'package:luna_lighthouse/modules/radarr/core/state.dart';
import 'package:luna_lighthouse/modules/sabnzbd/core/state.dart';
import 'package:luna_lighthouse/modules/search/core/state.dart';
import 'package:luna_lighthouse/modules/settings/core/state.dart';
import 'package:luna_lighthouse/modules/sonarr/core/state.dart';
import 'package:luna_lighthouse/modules/tautulli/core/state.dart';
import 'package:luna_lighthouse/system/state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory hiveDirectory;

  setUpAll(() async {
    hiveDirectory =
        Directory.systemTemp.createTempSync('luna_module_enablement_test_');
    Hive.init(hiveDirectory.path);
    LunaTable.register();
    await LunaBox.open();
  });

  setUp(() async {
    for (final box in LunaBox.values) {
      await box.clear();
    }
    await _saveProfile(LunaProfile());
  });

  tearDownAll(() {
    // Keep Hive open. App code uses fire-and-forget writes in table updates,
    // and closing Hive here can hang this widget-test process.
  });

  group('LunaModule.active', () {
    test('contains only launch-visible feature-flagged modules', () {
      final active = LunaModule.active;

      expect(active, isNot(contains(LunaModule.DASHBOARD)));
      expect(active, isNot(contains(LunaModule.SETTINGS)));
      expect(active, isNot(contains(LunaModule.OVERSEERR)));
      expect(
          active,
          containsAll(<LunaModule>[
            LunaModule.EXTERNAL_MODULES,
            LunaModule.LIDARR,
            LunaModule.NZBGET,
            LunaModule.RADARR,
            LunaModule.SABNZBD,
            LunaModule.SEARCH,
            LunaModule.SONARR,
            LunaModule.TAUTULLI,
          ]));
      expect(active.every((module) => module.featureFlag), isTrue);
      expect(
        active.contains(LunaModule.WAKE_ON_LAN),
        equals(LunaModule.WAKE_ON_LAN.featureFlag),
      );
    });
  });

  group('LunaModule.isEnabled', () {
    test('keeps only dashboard and settings enabled for an empty profile',
        () async {
      expect(LunaModule.DASHBOARD.isEnabled, isTrue);
      expect(LunaModule.SETTINGS.isEnabled, isTrue);
      expect(LunaModule.LIDARR.isEnabled, isFalse);
      expect(LunaModule.NZBGET.isEnabled, isFalse);
      expect(LunaModule.RADARR.isEnabled, isFalse);
      expect(LunaModule.SABNZBD.isEnabled, isFalse);
      expect(LunaModule.SEARCH.isEnabled, isFalse);
      expect(LunaModule.SONARR.isEnabled, isFalse);
      expect(LunaModule.TAUTULLI.isEnabled, isFalse);
      expect(LunaModule.EXTERNAL_MODULES.isEnabled, isFalse);
    });

    test('reflects profile-backed module enablement flags', () async {
      await _saveProfile(LunaProfile(
        lidarrEnabled: true,
        nzbgetEnabled: true,
        radarrEnabled: true,
        sabnzbdEnabled: true,
        sonarrEnabled: true,
        tautulliEnabled: true,
        wakeOnLANEnabled: true,
      ));

      expect(LunaModule.LIDARR.isEnabled, isTrue);
      expect(LunaModule.NZBGET.isEnabled, isTrue);
      expect(LunaModule.RADARR.isEnabled, isTrue);
      expect(LunaModule.SABNZBD.isEnabled, isTrue);
      expect(LunaModule.SONARR.isEnabled, isTrue);
      expect(LunaModule.TAUTULLI.isEnabled, isTrue);
      expect(LunaModule.WAKE_ON_LAN.isEnabled, isTrue);
    });

    test('enables search and external modules from their backing boxes',
        () async {
      expect(LunaModule.SEARCH.isEnabled, isFalse);
      expect(LunaModule.EXTERNAL_MODULES.isEnabled, isFalse);

      await LunaBox.indexers.create(LunaIndexer(displayName: 'Local Indexer'));
      await LunaBox.externalModules.create(
        LunaExternalModule(displayName: 'Local Tool', host: 'http://tool.test'),
      );

      expect(LunaModule.SEARCH.isEnabled, isTrue);
      expect(LunaModule.EXTERNAL_MODULES.isEnabled, isTrue);
    });
  });

  group('LunaState provider registry', () {
    testWidgets('wires supported modules to concrete state providers',
        (tester) async {
      late BuildContext providerContext;

      await tester.pumpWidget(
        LunaState.providers(
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                providerContext = context;
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      expect(
          LunaModule.DASHBOARD.state(providerContext), isA<DashboardState>());
      expect(LunaModule.SETTINGS.state(providerContext), isA<SettingsState>());
      expect(LunaModule.SEARCH.state(providerContext), isA<SearchState>());
      expect(LunaModule.LIDARR.state(providerContext), isA<LidarrState>());
      expect(LunaModule.RADARR.state(providerContext), isA<RadarrState>());
      expect(LunaModule.SONARR.state(providerContext), isA<SonarrState>());
      expect(LunaModule.NZBGET.state(providerContext), isA<NZBGetState>());
      expect(LunaModule.SABNZBD.state(providerContext), isA<SABnzbdState>());
      expect(LunaModule.TAUTULLI.state(providerContext), isA<TautulliState>());
      expect(LunaModule.WAKE_ON_LAN.state(providerContext), isNull);
      expect(LunaModule.OVERSEERR.state(providerContext), isNull);
      expect(LunaModule.EXTERNAL_MODULES.state(providerContext), isNull);

      expect(() => LunaState.reset(providerContext), returnsNormally);
    });
  });

  group('LunaModule.isEnabled toggling', () {
    test('disabling a previously enabled module reflects in isEnabled',
        () async {
      // Enable Radarr then disable it; isEnabled must track the current profile.
      await _saveProfile(LunaProfile(radarrEnabled: true));
      expect(LunaModule.RADARR.isEnabled, isTrue);

      await _saveProfile(LunaProfile(radarrEnabled: false));
      expect(LunaModule.RADARR.isEnabled, isFalse);
    });

    test('removing all indexers disables search', () async {
      // Pre-condition: add an indexer so search is enabled.
      await LunaBox.indexers.create(LunaIndexer(displayName: 'Test Indexer'));
      expect(LunaModule.SEARCH.isEnabled, isTrue);

      // Remove the indexer; search should become disabled again.
      await LunaBox.indexers.clear();
      expect(LunaModule.SEARCH.isEnabled, isFalse);
    });

    test('removing all external modules disables external_modules', () async {
      await LunaBox.externalModules.create(
        LunaExternalModule(displayName: 'My Tool', host: 'http://tool.test'),
      );
      expect(LunaModule.EXTERNAL_MODULES.isEnabled, isTrue);

      await LunaBox.externalModules.clear();
      expect(LunaModule.EXTERNAL_MODULES.isEnabled, isFalse);
    });
  });

  group('LunaModule.active shape', () {
    test('active list contains no duplicate modules', () {
      final active = LunaModule.active;
      expect(active.toSet().length, equals(active.length));
    });

    test('active list contains only known module values', () {
      final allValues = LunaModule.values.toSet();
      for (final module in LunaModule.active) {
        expect(allValues, contains(module));
      }
    });
  });
}

Future<void> _saveProfile(LunaProfile profile) async {
  await LunaBox.profiles.update(LunaProfile.DEFAULT_PROFILE, profile);
  LunaLighthouseDatabase.ENABLED_PROFILE.update(LunaProfile.DEFAULT_PROFILE);
}
