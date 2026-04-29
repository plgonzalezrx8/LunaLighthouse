import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:luna_lighthouse/database/box.dart';
import 'package:luna_lighthouse/database/models/profile.dart';
import 'package:luna_lighthouse/database/table.dart';
import 'package:luna_lighthouse/database/tables/luna_lighthouse.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory hiveDirectory;

  setUpAll(() async {
    hiveDirectory =
        Directory.systemTemp.createTempSync('luna_profile_storage_test_');
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
    // Keep Hive open to match existing widget/module tests. Some app writes are
    // intentionally fire-and-forget, and closing Hive can hang the test process.
  });

  test('current profile falls back safely when the selected profile is missing',
      () async {
    await LunaBox.luna_lighthouse.update(
      LunaLighthouseDatabase.ENABLED_PROFILE.key,
      'missing-profile',
    );

    final current = LunaProfile.current;

    expect(current.lidarrEnabled, isFalse);
    expect(current.radarrHost, isEmpty);
    expect(current.nzbgetPass, isEmpty);
    expect(current.tautulliHeaders, isEmpty);
  });

  test('current profile reads the selected Hive-backed profile', () async {
    await LunaBox.profiles.update('primary', _profileWithStoredSecrets());
    await LunaBox.luna_lighthouse.update(
      LunaLighthouseDatabase.ENABLED_PROFILE.key,
      'primary',
    );

    final current = LunaProfile.current;

    expect(current.radarrEnabled, isTrue);
    expect(current.radarrHost, equals('https://radarr.example.test'));
    expect(current.radarrKey, equals('radarr-key'));
    expect(current.radarrHeaders, equals({'X-Radarr-Token': 'radarr-token'}));
    expect(current.nzbgetUser, equals('nzbget-user'));
    expect(current.nzbgetPass, equals('nzbget-password'));
  });

  test('profile box export includes stored profile configuration', () async {
    await LunaBox.profiles.update(
      LunaProfile.DEFAULT_PROFILE,
      _profileWithStoredSecrets(),
    );

    final exported = LunaBox.profiles.export();

    expect(exported, hasLength(1));
    expect(exported.single['radarrHost'], equals('https://radarr.example.test'));
    expect(exported.single['radarrHeaders'],
        equals(<String, String>{'X-Radarr-Token': 'radarr-token'}));
    expect(exported.single['nzbgetPass'], equals('nzbget-password'));
  });
}

LunaProfile _profileWithStoredSecrets() {
  return LunaProfile(
    radarrEnabled: true,
    radarrHost: 'https://radarr.example.test',
    radarrKey: 'radarr-key',
    radarrHeaders: const <String, String>{'X-Radarr-Token': 'radarr-token'},
    nzbgetEnabled: true,
    nzbgetHost: 'https://nzbget.example.test',
    nzbgetUser: 'nzbget-user',
    nzbgetPass: 'nzbget-password',
    nzbgetHeaders: const <String, String>{'X-NZBGet-Token': 'nzbget-token'},
  );
}
