import 'package:luna_lighthouse/core.dart';
import 'package:luna_lighthouse/modules/sonarr.dart';

extension SonarrSeriesSeasonExtension on SonarrSeriesSeason {
  String get lunaTitle {
    if (this.seasonNumber == 0) return 'sonarr.Specials'.tr();
    return 'sonarr.SeasonNumber'.tr(args: [
      this.seasonNumber?.toString() ?? 'luna_lighthouse.Unknown'.tr(),
    ]);
  }

  int get lunaPercentageComplete {
    int _total = this.statistics?.episodeCount ?? 0;
    int _available = this.statistics?.episodeFileCount ?? 0;
    return _total == 0 ? 0 : ((_available / _total) * 100).round();
  }

  String get lunaEpisodesAvailable {
    return '${this.statistics?.episodeFileCount ?? 0}/${this.statistics?.episodeCount ?? 0}';
  }
}
