import 'package:flutter_test/flutter_test.dart';
import 'package:luna_lighthouse/modules.dart';
import 'package:luna_lighthouse/system/feature_flags.dart';

void main() {
  group('phase-one cloud integration feature flag', () {
    test('keeps cloud integrations disabled', () {
      expect(LunaFeatureFlags.cloudIntegrationsEnabled, isFalse);
    });

    test('hides hosted webhook metadata for every module', () {
      for (final module in LunaModule.values) {
        expect(module.hasWebhooks, isFalse, reason: module.key);
        expect(module.webhookDocs, isNull, reason: module.key);
      }
    });

    test('ignores webhook payloads while cloud integrations are disabled', () async {
      for (final module in LunaModule.values) {
        await expectLater(
          module.handleWebhook(<String, dynamic>{
            'eventType': 'Test',
            'token': 'sanitized-token',
          }),
          completes,
          reason: module.key,
        );
      }
    });

    test('feature flag value is stable across repeated reads', () {
      // Reading the flag multiple times must return the same value without side
      // effects (no mutable state toggle between reads).
      final first = LunaFeatureFlags.cloudIntegrationsEnabled;
      final second = LunaFeatureFlags.cloudIntegrationsEnabled;
      final third = LunaFeatureFlags.cloudIntegrationsEnabled;

      expect(first, equals(second));
      expect(second, equals(third));
      expect(third, isFalse);
    });

    test('handleWebhook completes with an empty payload', () async {
      // An empty map must not throw, as the feature gate runs before dispatch.
      for (final module in LunaModule.values) {
        await expectLater(
          module.handleWebhook(<String, dynamic>{}),
          completes,
          reason: module.key,
        );
      }
    });

    test('module count matches the expected phase-one registry size', () {
      // Changing the enum size without updating tests is a signal that the
      // module registry diverged from documented expectations.
      expect(LunaModule.values.length, equals(12));
    });

    test('every module key is a non-empty lowercase string', () {
      for (final module in LunaModule.values) {
        expect(module.key, isNotEmpty, reason: 'module key must not be empty');
        expect(
          module.key,
          equals(module.key.toLowerCase()),
          reason: '${module.key} should be lowercase',
        );
      }
    });
  });
}
