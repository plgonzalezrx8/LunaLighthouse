import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:luna_lighthouse/database/box.dart';
import 'package:luna_lighthouse/database/models/profile.dart';
import 'package:luna_lighthouse/database/table.dart';
import 'package:luna_lighthouse/database/tables/luna_lighthouse.dart';
import 'package:luna_lighthouse/widgets/ui/colors.dart';
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

  setUp(() {
    _setAndroidBackOpensDrawer(true);
    _setEnabledProfile(LunaProfile.DEFAULT_PROFILE);
  });

  tearDownAll(() {
    debugDefaultTargetPlatformOverride = null;
    // Do not close Hive here: LunaTableMixin.update intentionally mirrors the
    // app's fire-and-forget writes, and awaiting Hive.close() can hang this
    // widget-test process while those writes settle.
  });

  testWidgets(
    'drawer uses a LunaLighthouse blue scrim to separate black surfaces',
    (tester) async {
      final route = await _pumpScaffoldRoute(tester, includeDrawer: true);
      final scaffold = route.scaffoldKey.currentWidget! as Scaffold;

      expect(scaffold.drawerScrimColor, LunaColours.drawerScrim);
    },
  );

  testWidgets(
    'Android system back opens the drawer instead of popping the route when enabled',
    (tester) async => _runAsAndroid(() async {
      await _pumpScaffoldRoute(tester, includeDrawer: true);

      expect(_popScopeCanPop(tester), isFalse);
      await _simulateSystemBack(tester);
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
      await _simulateSystemBack(tester);
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

      await _simulateSystemBack(tester);
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
      await _simulateSystemBack(tester);
      await _pumpNavigation(tester);

      expect(find.text(_routeBodyText), findsNothing);
      expect(find.text(_homeText), findsOneWidget);
    }),
  );

  testWidgets(
    'non-Android scaffold does not install Android PopScope',
    (tester) async => _runAsPlatform(TargetPlatform.iOS, () async {
      await _pumpScaffoldRoute(tester, includeDrawer: true);

      expect(find.text(_routeBodyText), findsOneWidget);
      expect(find.byType(PopScope), findsNothing);
    }),
  );

  testWidgets('profile change callback fires when enabled profile changes',
      (tester) async {
    var callbackCount = 0;
    await _pumpScaffoldRoute(
      tester,
      includeDrawer: true,
      onProfileChange: (_) => callbackCount += 1,
    );
    final initialCallbackCount = callbackCount;

    LunaLighthouseDatabase.ENABLED_PROFILE.update('alternate-profile');
    await _pumpNavigation(tester);

    expect(initialCallbackCount, greaterThanOrEqualTo(1));
    expect(callbackCount, greaterThan(initialCallbackCount));
    expect(find.text(_routeBodyText), findsOneWidget);
  });

  testWidgets('opening the drawer clears primary focus', (tester) async {
    final focusNode = FocusNode();
    final route = await _pumpScaffoldRoute(
      tester,
      includeDrawer: true,
      routeBody: TextField(focusNode: focusNode),
    );

    await tester.tap(find.byType(TextField));
    await _pumpNavigation(tester);
    expect(focusNode.hasFocus, isTrue);

    route.scaffoldKey.currentState!.openDrawer();
    await _pumpNavigation(tester);

    expect(focusNode.hasFocus, isFalse);
    focusNode.dispose();
  });

  testWidgets(
    'macOS platform also does not install Android PopScope',
    (tester) async => _runAsPlatform(TargetPlatform.macOS, () async {
      await _pumpScaffoldRoute(tester, includeDrawer: true);

      expect(find.text(_routeBodyText), findsOneWidget);
      expect(find.byType(PopScope), findsNothing);
    }),
  );

  testWidgets(
    'non-Android scaffold without drawer also has no PopScope',
    (tester) async => _runAsPlatform(TargetPlatform.iOS, () async {
      await _pumpScaffoldRoute(tester, includeDrawer: false);

      expect(find.text(_routeBodyText), findsOneWidget);
      expect(find.byType(PopScope), findsNothing);
    }),
  );

  testWidgets(
    'profile change callback is not invoked when onProfileChange is null',
    (tester) async {
      // Should not throw when onProfileChange is null and the profile changes.
      await _pumpScaffoldRoute(
        tester,
        includeDrawer: true,
        onProfileChange: null,
      );

      LunaLighthouseDatabase.ENABLED_PROFILE.update('another-profile');
      await _pumpNavigation(tester);

      expect(find.text(_routeBodyText), findsOneWidget);
    },
  );

  testWidgets(
    'profile change callback accumulates over successive profile switches',
    (tester) async {
      final profilesSeen = <String>[];
      await _pumpScaffoldRoute(
        tester,
        includeDrawer: true,
        onProfileChange: (_) {
          final currentProfile =
              LunaLighthouseDatabase.ENABLED_PROFILE.read() ?? '';
          profilesSeen.add(currentProfile);
        },
      );

      LunaLighthouseDatabase.ENABLED_PROFILE.update('profile-a');
      await _pumpNavigation(tester);
      LunaLighthouseDatabase.ENABLED_PROFILE.update('profile-b');
      await _pumpNavigation(tester);

      // The callback must have fired at least twice (one per profile update).
      expect(profilesSeen.length, greaterThanOrEqualTo(2));
    },
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

void _setEnabledProfile(String value) {
  LunaLighthouseDatabase.ENABLED_PROFILE.update(value);
}

bool _popScopeCanPop(WidgetTester tester) {
  final widget = tester.widget(
    find.byWidgetPredicate((widget) => widget is PopScope),
  );
  return (widget as PopScope).canPop;
}

Future<void> _simulateSystemBack(WidgetTester tester) {
  final popScopeFinder = find.byWidgetPredicate((widget) => widget is PopScope);
  final popScope = tester.widget<PopScope<void>>(popScopeFinder);
  if (!popScope.canPop) {
    popScope.onPopInvokedWithResult?.call(false, null);
    return Future<void>.value();
  }

  Navigator.of(tester.element(popScopeFinder)).pop();
  return Future<void>.value();
}

Future<void> _runAsAndroid(Future<void> Function() body) async {
  return _runAsPlatform(TargetPlatform.android, body);
}

Future<void> _runAsPlatform(
  TargetPlatform platform,
  Future<void> Function() body,
) async {
  final previousPlatform = debugDefaultTargetPlatformOverride;
  debugDefaultTargetPlatformOverride = platform;
  try {
    await body();
  } finally {
    debugDefaultTargetPlatformOverride = previousPlatform;
  }
}

Future<_ScaffoldRoute> _pumpScaffoldRoute(
  WidgetTester tester, {
  required bool includeDrawer,
  Widget? routeBody,
  void Function(BuildContext)? onProfileChange,
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
                              return Center(
                                child: routeBody ?? const Text(_routeBodyText),
                              );
                            },
                          ),
                          drawer: includeDrawer
                              ? const Drawer(child: Text(_drawerText))
                              : null,
                          onProfileChange: onProfileChange,
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

  if (routeBody == null) {
    expect(find.text(_routeBodyText), findsOneWidget);
  } else {
    expect(find.byWidget(routeBody), findsOneWidget);
  }
  expect(find.text(_drawerText), findsNothing);

  return _ScaffoldRoute(scaffoldKey: scaffoldKey, context: routeContext);
}

Future<void> _pumpNavigation(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
}
