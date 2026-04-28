import 'package:luna_lighthouse/core.dart';

extension DoubleAsTimeExtension on double? {
  String asTimeAgo() {
    if (this == null || this! < 0) return LunaUI.TEXT_EMDASH;

    double hours = this!;
    double minutes = (this! * 60);
    double days = (this! / 24);

    if (minutes <= 2) {
      return 'luna_lighthouse.JustNow'.tr();
    }

    if (minutes <= 120) {
      return 'luna_lighthouse.MinutesAgo'
          .tr(args: [minutes.round().toString()]);
    }

    if (hours <= 48) {
      return 'luna_lighthouse.HoursAgo'.tr(args: [hours.toStringAsFixed(1)]);
    }

    return 'luna_lighthouse.DaysAgo'.tr(args: [days.round().toString()]);
  }
}
