import 'package:flutter/material.dart';

class LunaLayout {
  static const double tabletBreakpoint = 600.0;
  static const double maxContentWidth = 720.0;
  static const double maxNavigationWidth = 640.0;

  static bool isTabletWidth(double width) => width >= tabletBreakpoint;
}

class LunaContentWidth extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final AlignmentGeometry alignment;

  const LunaContentWidth({
    super.key,
    required this.child,
    this.maxWidth = LunaLayout.maxContentWidth,
    this.alignment = Alignment.topCenter,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (!constraints.hasBoundedWidth ||
            !LunaLayout.isTabletWidth(constraints.maxWidth) ||
            constraints.maxWidth <= maxWidth) {
          return child;
        }

        return Align(
          alignment: alignment,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: child,
          ),
        );
      },
    );
  }
}
