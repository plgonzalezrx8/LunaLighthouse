import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:luna_lighthouse/database/box.dart';
import 'package:luna_lighthouse/database/config.dart';
import 'package:luna_lighthouse/database/models/profile.dart';
import 'package:luna_lighthouse/database/table.dart';
import 'package:luna_lighthouse/database/tables/luna_lighthouse.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory hiveDirectory;

  setUpAll(() async {
    hiveDirectory =
        Directory.systemTemp.createTempSync('luna_profile_import_test_');
    Hive.init(hiveDirectory.path);
    LunaTable.register();
    await LunaBox.open();
  });

  setUp(() async {
    for (final box in LunaBox.values) {
      await box.clear();
    }
  });

  tearDownAll(() {
    // Keep Hive open to match the existing database/widget test suites. Some
    // app writes are intentionally fire-and-forget, and closing Hive can hang.
  });

  test('imports a legacy profile without key as the default profile', () async {
    await _importConfig(
      <String, dynamic>{
        LunaBox.profiles.key: [
          <String, dynamic>{
            'radarrEnabled': true,
            'radarrHost': 'https://radarr.example.test',
            'radarrKey': 'radarr-key',
          },
        ],
      },
    );

    expect(LunaProfile.list, equals([LunaProfile.DEFAULT_PROFILE]));

    final imported = LunaProfile.current;
    expect(imported.radarrEnabled, isTrue);
    expect(imported.radarrHost, equals('https://radarr.example.test'));
    expect(imported.radarrKey, equals('radarr-key'));
  });

  test('imports partial legacy profiles with safe header defaults', () async {
    await _importConfig(
      <String, dynamic>{
        LunaBox.profiles.key: [
          <String, dynamic>{
            'key': 'legacy',
            'sonarrEnabled': true,
            'sonarrHost': 'https://sonarr.example.test',
            'sonarrKey': 'sonarr-key',
          },
        ],
        LunaTable.luna_lighthouse.key: <String, dynamic>{
          LunaLighthouseDatabase.ENABLED_PROFILE.key: 'legacy',
        },
      },
    );

    final imported = LunaProfile.current;
    expect(imported.sonarrEnabled, isTrue);
    expect(imported.sonarrHost, equals('https://sonarr.example.test'));
    expect(imported.sonarrHeaders, isEmpty);
    expect(imported.radarrHeaders, isEmpty);
    expect(imported.nzbgetHeaders, isEmpty);
    expect(imported.tautulliHeaders, isEmpty);
    expect(imported.overseerrHeaders, isEmpty);
  });

  test('falls back to the first imported profile when selected is absent',
      () async {
    await _importConfig(
      <String, dynamic>{
        LunaBox.profiles.key: [
          <String, dynamic>{
            'key': 'alpha',
            'lidarrEnabled': true,
            'lidarrHost': 'https://lidarr.example.test',
          },
        ],
        LunaTable.luna_lighthouse.key: <String, dynamic>{
          LunaLighthouseDatabase.ENABLED_PROFILE.key: 'missing',
        },
      },
    );

    expect(LunaLighthouseDatabase.ENABLED_PROFILE.read(), equals('alpha'));
    expect(
        LunaProfile.current.lidarrHost, equals('https://lidarr.example.test'));
  });

  test('resets to the default profile after invalid import payloads', () async {
    await LunaBox.profiles.update(
      'existing',
      LunaProfile(radarrEnabled: true, radarrHost: 'https://old.example.test'),
    );
    LunaLighthouseDatabase.ENABLED_PROFILE.update('existing');

    await _importRawConfig('{not-json');

    expect(LunaProfile.list, equals([LunaProfile.DEFAULT_PROFILE]));
    expect(LunaLighthouseDatabase.ENABLED_PROFILE.read(),
        equals(LunaProfile.DEFAULT_PROFILE));
    expect(LunaProfile.current.radarrEnabled, isFalse);
    expect(LunaProfile.current.radarrHost, isEmpty);
  });

  // ---------------------------------------------------------------------------
  // Edge cases for nullable context + resetState parameter (config.dart change)
  // ---------------------------------------------------------------------------

  test('import with empty profiles list bootstraps the default profile',
      () async {
    await _importConfig(
      <String, dynamic>{
        LunaBox.profiles.key: <dynamic>[],
      },
    );

    expect(LunaProfile.list, equals([LunaProfile.DEFAULT_PROFILE]));
    expect(LunaLighthouseDatabase.ENABLED_PROFILE.read(),
        equals(LunaProfile.DEFAULT_PROFILE));
  });

  test('import without a profiles key bootstraps the default profile',
      () async {
    // Simulates a legacy backup that omits the profiles section entirely.
    await _importConfig(
      <String, dynamic>{
        // No 'profiles' key at all.
        LunaBox.indexers.key: <dynamic>[],
      },
    );

    expect(LunaProfile.list, equals([LunaProfile.DEFAULT_PROFILE]));
    expect(LunaLighthouseDatabase.ENABLED_PROFILE.read(),
        equals(LunaProfile.DEFAULT_PROFILE));
  });

  test('import with multiple profiles stores all of them', () async {
    await _importConfig(
      <String, dynamic>{
        LunaBox.profiles.key: [
          <String, dynamic>{
            'key': 'alpha',
            'radarrEnabled': true,
            'radarrHost': 'https://radarr.example.test',
          },
          <String, dynamic>{
            'key': 'beta',
            'sonarrEnabled': true,
            'sonarrHost': 'https://sonarr.example.test',
          },
        ],
        LunaTable.luna_lighthouse.key: <String, dynamic>{
          LunaLighthouseDatabase.ENABLED_PROFILE.key: 'alpha',
        },
      },
    );

    expect(LunaBox.profiles.size, equals(2));

    await LunaBox.luna_lighthouse
        .update(LunaLighthouseDatabase.ENABLED_PROFILE.key, 'alpha');
    expect(LunaProfile.current.radarrEnabled, isTrue);

    await LunaBox.luna_lighthouse
        .update(LunaLighthouseDatabase.ENABLED_PROFILE.key, 'beta');
    expect(LunaProfile.current.sonarrEnabled, isTrue);
  });

  test('second import clears the state written by the first import', () async {
    // Verifies that LunaDatabase().clear() is called at the start of each
    // import, so stale profiles from a previous import do not persist.
    await _importConfig(
      <String, dynamic>{
        LunaBox.profiles.key: [
          <String, dynamic>{
            'key': 'first-run',
            'radarrEnabled': true,
            'radarrHost': 'https://radarr-first.example.test',
          },
        ],
      },
    );
    expect(LunaBox.profiles.size, equals(1));

    await _importConfig(
      <String, dynamic>{
        LunaBox.profiles.key: [
          <String, dynamic>{
            'key': 'second-run',
            'sonarrEnabled': true,
            'sonarrHost': 'https://sonarr-second.example.test',
          },
        ],
        LunaTable.luna_lighthouse.key: <String, dynamic>{
          LunaLighthouseDatabase.ENABLED_PROFILE.key: 'second-run',
        },
      },
    );

    // The 'first-run' profile must be gone after the second import.
    expect(LunaBox.profiles.size, equals(1));
    expect(LunaBox.profiles.read('first-run'), isNull);
    expect(LunaProfile.current.sonarrEnabled, isTrue);
  });

  test('resetState: false skips LunaState.reset so no context is needed',
      () async {
    // This is the main use-case for the new nullable-context + resetState param.
    // Calling with null context and resetState: false must not throw.
    await expectLater(
      LunaConfig().import(
          null,
          json.encode(<String, dynamic>{
            LunaBox.profiles.key: [
              <String, dynamic>{
                'key': 'no-reset',
                'nzbgetEnabled': true,
                'nzbgetHost': 'https://nzbget.example.test',
              },
            ],
          }),
          resetState: false),
      completes,
    );

    expect(LunaProfile.current.nzbgetEnabled, isTrue);
  });

  test('malformed JSON resets the database to a safe default state', () async {
    // Pre-condition: write a profile so there is something to lose.
    await LunaBox.profiles.update(
      'will-be-lost',
      LunaProfile(
          tautulliEnabled: true, tautulliHost: 'https://old.example.test'),
    );
    LunaLighthouseDatabase.ENABLED_PROFILE.update('will-be-lost');

    await _importRawConfig('{{bad json}}');

    // After a failed import, the database must be bootstrapped to defaults.
    expect(LunaProfile.list, equals([LunaProfile.DEFAULT_PROFILE]));
    expect(LunaProfile.current.tautulliEnabled, isFalse);
    expect(LunaProfile.current.tautulliHost, isEmpty);
  });
}

Future<void> _importConfig(Map<String, dynamic> config) async {
  await _importRawConfig(json.encode(config));
}

Future<void> _importRawConfig(String config) async {
  await LunaConfig().import(null, config, resetState: false);
}
