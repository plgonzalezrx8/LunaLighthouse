import 'package:luna_lighthouse/core.dart';
import 'package:luna_lighthouse/modules/sonarr.dart';

extension SonarrCalendarExtension on SonarrCalendar {
  String get lunaAirTime {
    if (this.airDateUtc != null)
      return LunaLighthouseDatabase.USE_24_HOUR_TIME.read()
          ? DateFormat.Hm().format(this.airDateUtc!.toLocal())
          : DateFormat('hh:mm\na').format(this.airDateUtc!.toLocal());
    return LunaUI.TEXT_EMDASH;
  }

  bool get lunaHasAired {
    if (this.airDateUtc != null)
      return DateTime.now().isAfter(this.airDateUtc!.toLocal());
    return false;
  }
}
