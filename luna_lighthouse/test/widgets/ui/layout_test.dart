import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:luna_lighthouse/database/box.dart';
import 'package:luna_lighthouse/database/table.dart';
import 'package:luna_lighthouse/widgets/ui.dart';

void main() {
  late Directory hiveDirectory;

  setUpAll(() async {
    hiveDirectory = Directory.systemTemp.createTempSync('luna_layout_test_');
    Hive.init(hiveDirectory.path);
    LunaTable.register();
    await LunaBox.open();
  });

  tearDownAll(() {
    // Match scaffold_test.dart: LunaTableMixin.update mirrors app fire-and-
    // forget writes, and awaiting Hive.close() can hang widget tests.
  });

  testWidgets('content width helper preserves phone width', (tester) async {
    await _pumpBodyAtSize(
      tester,
      const Size(390.0, 700.0),
      const LunaContentWidth(
        child: ColoredBox(
          key: _contentKey,
          color: Colors.blue,
          child: SizedBox.expand(),
        ),
      ),
    );

    expect(tester.getSize(find.byKey(_contentKey)).width, 390.0);
  });

  testWidgets('content width helper caps and centers tablet width',
      (tester) async {
    await _pumpBodyAtSize(
      tester,
      const Size(1024.0, 700.0),
      const LunaContentWidth(
        child: ColoredBox(
          key: _contentKey,
          color: Colors.blue,
          child: SizedBox.expand(),
        ),
      ),
    );

    expect(
      tester.getSize(find.byKey(_contentKey)).width,
      LunaLayout.maxContentWidth,
    );
    expect(
      tester.getTopLeft(find.byKey(_contentKey)).dx,
      (1024.0 - LunaLayout.maxContentWidth) / 2,
    );
  });

  testWidgets('shared list view keeps phone width and caps tablet width',
      (tester) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);

    await _pumpBodyAtSize(
      tester,
      const Size(390.0, 700.0),
      LunaListView(
        controller: controller,
        children: const [SizedBox(height: 48.0)],
      ),
    );
    expect(tester.getSize(find.byType(ListView)).width, 390.0);

    await _pumpBodyAtSize(
      tester,
      const Size(1024.0, 700.0),
      LunaListView(
        controller: controller,
        children: const [SizedBox(height: 48.0)],
      ),
    );
    expect(
      tester.getSize(find.byType(ListView)).width,
      LunaLayout.maxContentWidth,
    );
  });

  testWidgets('shared grid view caps tablet content width', (tester) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);

    await _pumpBodyAtSize(
      tester,
      const Size(1024.0, 700.0),
      LunaGridViewBuilder(
        controller: controller,
        itemCount: 1,
        itemBuilder: (context, index) => const SizedBox(),
        sliverGridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
      ),
    );

    expect(
      tester.getSize(find.byType(GridView)).width,
      LunaLayout.maxContentWidth,
    );
  });

  testWidgets('bottom navigation caps controls but keeps full-width surface',
      (tester) async {
    await _pumpScaffoldAtSize(
      tester,
      const Size(1024.0, 700.0),
      bottomNavigationBar: LunaBottomNavigationBar(
        pageController: null,
        icons: const [Icons.home_rounded, Icons.settings_rounded],
        titles: const ['Home', 'Settings'],
      ),
    );

    expect(
      _contentWidthBoxFinder(LunaLayout.maxNavigationWidth),
      findsOneWidget,
    );
    expect(tester.getSize(find.byType(Scaffold)).width, 1024.0);
  });

  testWidgets('bottom action bar uses the navigation content cap',
      (tester) async {
    await _pumpScaffoldAtSize(
      tester,
      const Size(1024.0, 700.0),
      bottomNavigationBar: LunaBottomActionBar(
        actions: const [
          SizedBox(height: 48.0, child: Text('First')),
          SizedBox(height: 48.0, child: Text('Second')),
        ],
      ),
    );

    expect(
      _contentWidthBoxFinder(LunaLayout.maxNavigationWidth),
      findsOneWidget,
    );
    expect(tester.getSize(find.byType(Scaffold)).width, 1024.0);
  });
}

const _contentKey = Key('layout-content');

Finder _contentWidthBoxFinder(double maxWidth) {
  return find.byWidgetPredicate(
    (widget) =>
        widget is ConstrainedBox && widget.constraints.maxWidth == maxWidth,
  );
}

Future<void> _pumpBodyAtSize(
  WidgetTester tester,
  Size size,
  Widget body,
) {
  return _pumpScaffoldAtSize(tester, size, body: body);
}

Future<void> _pumpScaffoldAtSize(
  WidgetTester tester,
  Size size, {
  Widget? body,
  Widget? bottomNavigationBar,
}) async {
  tester.view.devicePixelRatio = 1.0;
  tester.view.physicalSize = size;
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);

  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: body,
        bottomNavigationBar: bottomNavigationBar,
      ),
    ),
  );
  await tester.pump();
}
