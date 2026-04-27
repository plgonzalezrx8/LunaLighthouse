import 'package:luna_lighthouse/core.dart';
import 'package:luna_lighthouse/modules/radarr.dart';

extension RadarrQualityProfileExtension on RadarrQualityProfile {
  String? get lunaName {
    if (this.name != null && this.name!.isNotEmpty) return this.name;
    return LunaUI.TEXT_EMDASH;
  }
}
