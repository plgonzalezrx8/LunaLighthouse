import 'package:flutter/material.dart';
import 'package:luna_lighthouse/system/environment.dart';
import 'package:luna_lighthouse/vendor.dart';
import 'package:luna_lighthouse/widgets/ui.dart';

const FLAVOR_EDGE = 'edge';
const FLAVOR_BETA = 'beta';
const FLAVOR_STABLE = 'stable';

enum LunaFlavor {
  EDGE(FLAVOR_EDGE),
  BETA(FLAVOR_BETA),
  STABLE(FLAVOR_STABLE);

  final String key;
  const LunaFlavor(this.key);

  static LunaFlavor fromKey(String key) {
    switch (key) {
      case FLAVOR_EDGE:
        return LunaFlavor.EDGE;
      case FLAVOR_BETA:
        return LunaFlavor.BETA;
      case FLAVOR_STABLE:
        return LunaFlavor.STABLE;
    }
    throw Exception('Invalid LunaFlavor');
  }

  static LunaFlavor get current => LunaFlavor.fromKey(LunaEnvironment.flavor);

  static bool get isEdge => current == LunaFlavor.EDGE;
  static bool get isBeta => current == LunaFlavor.BETA;
  static bool get isStable => current == LunaFlavor.STABLE;
}

extension LunaFlavorExtension on LunaFlavor {
  bool isRunningFlavor() {
    LunaFlavor flavor = LunaFlavor.current;
    if (flavor == this) return true;

    switch (this) {
      case LunaFlavor.EDGE:
        return false;
      case LunaFlavor.BETA:
        return flavor == LunaFlavor.EDGE;
      case LunaFlavor.STABLE:
        return true;
    }
  }

  String get downloadLink {
    String base = 'https://builds.lunalighthouse.app/#latest';
    switch (this) {
      case LunaFlavor.EDGE:
        return '$base/${this.key}/';
      case LunaFlavor.BETA:
        return '$base/${this.key}/';
      case LunaFlavor.STABLE:
        return '$base/${this.key}/';
    }
  }

  String get name {
    switch (this) {
      case LunaFlavor.EDGE:
        return 'luna_lighthouse.Edge'.tr();
      case LunaFlavor.BETA:
        return 'luna_lighthouse.Beta'.tr();
      case LunaFlavor.STABLE:
        return 'luna_lighthouse.Stable'.tr();
    }
  }

  Color get color {
    switch (this) {
      case LunaFlavor.EDGE:
        return LunaColours.red;
      case LunaFlavor.BETA:
        return LunaColours.blue;
      case LunaFlavor.STABLE:
        return LunaColours.accent;
    }
  }
}
