import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:luna_lighthouse/database/box.dart';
import 'package:luna_lighthouse/database/table.dart';
import 'package:luna_lighthouse/modules/settings/routes/about/open_source_route.dart';
import 'package:luna_lighthouse/modules/settings/routes/about/route.dart';
import 'package:luna_lighthouse/router/routes/settings.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Directory? hiveDirectory;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
    hiveDirectory = Directory.systemTemp.createTempSync('luna_about_test_');
    Hive.init(hiveDirectory!.path);
    LunaTable.register();
    await LunaBox.open();
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    PackageInfo.setMockInitialValues(
      appName: 'LunaLighthouse',
      packageName: 'app.lunalighthouse.lunalighthouse.debug',
      version: '11.0.0',
      buildNumber: '42',
      buildSignature: '',
      installerStore: null,
    );
  });

  tearDownAll(() async {
    await Hive.close();
    hiveDirectory?.deleteSync(recursive: true);
  });

  group('Settings about routes', () {
    test('registers about and open source beneath settings', () {
      final settingsSubroutePaths =
          SettingsRoutes.HOME.subroutes.map((route) => route.path);
      final aboutSubroutePaths =
          SettingsRoutes.ABOUT.subroutes.map((route) => route.path);

      expect(settingsSubroutePaths, contains(SettingsRoutes.ABOUT.path));
      expect(
        aboutSubroutePaths,
        contains(SettingsRoutes.ABOUT_OPEN_SOURCE.path),
      );
    });

    testWidgets('about and open source pages render', (tester) async {
      final home = ValueNotifier<Widget>(const AboutRoute());

      await tester.pumpWidget(_localizedApp(home: home));
      await _pumpLocalizedSettled(tester);

      expect(find.byType(Image), findsOneWidget);
      expect(find.text('LunaLighthouse'), findsOneWidget);
      expect(find.text('Version'), findsOneWidget);
      expect(_findRichTextContaining('11.0.0'), findsAtLeastNWidgets(1));
      expect(find.text('Build'), findsOneWidget);
      expect(_findRichTextContaining('42'), findsAtLeastNWidgets(1));
      expect(_findRichTextContaining('Package'), findsAtLeastNWidgets(1));
      expect(
        _findRichTextContaining('app.lunalighthouse.lunalighthouse.debug'),
        findsOneWidget,
      );
      expect(find.text('Open Source'), findsOneWidget);

      home.value = const AboutOpenSourceRoute();
      await _pumpLocalizedSettled(tester);

      expect(find.text('Dart'), findsOneWidget);
      expect(find.text('Flutter'), findsOneWidget);
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
