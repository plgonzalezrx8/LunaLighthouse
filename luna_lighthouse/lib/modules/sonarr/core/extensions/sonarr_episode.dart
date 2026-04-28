import 'package:flutter/material.dart';
import 'package:luna_lighthouse/core.dart';
import 'package:luna_lighthouse/extensions/int/bytes.dart';
import 'package:luna_lighthouse/modules/sonarr.dart';

extension SonarrEpisodeExtension on SonarrEpisode {
  bool _hasAired() {
    return this.airDateUtc?.toLocal().isAfter(DateTime.now()) ?? true;
  }

  /// Creates a clone of the [SonarrEpisode] object (deep copy).
  SonarrEpisode clone() => SonarrEpisode.fromJson(this.toJson());

  String lunaAirDate() {
    if (this.airDateUtc == null) return 'luna_lighthouse.UnknownDate'.tr();
    return DateFormat.yMMMMd().format(this.airDateUtc!.toLocal());
  }

  String lunaDownloadedQuality(
    SonarrEpisodeFile? file,
    SonarrQueueRecord? queueRecord,
  ) {
    if (queueRecord != null) {
      return [
        queueRecord.lunaPercentage(),
        LunaUI.TEXT_EMDASH,
        queueRecord.lunaStatusParameters().item1,
      ].join(' ');
    }

    if (!this.hasFile!) {
      if (_hasAired()) return 'sonarr.Unaired'.tr();
      return 'sonarr.Missing'.tr();
    }
    if (file == null) return 'luna_lighthouse.Unknown'.tr();
    String quality =
        file.quality?.quality?.name ?? 'luna_lighthouse.Unknown'.tr();
    String size = file.size?.asBytes() ?? '0.00 B';
    return '$quality ${LunaUI.TEXT_EMDASH} $size';
  }

  Color lunaDownloadedQualityColor(
    SonarrEpisodeFile? file,
    SonarrQueueRecord? queueRecord,
  ) {
    if (queueRecord != null) {
      return queueRecord.lunaStatusParameters(canBeWhite: false).item3;
    }

    if (!this.hasFile!) {
      if (_hasAired()) return LunaColours.blue;
      return LunaColours.red;
    }
    if (file == null) return LunaColours.blueGrey;
    if (file.qualityCutoffNotMet!) return LunaColours.orange;
    return LunaColours.accent;
  }

  String lunaSeasonEpisode() {
    String season = this.seasonNumber != null
        ? 'sonarr.SeasonNumber'.tr(
            args: [this.seasonNumber.toString()],
          )
        : 'luna_lighthouse.Unknown'.tr();
    String episode = this.episodeNumber != null
        ? 'sonarr.EpisodeNumber'.tr(
            args: [this.episodeNumber.toString()],
          )
        : 'luna_lighthouse.Unknown'.tr();
    return '$season ${LunaUI.TEXT_BULLET} $episode';
  }
}
