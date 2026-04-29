import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:luna_lighthouse/database/box.dart';
import 'package:luna_lighthouse/database/models/profile.dart';
import 'package:luna_lighthouse/database/table.dart';
import 'package:luna_lighthouse/database/tables/luna_lighthouse.dart';
import 'package:luna_lighthouse/modules/radarr.dart';
import 'package:luna_lighthouse/modules/sonarr.dart';
import 'package:luna_lighthouse/modules/tautulli.dart';
import 'package:luna_lighthouse/system/state.dart';

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

  test('enabled Radarr with a relative host does not crash provider creation',
      () async {
    await _saveProfile(
        LunaProfile(radarrEnabled: true, radarrHost: '/api/v3/'));

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

  test('enabled Sonarr with a relative host does not crash provider creation',
      () async {
    await _saveProfile(
        LunaProfile(sonarrEnabled: true, sonarrHost: '/api/v3/'));

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

  test('enabled Tautulli with a relative host does not crash provider creation',
      () async {
    await _saveProfile(
        LunaProfile(tautulliEnabled: true, tautulliHost: '/api/v3/'));

    final state = TautulliState();

    expect(state.enabled, isFalse);
    expect(state.api, isNull);
  });

  test('disabled Radarr with a valid http host reads the saved profile',
      () async {
    await _saveProfile(
        LunaProfile(radarrEnabled: false, radarrHost: 'http://localhost:7878'));

    final state = RadarrState();

    expect(state.enabled, isFalse);
    expect(state.api, isNull);
    expect(state.host, equals('http://localhost:7878'));
  });

  test('disabled Sonarr with a valid http host reads the saved profile',
      () async {
    await _saveProfile(
        LunaProfile(sonarrEnabled: false, sonarrHost: 'http://localhost:8989'));

    final state = SonarrState();

    expect(state.enabled, isFalse);
    expect(state.api, isNull);
    expect(state.host, equals('http://localhost:8989'));
  });

  test('disabled Tautulli with a valid http host reads the saved profile',
      () async {
    await _saveProfile(LunaProfile(
        tautulliEnabled: false, tautulliHost: 'http://localhost:8181'));

    final state = TautulliState();

    expect(state.enabled, isFalse);
    expect(state.api, isNull);
    expect(state.host, equals('http://localhost:8181'));
  });

  test('host validation accepts absolute http and https URLs', () {
    final validator = _HostValidationHarness();

    expect(validator.accepts('http://localhost:7878'), isTrue);
    expect(validator.accepts('https://sonarr.example.com'), isTrue);
    expect(validator.accepts('  http://localhost:7878  '), isTrue);
  });

  test('host validation rejects blank, relative, schemeless, and non-http URLs',
      () {
    final validator = _HostValidationHarness();

    expect(validator.accepts(''), isFalse);
    expect(validator.accepts('/api/v3/'), isFalse);
    expect(validator.accepts('localhost:7878'), isFalse);
    expect(validator.accepts('plex.home:8181'), isFalse);
    expect(validator.accepts('ftp://myserver.com'), isFalse);
  });
}

Future<void> _saveProfile(LunaProfile profile) async {
  await LunaBox.profiles.update(LunaProfile.DEFAULT_PROFILE, profile);
  LunaLighthouseDatabase.ENABLED_PROFILE.update(LunaProfile.DEFAULT_PROFILE);
}

class _HostValidationHarness extends LunaModuleState {
  bool accepts(String host) => hasUsableApiHost(host);

  @override
  void reset() {}
}
