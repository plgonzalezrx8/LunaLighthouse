import 'package:flutter/material.dart';
import 'package:luna_lighthouse/core.dart';

class LunaColours {
  /// List of LunaLighthouse colours in order that the should appear in a list.
  ///
  /// Use [byListIndex] to fetch the colour at the any index
  static const _LIST_COLOR_ICONS = [
    blue,
    accent,
    red,
    orange,
    purple,
    blueGrey,
  ];

  /// LunaLighthouse logo blue.
  ///
  /// This is the dark brand blue used in the app icon/splash artwork. It works
  /// well for brand surfaces, but is too dark to use as small text/icons on
  /// black.
  static const Color brandBlue = Color(0xFF012988);

  /// Core accent colour.
  ///
  /// A brighter LunaLighthouse blue derived from the logo blue so interactive
  /// text/icons remain readable on both black and white surfaces.
  static const Color accent = Color(0xFF006DFF);

  /// Core primary colour (background)
  static const Color primary = Color(0xFF05070D);

  /// Core secondary colour (appbar, bottom bar, cards, etc.)
  static const Color secondary = Color(0xFF000000);

  static const Color blue = Color(0xFF00A8E8);
  static const Color blueGrey = Color(0xFF5F6D8A);
  static const Color grey = Color(0xFFAEB8CC);
  static const Color orange = Color(0xFFFF9000);
  static const Color purple = Color(0xFF9649CB);
  static const Color red = Color(0xFFF71735);

  /// Shades of White
  static const Color white = Color(0xFFFFFFFF);
  static const Color white70 = Color(0xB3FFFFFF);
  static const Color white10 = Color(0x1AFFFFFF);

  /// Returns the correct colour for a graph by what layer it is on the graph canvas.
  Color byGraphLayer(int index) {
    switch (index) {
      case 0:
        return LunaColours.accent;
      case 1:
        return LunaColours.purple;
      case 2:
        return LunaColours.blue;
      default:
        return byListIndex(index);
    }
  }

  /// Return the correct colour for a list.
  /// If the index is greater than the list of colour's length, uses modulus to loop list.
  Color byListIndex(int index) {
    return _LIST_COLOR_ICONS[index % _LIST_COLOR_ICONS.length];
  }
}

extension LunaColor on Color {
  Color disabled([bool condition = true]) {
    if (condition) return this.withValues(alpha: LunaUI.OPACITY_DISABLED);
    return this;
  }

  Color enabled([bool condition = true]) {
    if (condition) return this;
    return this.withValues(alpha: LunaUI.OPACITY_DISABLED);
  }

  Color selected([bool condition = true]) {
    if (condition) return this.withValues(alpha: LunaUI.OPACITY_SELECTED);
    return this;
  }

  Color dimmed() => this.withValues(alpha: LunaUI.OPACITY_DIMMED);
}
