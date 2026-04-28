import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:luna_lighthouse/database/box.dart';
import 'package:luna_lighthouse/database/table.dart';
import 'package:luna_lighthouse/database/tables/luna_lighthouse.dart';
import 'package:luna_lighthouse/widgets/ui/scaffold.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory hiveDirectory;

  setUpAll(() async {
    hiveDirectory = Directory.systemTemp.createTempSync('luna_scaffold_test_');
    Hive.init(hiveDirectory.path);
    LunaTable.register();
    await LunaBox.open();
  });

  setUp(() async {
    await LunaBox.luna_lighthouse.clear();
    _setAndroidBackOpensDrawer(true);
  });

  tearDownAll(() {
    debugDefaultTargetPlatformOverride = null;
    // Do not close Hive here: LunaTableMixin.update intentionally mirrors the
    // app's fire-and-forget writes, and awaiting Hive.close() can hang this
    // widget-test process while those writes settle.
  });

  testWidgets(
    'Android system back opens the drawer instead of popping the route when enabled',
    (tester) async => _runAsAndroid(() async {
      await _pumpScaffoldRoute(tester, includeDrawer: true);

      expect(_popScopeCanPop(tester), isFalse);
      await _simulateSystemBack();
      await _pumpNavigation(tester);

      expect(find.text(_routeBodyText), findsOneWidget);
      expect(find.text(_drawerText), findsOneWidget);
    }),
  );

  testWidgets(
    'Android system back pops the route when drawer shortcut is disabled',
    (tester) async => _runAsAndroid(() async {
      _setAndroidBackOpensDrawer(false);
      await _pumpScaffoldRoute(tester, includeDrawer: true);

      expect(_popScopeCanPop(tester), isTrue);
      await _simulateSystemBack();
      await _pumpNavigation(tester);

      expect(find.text(_routeBodyText), findsNothing);
      expect(find.text(_homeText), findsOneWidget);
    }),
  );

  testWidgets(
    'Android system back closes an already open drawer without popping the route',
    (tester) async => _runAsAndroid(() async {
      final route = await _pumpScaffoldRoute(tester, includeDrawer: true);
      route.scaffoldKey.currentState!.openDrawer();
      await _pumpNavigation(tester);

      expect(find.text(_drawerText), findsOneWidget);
      expect(_popScopeCanPop(tester), isTrue);

      await _simulateSystemBack();
      await _pumpNavigation(tester);

      expect(find.text(_routeBodyText), findsOneWidget);
      expect(find.text(_drawerText), findsNothing);
    }),
  );

  testWidgets(
    'Android system back pops the route when there is no drawer',
    (tester) async => _runAsAndroid(() async {
      await _pumpScaffoldRoute(tester, includeDrawer: false);

      expect(_popScopeCanPop(tester), isTrue);
      await _simulateSystemBack();
      await _pumpNavigation(tester);

      expect(find.text(_routeBodyText), findsNothing);
      expect(find.text(_homeText), findsOneWidget);
    }),
  );
}

const _homeText = 'Home route';
const _openRouteText = 'Open LunaScaffold route';
const _routeBodyText = 'LunaScaffold route body';
const _drawerText = 'LunaScaffold drawer content';

class _ScaffoldRoute {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final BuildContext context;

  const _ScaffoldRoute({required this.scaffoldKey, required this.context});
}

void _setAndroidBackOpensDrawer(bool value) {
  LunaLighthouseDatabase.ANDROID_BACK_OPENS_DRAWER.update(value);
}

bool _popScopeCanPop(WidgetTester tester) {
  final widget = tester.widget(
    find.byWidgetPredicate((widget) => widget is PopScope),
  );
  return (widget as PopScope).canPop;
}

Future<void> _simulateSystemBack() {
  return TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .handlePlatformMessage(
    'flutter/navigation',
    const JSONMessageCodec().encodeMessage(<String, dynamic>{
      'method': 'popRoute',
    }),
    (ByteData? _) {},
  );
}

Future<void> _runAsAndroid(Future<void> Function() body) async {
  final previousPlatform = debugDefaultTargetPlatformOverride;
  debugDefaultTargetPlatformOverride = TargetPlatform.android;
  try {
    await body();
  } finally {
    debugDefaultTargetPlatformOverride = previousPlatform;
  }
}

Future<_ScaffoldRoute> _pumpScaffoldRoute(
  WidgetTester tester, {
  required bool includeDrawer,
}) async {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late BuildContext routeContext;

  await tester.pumpWidget(
    MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(_homeText),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => LunaScaffold(
                          scaffoldKey: scaffoldKey,
                          appBar: AppBar(title: const Text('Route app bar')),
                          body: Builder(
                            builder: (context) {
                              routeContext = context;
                              return const Center(child: Text(_routeBodyText));
                            },
                          ),
                          drawer: includeDrawer
                              ? const Drawer(child: Text(_drawerText))
                              : null,
                        ),
                      ),
                    );
                  },
                  child: const Text(_openRouteText),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  await tester.tap(find.text(_openRouteText));
  await _pumpNavigation(tester);

  expect(find.text(_routeBodyText), findsOneWidget);
  expect(find.text(_drawerText), findsNothing);

  return _ScaffoldRoute(scaffoldKey: scaffoldKey, context: routeContext);
}

Future<void> _pumpNavigation(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
}
