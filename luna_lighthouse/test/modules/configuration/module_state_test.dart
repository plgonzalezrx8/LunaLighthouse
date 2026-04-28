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
}

Future<void> _saveProfile(LunaProfile profile) async {
  await LunaBox.profiles.update(LunaProfile.DEFAULT_PROFILE, profile);
  LunaLighthouseDatabase.ENABLED_PROFILE.update(LunaProfile.DEFAULT_PROFILE);
}
