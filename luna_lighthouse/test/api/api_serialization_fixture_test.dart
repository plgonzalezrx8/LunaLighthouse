import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:luna_lighthouse/api/radarr/models/tag/tag.dart';
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
      expect(userName.toJson(), equals(<String, dynamic>{
        'user_id': 42,
        'friendly_name': '12345',
      }));
    });
  });
}

Map<String, dynamic> _readFixture(String name) {
  final file = File('test/fixtures/api/$name');
  return json.decode(file.readAsStringSync()) as Map<String, dynamic>;
}
