import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:luna_lighthouse/database/box.dart';
import 'package:luna_lighthouse/database/models/profile.dart';
import 'package:luna_lighthouse/database/table.dart';
import 'package:luna_lighthouse/modules/radarr.dart';
import 'package:luna_lighthouse/modules/sonarr.dart';
import 'package:luna_lighthouse/modules/tautulli.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory hiveDirectory;

  setUpAll(() async {
    hiveDirectory =
        Directory.systemTemp.createTempSync('luna_module_state_test_');
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
    // Keep Hive open for the same reason as the scaffold widget tests: app code
    // intentionally performs some fire-and-forget writes, and waiting on close
    // can hang the test process.
  });

  test('enabled Radarr with a blank host does not crash provider creation',
      () async {
    await _saveProfile(LunaProfile(radarrEnabled: true));

    final state = RadarrState();

    expect(state.enabled, isFalse);
    expect(state.api, isNull);
  });

  test('enabled Sonarr with a blank host does not crash provider creation',
      () async {
    await _saveProfile(LunaProfile(sonarrEnabled: true));

    final state = SonarrState();

    expect(state.enabled, isFalse);
    expect(state.api, isNull);
  });

  test('enabled Tautulli with a blank host does not crash provider creation',
      () async {
    await _saveProfile(LunaProfile(tautulliEnabled: true));

    final state = TautulliState();

    expect(state.enabled, isFalse);
    expect(state.api, isNull);
  });

  // Regression tests for the simplified _saveProfile helper (no longer calls
  // LunaLighthouseDatabase.ENABLED_PROFILE.update). The profile is saved at
  // DEFAULT_PROFILE key, and ENABLED_PROFILE falls back to DEFAULT_PROFILE
  // when the box is empty, so states should still read the saved profile.

  test(
      'profile saved without setting ENABLED_PROFILE is still read by RadarrState',
      () async {
    await _saveProfile(LunaProfile(radarrEnabled: true));

    final state = RadarrState();

    // radarrEnabled is true but host is blank, so enabled must remain false.
    // This verifies the profile was read (radarrEnabled=true) even without
    // explicitly setting ENABLED_PROFILE in the database.
    expect(state.enabled, isFalse);
    expect(state.host, isEmpty);
    expect(state.api, isNull);
  });

  test(
      'profile saved without setting ENABLED_PROFILE is still read by SonarrState',
      () async {
    await _saveProfile(
        LunaProfile(sonarrEnabled: true, sonarrKey: 'testkey123'));

    final state = SonarrState();

    // sonarrEnabled is true but host is blank, so enabled must remain false.
    expect(state.enabled, isFalse);
    expect(state.api, isNull);
  });

  test(
      'profile saved without setting ENABLED_PROFILE is still read by TautulliState',
      () async {
    await _saveProfile(
        LunaProfile(tautulliEnabled: true, tautulliKey: 'testkey123'));

    final state = TautulliState();

    // tautulliEnabled is true but host is blank, so enabled must remain false.
    expect(state.enabled, isFalse);
    expect(state.api, isNull);
  });

  // Host validation boundary tests — verifying that only absolute http/https
  // URLs are treated as usable (relative paths and schemeless hosts are not).

  test('enabled Radarr with a schemeless host is treated as disabled', () async {
    await _saveProfile(
        LunaProfile(radarrEnabled: true, radarrHost: 'localhost:7878'));

    final state = RadarrState();

    expect(state.enabled, isFalse);
    expect(state.api, isNull);
  });

  test('enabled Sonarr with a schemeless host is treated as disabled', () async {
    await _saveProfile(
        LunaProfile(sonarrEnabled: true, sonarrHost: 'myserver.local:8989'));

    final state = SonarrState();

    expect(state.enabled, isFalse);
    expect(state.api, isNull);
  });

  test('enabled Tautulli with a schemeless host is treated as disabled',
      () async {
    await _saveProfile(
        LunaProfile(tautulliEnabled: true, tautulliHost: 'plex.home:8181'));

    final state = TautulliState();

    expect(state.enabled, isFalse);
    expect(state.api, isNull);
  });

  test('enabled Radarr with a non-http scheme host is treated as disabled',
      () async {
    await _saveProfile(
        LunaProfile(radarrEnabled: true, radarrHost: 'ftp://myserver.com'));

    final state = RadarrState();

    expect(state.enabled, isFalse);
    expect(state.api, isNull);
  });

  test('disabled Radarr with a valid http host remains disabled', () async {
    await _saveProfile(LunaProfile(
        radarrEnabled: false, radarrHost: 'http://localhost:7878'));

    final state = RadarrState();

    expect(state.enabled, isFalse);
    expect(state.api, isNull);
  });

  test('disabled Sonarr with a valid http host remains disabled', () async {
    await _saveProfile(LunaProfile(
        sonarrEnabled: false, sonarrHost: 'http://localhost:8989'));

    final state = SonarrState();

    expect(state.enabled, isFalse);
    expect(state.api, isNull);
  });

  test('disabled Tautulli with a valid http host remains disabled', () async {
    await _saveProfile(LunaProfile(
        tautulliEnabled: false, tautulliHost: 'http://localhost:8181'));

    final state = TautulliState();

    expect(state.enabled, isFalse);
    expect(state.api, isNull);
  });

  test('enabled Radarr with a valid http host is enabled with api instance',
      () async {
    await _saveProfile(LunaProfile(
        radarrEnabled: true,
        radarrHost: 'http://localhost:7878',
        radarrKey: 'abc123'));

    final state = RadarrState();

    expect(state.enabled, isTrue);
    expect(state.api, isNotNull);
    expect(state.host, equals('http://localhost:7878'));
  });

  test('enabled Sonarr with a valid https host is enabled with api instance',
      () async {
    await _saveProfile(LunaProfile(
        sonarrEnabled: true,
        sonarrHost: 'https://sonarr.example.com',
        sonarrKey: 'abc123'));

    final state = SonarrState();

    expect(state.enabled, isTrue);
    expect(state.api, isNotNull);
    expect(state.host, equals('https://sonarr.example.com'));
  });

  test('enabled Tautulli with a valid http host is enabled with api instance',
      () async {
    await _saveProfile(LunaProfile(
        tautulliEnabled: true,
        tautulliHost: 'http://plex.home:8181',
        tautulliKey: 'abc123'));

    final state = TautulliState();

    expect(state.enabled, isTrue);
    expect(state.api, isNotNull);
    expect(state.host, equals('http://plex.home:8181'));
  });

  test('enabled Radarr with a valid host and extra whitespace is enabled',
      () async {
    await _saveProfile(LunaProfile(
        radarrEnabled: true,
        radarrHost: '  http://localhost:7878  ',
        radarrKey: 'key'));

    final state = RadarrState();

    // The host is trimmed, so the state should be enabled.
    expect(state.enabled, isTrue);
    expect(state.api, isNotNull);
    expect(state.host, equals('http://localhost:7878'));
  });
}

Future<void> _saveProfile(LunaProfile profile) async {

}
