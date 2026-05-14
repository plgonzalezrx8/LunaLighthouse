import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:luna_lighthouse/core.dart';
import 'package:luna_lighthouse/database/box.dart';
import 'package:luna_lighthouse/database/table.dart';
import 'package:luna_lighthouse/modules/settings/routes/coming_soon/route.dart';
import 'package:luna_lighthouse/modules/settings/routes/settings/route.dart';
import 'package:luna_lighthouse/router/routes/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Directory? hiveDirectory;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
    hiveDirectory =
        Directory.systemTemp.createTempSync('luna_coming_soon_test_');
    Hive.init(hiveDirectory!.path);
    LunaTable.register();
    await LunaBox.open();
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  tearDownAll(() async {
    await Hive.close();
    hiveDirectory?.deleteSync(recursive: true);
  });

  group('Settings coming soon route', () {
    test('registers coming soon beneath settings', () {
      final settingsSubroutePaths =
          SettingsRoutes.HOME.subroutes.map((route) => route.path);

      expect(settingsSubroutePaths, contains(SettingsRoutes.COMING_SOON.path));
    });

    testWidgets('settings home and coming soon page render', (tester) async {
      final home = ValueNotifier<Widget>(const SettingsRoute());

      await tester.pumpWidget(_localizedApp(home: home));
      await _pumpLocalizedSettled(tester);

      expect(
        find.textContaining('Coming Soon', findRichText: true),
        findsOneWidget,
      );
      expect(
        _findRichTextContaining('Cloud and notification features planned'),
        findsOneWidget,
      );

      home.value = const ComingSoonRoute();
      await _pumpLocalizedSettled(tester);

      expect(
          find.textContaining('Coming Soon', findRichText: true), findsWidgets);
      expect(
        find.textContaining('Cloud Account', findRichText: true),
        findsOneWidget,
      );
      expect(
        find.textContaining('Cloud Sync', findRichText: true),
        findsOneWidget,
      );
      expect(
        find.textContaining('Hosted Push Notifications', findRichText: true),
        findsOneWidget,
      );
      expect(
        find.textContaining('Notification Relay', findRichText: true),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate(
          (widget) => widget is LunaBlock && widget.disabled == true,
        ),
        findsNWidgets(4),
      );
      expect(find.textContaining('Set Up', findRichText: true), findsNothing);
      expect(
        find.textContaining('Webhook URL', findRichText: true),
        findsNothing,
      );
    });
  });
}

Widget _localizedApp({required ValueListenable<Widget> home}) {
  return EasyLocalization(
    supportedLocales: const [Locale('en')],
    path: 'assets/localization',
    fallbackLocale: const Locale('en'),
    startLocale: const Locale('en'),
    useFallbackTranslations: true,
    child: Builder(
      builder: (context) => ValueListenableBuilder<Widget>(
        valueListenable: home,
        builder: (context, currentHome, _) => MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          home: currentHome,
        ),
      ),
    ),
  );
}

Finder _findRichTextContaining(String text) {
  return find.byWidgetPredicate(
    (widget) => widget is RichText && widget.text.toPlainText().contains(text),
  );
}

Future<void> _pumpLocalizedSettled(WidgetTester tester) async {
  await tester.pumpAndSettle();
  await tester.runAsync(tester.idle);
  await tester.pumpAndSettle();
}
