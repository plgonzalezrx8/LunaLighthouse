import 'package:flutter_test/flutter_test.dart';
import 'package:luna_lighthouse/database/models/profile.dart';

void main() {
  group('LunaProfile serialization', () {
    test('preserves service credentials and headers through JSON clone', () {
      final profile = _fullProfile();

      final clone = LunaProfile.clone(profile);

      _expectFullProfile(clone);
    });

    test('uses safe defaults when optional JSON fields are absent', () {
      final profile = LunaProfile.fromJson(<String, dynamic>{});

      expect(profile.lidarrEnabled, isFalse);
      expect(profile.lidarrHost, isEmpty);
      expect(profile.lidarrKey, isEmpty);
      expect(profile.lidarrHeaders, isEmpty);
      expect(profile.radarrHeaders, isEmpty);
      expect(profile.sonarrHeaders, isEmpty);
      expect(profile.sabnzbdHeaders, isEmpty);
      expect(profile.nzbgetHeaders, isEmpty);
      expect(profile.tautulliHeaders, isEmpty);
      expect(profile.overseerrHeaders, isEmpty);
      expect(profile.nzbgetPass, isEmpty);
      expect(profile.wakeOnLANMACAddress, isEmpty);
    });

    test('emits header maps and secret-bearing fields in JSON output', () {
      final json = _fullProfile().toJson();

      expect(json['lidarrKey'], equals('lidarr-key'));
      expect(json['nzbgetPass'], equals('nzbget-password'));
      expect(json['wakeOnLANMACAddress'], equals('00:11:22:33:44:55'));
      expect(
        json['radarrHeaders'],
        equals(<String, String>{'X-Radarr-Token': 'radarr-token'}),
      );
      expect(
        json['overseerrHeaders'],
        equals(<String, String>{'X-Overseerr-Token': 'overseerr-token'}),
      );
    });

    test('clone creates an independent copy that does not share state', () {
      final original = _fullProfile();
      final clone = LunaProfile.clone(original);

      // Verify the clone matched the original first.
      _expectFullProfile(clone);

      // The clone should be a distinct object (not identical reference).
      expect(identical(original, clone), isFalse);
    });

    test('profile with empty host strings serializes without error', () {
      // Boundary: all hosts empty (no configured services) must not throw.
      final profile = LunaProfile(
        lidarrEnabled: false,
        lidarrHost: '',
        lidarrKey: '',
        lidarrHeaders: const <String, String>{},
        radarrEnabled: false,
        radarrHost: '',
        radarrKey: '',
        radarrHeaders: const <String, String>{},
        sonarrEnabled: false,
        sonarrHost: '',
        sonarrKey: '',
        sonarrHeaders: const <String, String>{},
      );

      final json = profile.toJson();

      expect(json['lidarrHost'], equals(''));
      expect(json['radarrHost'], equals(''));
      expect(json['sonarrHost'], equals(''));
      expect(json['lidarrHeaders'], isEmpty);
    });

    test('fromJson round-trips back through toJson for a full profile', () {
      final original = _fullProfile();
      final json = original.toJson();
      final roundTripped = LunaProfile.fromJson(json);

      // All service-host/key/header/password fields must survive a round-trip.
      _expectFullProfile(roundTripped);
    });

    test('header maps with multiple entries survive serialization', () {
      final profile = LunaProfile(
        radarrEnabled: true,
        radarrHost: 'https://radarr.example.test',
        radarrKey: 'radarr-key',
        radarrHeaders: const <String, String>{
          'X-Token': 'token-value',
          'X-Extra': 'extra-value',
        },
      );

      final json = profile.toJson();
      final restored = LunaProfile.fromJson(json);

      expect(
          restored.radarrHeaders,
          equals(<String, String>{
            'X-Token': 'token-value',
            'X-Extra': 'extra-value',
          }));
    });
  });
}

LunaProfile _fullProfile() {
  return LunaProfile(
    lidarrEnabled: true,
    lidarrHost: 'https://lidarr.example.test',
    lidarrKey: 'lidarr-key',
    lidarrHeaders: const <String, String>{'X-Lidarr-Token': 'lidarr-token'},
    radarrEnabled: true,
    radarrHost: 'https://radarr.example.test',
    radarrKey: 'radarr-key',
    radarrHeaders: const <String, String>{'X-Radarr-Token': 'radarr-token'},
    sonarrEnabled: true,
    sonarrHost: 'https://sonarr.example.test',
    sonarrKey: 'sonarr-key',
    sonarrHeaders: const <String, String>{'X-Sonarr-Token': 'sonarr-token'},
    sabnzbdEnabled: true,
    sabnzbdHost: 'https://sabnzbd.example.test',
    sabnzbdKey: 'sabnzbd-key',
    sabnzbdHeaders: const <String, String>{'X-SABnzbd-Token': 'sabnzbd-token'},
    nzbgetEnabled: true,
    nzbgetHost: 'https://nzbget.example.test',
    nzbgetUser: 'nzbget-user',
    nzbgetPass: 'nzbget-password',
    nzbgetHeaders: const <String, String>{'X-NZBGet-Token': 'nzbget-token'},
    wakeOnLANEnabled: true,
    wakeOnLANBroadcastAddress: '192.0.2.255',
    wakeOnLANMACAddress: '00:11:22:33:44:55',
    tautulliEnabled: true,
    tautulliHost: 'https://tautulli.example.test',
    tautulliKey: 'tautulli-key',
    tautulliHeaders: const <String, String>{
      'X-Tautulli-Token': 'tautulli-token'
    },
    overseerrEnabled: true,
    overseerrHost: 'https://overseerr.example.test',
    overseerrKey: 'overseerr-key',
    overseerrHeaders: const <String, String>{
      'X-Overseerr-Token': 'overseerr-token',
    },
  );
}

void _expectFullProfile(LunaProfile profile) {
  expect(profile.lidarrEnabled, isTrue);
  expect(profile.lidarrHost, equals('https://lidarr.example.test'));
  expect(profile.lidarrKey, equals('lidarr-key'));
  expect(profile.lidarrHeaders, equals({'X-Lidarr-Token': 'lidarr-token'}));

  expect(profile.radarrEnabled, isTrue);
  expect(profile.radarrHost, equals('https://radarr.example.test'));
  expect(profile.radarrKey, equals('radarr-key'));
  expect(profile.radarrHeaders, equals({'X-Radarr-Token': 'radarr-token'}));

  expect(profile.sonarrEnabled, isTrue);
  expect(profile.sonarrHost, equals('https://sonarr.example.test'));
  expect(profile.sonarrKey, equals('sonarr-key'));
  expect(profile.sonarrHeaders, equals({'X-Sonarr-Token': 'sonarr-token'}));

  expect(profile.sabnzbdEnabled, isTrue);
  expect(profile.sabnzbdHost, equals('https://sabnzbd.example.test'));
  expect(profile.sabnzbdKey, equals('sabnzbd-key'));
  expect(profile.sabnzbdHeaders, equals({'X-SABnzbd-Token': 'sabnzbd-token'}));

  expect(profile.nzbgetEnabled, isTrue);
  expect(profile.nzbgetHost, equals('https://nzbget.example.test'));
  expect(profile.nzbgetUser, equals('nzbget-user'));
  expect(profile.nzbgetPass, equals('nzbget-password'));
  expect(profile.nzbgetHeaders, equals({'X-NZBGet-Token': 'nzbget-token'}));

  expect(profile.wakeOnLANEnabled, isTrue);
  expect(profile.wakeOnLANBroadcastAddress, equals('192.0.2.255'));
  expect(profile.wakeOnLANMACAddress, equals('00:11:22:33:44:55'));

  expect(profile.tautulliEnabled, isTrue);
  expect(profile.tautulliHost, equals('https://tautulli.example.test'));
  expect(profile.tautulliKey, equals('tautulli-key'));
  expect(
      profile.tautulliHeaders, equals({'X-Tautulli-Token': 'tautulli-token'}));

  expect(profile.overseerrEnabled, isTrue);
  expect(profile.overseerrHost, equals('https://overseerr.example.test'));
  expect(profile.overseerrKey, equals('overseerr-key'));
  expect(
    profile.overseerrHeaders,
    equals({'X-Overseerr-Token': 'overseerr-token'}),
  );
}
