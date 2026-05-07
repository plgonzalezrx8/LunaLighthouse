import 'package:flutter/material.dart';
import 'package:luna_lighthouse/widgets/ui/layout.dart';

class LunaCustomScrollView extends StatelessWidget {
  final ScrollController controller;
  final List<Widget> slivers;

  const LunaCustomScrollView({
    super.key,
    required this.controller,
    required this.slivers,
  });

  @override
  Widget build(BuildContext context) {
    return LunaContentWidth(
      child: Scrollbar(
        controller: controller,
        interactive: true,
        child: CustomScrollView(
          controller: controller,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: slivers,
          physics: const AlwaysScrollableScrollPhysics(),
        ),
      ),
    );
  }
}
