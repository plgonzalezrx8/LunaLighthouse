import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:luna_lighthouse/api/nzbget/models/status.dart';
import 'package:luna_lighthouse/api/nzbget/models/version.dart';
import 'package:luna_lighthouse/api/radarr/models/queue/queue_status.dart';
import 'package:luna_lighthouse/api/radarr/models/tag/tag.dart';
import 'package:luna_lighthouse/api/sabnzbd/models/version.dart';
import 'package:luna_lighthouse/api/sonarr/models/queue/queue.dart';
import 'package:luna_lighthouse/api/sonarr/models/tag/tag.dart';
import 'package:luna_lighthouse/api/tautulli/models/users/user_name.dart';

void main() {
  group('API serialization fixtures', () {
    test('parses and emits a Radarr tag fixture', () {
      final json = _readFixture('radarr_tag.json');

      final tag = RadarrTag.fromJson(json);

      expect(tag.id, equals(12));
      expect(tag.label, equals('launch-check'));
      expect(tag.toJson(), equals(json));
    });

    test('parses and emits a Sonarr tag fixture', () {
      final json = _readFixture('sonarr_tag.json');

      final tag = SonarrTag.fromJson(json);

      expect(tag.id, equals(34));
      expect(tag.label, equals('phase-one'));
      expect(tag.toJson(), equals(json));
    });

    test('normalizes Tautulli user names from loose API payload types', () {
      final json = _readFixture('tautulli_user_name.json');

      final userName = TautulliUserName.fromJson(json);

      expect(userName.userId, equals(42));
      expect(userName.friendlyName, equals('12345'));
      expect(
          userName.toJson(),
          equals(<String, dynamic>{
            'user_id': 42,
            'friendly_name': '12345',
          }));
    });

    test('parses Tautulli user name when user_id is already an integer', () {
      // Boundary: the API sometimes returns user_id as an int rather than a
      // string; TautulliUtilities.ensureIntegerFromJson must handle both.
      final json = _readFixture('tautulli_user_name_int_id.json');

      final userName = TautulliUserName.fromJson(json);

      expect(userName.userId, equals(99));
      expect(userName.friendlyName, equals('alice'));
      expect(
          userName.toJson(),
          equals(<String, dynamic>{
            'user_id': 99,
            'friendly_name': 'alice',
          }));
    });

    test('parses Tautulli user name with zero id and empty friendly name', () {
      // Boundary/negative: zero user_id and an empty friendly_name string
      // should not throw or coerce values.
      final json = _readFixture('tautulli_user_name_zero.json');

      final userName = TautulliUserName.fromJson(json);

      expect(userName.userId, equals(0));
      expect(userName.friendlyName, equals(''));
    });

    test('Radarr tag round-trips preserve integer id without coercion', () {
      // Regression guard: toJson must emit id as int, not as String.
      final json = _readFixture('radarr_tag.json');
      final tag = RadarrTag.fromJson(json);
      final emitted = tag.toJson();

      expect(emitted['id'], isA<int>());
      expect(emitted['label'], isA<String>());
    });

    test('Sonarr tag round-trips preserve integer id without coercion', () {
      final json = _readFixture('sonarr_tag.json');
      final tag = SonarrTag.fromJson(json);
      final emitted = tag.toJson();

      expect(emitted['id'], isA<int>());
      expect(emitted['label'], isA<String>());
    });

    test('parses a Radarr queue status fixture used by launch checks', () {
      final json = _readFixture('radarr_queue_status.json');

      final status = RadarrQueueStatus.fromJson(json);

      expect(status.totalCount, equals(2));
      expect(status.errors, isFalse);
      expect(status.toJson(), equals(json));
    });

    test('parses an empty Sonarr queue page fixture', () {
      final json = _readFixture('sonarr_queue_page_empty.json');

      final queue = SonarrQueuePage.fromJson(json);

      expect(queue.page, equals(1));
      expect(queue.records, isEmpty);
      expect(queue.toJson(), equals(json));
    });

    test('parses an NZBGet status fixture used by launch checks', () {
      final json = _readFixture('nzbget_status.json');

      final status = NZBGetStatus.fromJson(json);

      expect(status.paused, isFalse);
      expect(status.remainingSize, equals(128));
      expect(status.toJson(), equals(json));
    });

    test('parses NZBGet and SABnzbd version fixtures', () {
      final nzbgetJson = _readFixture('nzbget_version.json');
      final sabnzbdJson = _readFixture('sabnzbd_version.json');

      final nzbget = NZBGetVersion.fromJson(nzbgetJson);
      final sabnzbd = SABnzbdVersion.fromJson(sabnzbdJson);

      expect(nzbget.version, equals('21.1'));
      expect(sabnzbd.version, equals('4.2.3'));
      expect(nzbget.toJson(), equals(nzbgetJson));
      expect(sabnzbd.toJson(), equals(sabnzbdJson));
    });
  });
}

Map<String, dynamic> _readFixture(String name) {
  final file = File('test/fixtures/api/$name');
  return json.decode(file.readAsStringSync()) as Map<String, dynamic>;
}
