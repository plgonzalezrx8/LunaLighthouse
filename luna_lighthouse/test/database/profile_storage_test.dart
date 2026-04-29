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
    expect(
        exported.single['radarrHost'], equals('https://radarr.example.test'));
    expect(exported.single['radarrHeaders'],
        equals(<String, String>{'X-Radarr-Token': 'radarr-token'}));
    expect(exported.single['nzbgetPass'], equals('nzbget-password'));
  });

  test('multiple profiles coexist in the profile box', () async {
    final profileA = LunaProfile(
      radarrEnabled: true,
      radarrHost: 'https://radarr-a.example.test',
      radarrKey: 'radarr-a-key',
    );
    final profileB = LunaProfile(
      sonarrEnabled: true,
      sonarrHost: 'https://sonarr-b.example.test',
      sonarrKey: 'sonarr-b-key',
    );

    await LunaBox.profiles.update('profile-a', profileA);
    await LunaBox.profiles.update('profile-b', profileB);

    // Selecting profile-a should return profile-a fields.
    await LunaBox.luna_lighthouse.update(
      LunaLighthouseDatabase.ENABLED_PROFILE.key,
      'profile-a',
    );
    final readA = LunaProfile.current;
    expect(readA.radarrEnabled, isTrue);
    expect(readA.radarrHost, equals('https://radarr-a.example.test'));
    expect(readA.sonarrEnabled, isFalse);

    // Switching to profile-b should return profile-b fields.
    await LunaBox.luna_lighthouse.update(
      LunaLighthouseDatabase.ENABLED_PROFILE.key,
      'profile-b',
    );
    final readB = LunaProfile.current;
    expect(readB.sonarrEnabled, isTrue);
    expect(readB.sonarrHost, equals('https://sonarr-b.example.test'));
    expect(readB.radarrEnabled, isFalse);
  });

  test('updating an existing profile key replaces the stored value', () async {
    final initialProfile = LunaProfile(
      radarrEnabled: true,
      radarrHost: 'https://radarr-v1.example.test',
      radarrKey: 'v1-key',
    );
    await LunaBox.profiles.update(LunaProfile.DEFAULT_PROFILE, initialProfile);
    await LunaBox.luna_lighthouse.update(
      LunaLighthouseDatabase.ENABLED_PROFILE.key,
      LunaProfile.DEFAULT_PROFILE,
    );

    final v1 = LunaProfile.current;
    expect(v1.radarrHost, equals('https://radarr-v1.example.test'));

    // Overwrite with an updated host.
    final updatedProfile = LunaProfile(
      radarrEnabled: true,
      radarrHost: 'https://radarr-v2.example.test',
      radarrKey: 'v2-key',
    );
    await LunaBox.profiles.update(LunaProfile.DEFAULT_PROFILE, updatedProfile);

    final v2 = LunaProfile.current;
    expect(v2.radarrHost, equals('https://radarr-v2.example.test'));
    expect(v2.radarrKey, equals('v2-key'));
  });

  test('export reflects all stored profiles', () async {
    await LunaBox.profiles.update(
      'alpha',
      LunaProfile(lidarrEnabled: true, lidarrHost: 'https://lidarr.test'),
    );
    await LunaBox.profiles.update(
      'beta',
      LunaProfile(sonarrEnabled: true, sonarrHost: 'https://sonarr.test'),
    );

    final exported = LunaBox.profiles.export();

    expect(exported, hasLength(2));
    expect(
      exported.any((profile) => profile['lidarrHost'] == 'https://lidarr.test'),
      isTrue,
    );
    expect(
      exported.any((profile) => profile['sonarrHost'] == 'https://sonarr.test'),
      isTrue,
    );
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
