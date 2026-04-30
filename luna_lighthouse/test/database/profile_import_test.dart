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
}

Future<void> _importConfig(
  Map<String, dynamic> config,
) async {
  await _importRawConfig(json.encode(config));
}

Future<void> _importRawConfig(String config) async {
  await LunaConfig().import(null, config, resetState: false);
}
