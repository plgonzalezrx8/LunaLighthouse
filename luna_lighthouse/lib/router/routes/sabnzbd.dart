import 'package:flutter/material.dart';
import 'package:luna_lighthouse/modules.dart';
import 'package:luna_lighthouse/modules/sabnzbd/core/api/data/history.dart';
import 'package:luna_lighthouse/modules/sabnzbd/routes/history_stages.dart';
import 'package:luna_lighthouse/modules/sabnzbd/routes/sabnzbd.dart';
import 'package:luna_lighthouse/modules/sabnzbd/routes/statistics.dart';
import 'package:luna_lighthouse/router/routes.dart';
import 'package:luna_lighthouse/vendor.dart';

enum SABnzbdRoutes with LunaRoutesMixin {
  HOME('/sabnzbd'),
  STATISTICS('statistics'),
  HISTORY_STAGES('history/stages');

  @override
  final String path;

  const SABnzbdRoutes(this.path);

  @override
  LunaModule get module => LunaModule.SABNZBD;

  @override
  bool isModuleEnabled(BuildContext context) => true;

  @override
  GoRoute get routes {
    switch (this) {
      case SABnzbdRoutes.HOME:
        return route(widget: const SABnzbdRoute());
      case SABnzbdRoutes.STATISTICS:
        return route(widget: const StatisticsRoute());
      case SABnzbdRoutes.HISTORY_STAGES:
        return route(builder: (_, state) {
          final history = state.extra as SABnzbdHistoryData?;
          return HistoryStagesRoute(history: history);
        });
    }
  }

  @override
  List<GoRoute> get subroutes {
    switch (this) {
      case SABnzbdRoutes.HOME:
        return [
          SABnzbdRoutes.STATISTICS.routes,
          SABnzbdRoutes.HISTORY_STAGES.routes,
        ];
      default:
        return const [];
    }
  }
}
