import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:luna_lighthouse/database/box.dart';
import 'package:luna_lighthouse/database/models/profile.dart';
import 'package:luna_lighthouse/database/table.dart';

/// Tests for the [LunaBox.clear] fix.
///
/// Prior to this fix, `clear()` used `forEach((k) async => await …)`, which
/// created fire-and-forget futures rather than awaiting each deletion.  The fix
/// replaces that with a sequential `for` loop that properly `await`s each
/// `delete` call.  These tests verify that `clear()` reliably empties a box.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory hiveDirectory;

  setUpAll(() async {
    hiveDirectory = Directory.systemTemp.createTempSync('luna_box_clear_test_');
    Hive.init(hiveDirectory.path);
    LunaTable.register();
    await LunaBox.open();
  });

  setUp(() async {
    // Ensure each test starts with clean boxes.
    for (final box in LunaBox.values) {
      await box.clear();
    }
  });

  tearDownAll(() {
    // Keep Hive open to match the pattern used by other database test suites.
    // Closing Hive during teardown can cause hangs due to fire-and-forget writes
    // elsewhere in the app.
  });

  group('LunaBox.clear()', () {
    test('clears a single entry from the profiles box', () async {
      await LunaBox.profiles.update(
        'solo',
        LunaProfile(radarrEnabled: true),
      );
      expect(LunaBox.profiles.size, equals(1));

      await LunaBox.profiles.clear();

      expect(LunaBox.profiles.size, equals(0));
      expect(LunaBox.profiles.isEmpty, isTrue);
    });

    test('clears multiple entries from the profiles box', () async {
      // This test is the core regression guard for the async fix: with the old
      // `forEach` approach, intermediate deletes were unawaited and could race,
      // leaving stale keys behind.  With the fixed `for` loop, all deletes are
      // properly awaited and the box is empty afterwards.
      for (int i = 0; i < 5; i++) {
        await LunaBox.profiles.update('profile-$i', LunaProfile());
      }
      expect(LunaBox.profiles.size, equals(5));

      await LunaBox.profiles.clear();

      expect(LunaBox.profiles.size, equals(0));
      expect(LunaBox.profiles.keys, isEmpty);
    });

    test('returns an empty keys iterable after clearing multiple entries',
        () async {
      await LunaBox.profiles.update('a', LunaProfile());
      await LunaBox.profiles.update('b', LunaProfile());
      await LunaBox.profiles.update('c', LunaProfile());

      await LunaBox.profiles.clear();

      final keys = LunaBox.profiles.keys.toList();
      expect(keys, isEmpty);
    });

    test('clear on an already-empty box is a safe no-op', () async {
      expect(LunaBox.profiles.isEmpty, isTrue);

      // Should not throw.
      await LunaBox.profiles.clear();

      expect(LunaBox.profiles.isEmpty, isTrue);
    });

    test('box is writable again after clear', () async {
      await LunaBox.profiles.update('temp', LunaProfile(lidarrEnabled: true));
      await LunaBox.profiles.clear();
      expect(LunaBox.profiles.isEmpty, isTrue);

      // Write a new entry after clear to confirm the box is still functional.
      await LunaBox.profiles.update(
        LunaProfile.DEFAULT_PROFILE,
        LunaProfile(radarrEnabled: true, radarrHost: 'https://radarr.test'),
      );

      expect(LunaBox.profiles.size, equals(1));
      expect(LunaBox.profiles.read(LunaProfile.DEFAULT_PROFILE)?.radarrEnabled,
          isTrue);
    });

    test('clear is idempotent — calling it twice leaves the box empty',
        () async {
      await LunaBox.profiles.update('once', LunaProfile());

      await LunaBox.profiles.clear();
      await LunaBox.profiles.clear(); // second call must not throw

      expect(LunaBox.profiles.isEmpty, isTrue);
    });

    test('clearing the alerts box leaves it empty', () async {
      // Verify the fix works for a non-typed (dynamic) box, not just profiles.
      await LunaBox.alerts.update('k1', 'alert-one');
      await LunaBox.alerts.update('k2', 'alert-two');
      expect(LunaBox.alerts.size, equals(2));

      await LunaBox.alerts.clear();

      expect(LunaBox.alerts.isEmpty, isTrue);
    });

    test('clearing one box does not affect other boxes', () async {
      await LunaBox.profiles
          .update('profile-a', LunaProfile(sonarrEnabled: true));
      await LunaBox.alerts.update('alert-1', 'my alert');

      // Clear only profiles.
      await LunaBox.profiles.clear();

      expect(LunaBox.profiles.isEmpty, isTrue);
      // alerts box must remain intact.
      expect(LunaBox.alerts.isEmpty, isFalse);
      expect(LunaBox.alerts.size, equals(1));
    });

    test('read returns null for every key that existed before clear', () async {
      await LunaBox.profiles.update('p1', LunaProfile(lidarrEnabled: true));
      await LunaBox.profiles.update('p2', LunaProfile(radarrEnabled: true));

      await LunaBox.profiles.clear();

      expect(LunaBox.profiles.read('p1'), isNull);
      expect(LunaBox.profiles.read('p2'), isNull);
    });
  });
}
