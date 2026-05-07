import 'package:flutter/material.dart';
import 'package:luna_lighthouse/core.dart';

class LunaReorderableListView extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics physics;
  final ScrollController controller;
  final void Function(int, int) onReorder;
  final bool buildDefaultDragHandles;

  const LunaReorderableListView({
    super.key,
    required this.children,
    required this.controller,
    required this.onReorder,
    this.padding,
    this.physics = const AlwaysScrollableScrollPhysics(),
    this.buildDefaultDragHandles = false,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedPadding = (padding ??
            MediaQuery.of(context).padding.add(EdgeInsets.symmetric(
                  vertical: LunaUI.MARGIN_H_DEFAULT_V_HALF.bottom,
                )))
        .resolve(Directionality.of(context));

    return LunaContentWidth(
      child: Scrollbar(
        controller: controller,
        interactive: true,
        child: ReorderableListView(
          scrollController: controller,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: children,
          padding: resolvedPadding,
          physics: physics,
          onReorder: onReorder,
          buildDefaultDragHandles: buildDefaultDragHandles,
        ),
      ),
    );
  }
}
