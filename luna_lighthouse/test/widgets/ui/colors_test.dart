import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna_lighthouse/widgets/ui.dart';

void main() {
  test('visual theme uses LunaLighthouse blue and black core colors', () {
    expect(LunaColours.brandBlue, const Color(0xFF012988));
    expect(LunaColours.accent, const Color(0xFF006DFF));
    expect(LunaColours.primary, const Color(0xFF05070D));
    expect(LunaColours.secondary, const Color(0xFF000000));
    expect(LunaColours.drawerSurface, const Color(0xFF0B1B3D));
  });

  test('interactive accent blue has readable contrast on black and white', () {
    expect(_contrastRatio(LunaColours.accent, Colors.black),
        greaterThanOrEqualTo(4.5));
    expect(_contrastRatio(LunaColours.accent, Colors.white),
        greaterThanOrEqualTo(4.5));
  });

  test('drawer surface separates from black while keeping readable text', () {
    expect(_contrastRatio(LunaColours.drawerSurface, Colors.black),
        greaterThanOrEqualTo(1.2));
    expect(_contrastRatio(LunaColours.drawerSurface, Colors.white),
        greaterThanOrEqualTo(4.5));
  });
}

double _contrastRatio(Color foreground, Color background) {
  final foregroundLuminance = foreground.computeLuminance();
  final backgroundLuminance = background.computeLuminance();
  final lighter = foregroundLuminance > backgroundLuminance
      ? foregroundLuminance
      : backgroundLuminance;
  final darker = foregroundLuminance > backgroundLuminance
      ? backgroundLuminance
      : foregroundLuminance;

  return (lighter + 0.05) / (darker + 0.05);
}
