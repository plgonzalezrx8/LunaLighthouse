import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:luna_lighthouse/modules/dashboard/core/state.dart';
import 'package:luna_lighthouse/modules/lidarr/core/state.dart';
import 'package:luna_lighthouse/modules/radarr/core/state.dart';
import 'package:luna_lighthouse/modules/search/core/state.dart';
import 'package:luna_lighthouse/modules/settings/core/state.dart';
import 'package:luna_lighthouse/modules/sonarr/core/state.dart';
import 'package:luna_lighthouse/modules/sabnzbd/core/state.dart';
import 'package:luna_lighthouse/modules/nzbget/core/state.dart';
import 'package:luna_lighthouse/modules/tautulli/core/state.dart';
import 'package:luna_lighthouse/modules.dart';
import 'package:luna_lighthouse/router/router.dart';

class LunaState {
  LunaState._();

  static BuildContext get context => LunaRouter.navigator.currentContext!;

  /// Calls `.reset()` on all states which extend [LunaModuleState].
  static void reset([BuildContext? context]) {
    final ctx = context ?? LunaState.context;
    LunaModule.values.forEach((module) => module.state(ctx)?.reset());
  }

  static MultiProvider providers({required Widget child}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DashboardState()),
        ChangeNotifierProvider(create: (_) => SettingsState()),
        ChangeNotifierProvider(create: (_) => SearchState()),
        ChangeNotifierProvider(create: (_) => LidarrState()),
        ChangeNotifierProvider(create: (_) => RadarrState()),
        ChangeNotifierProvider(create: (_) => SonarrState()),
        ChangeNotifierProvider(create: (_) => NZBGetState()),
        ChangeNotifierProvider(create: (_) => SABnzbdState()),
        ChangeNotifierProvider(create: (_) => TautulliState()),
      ],
      child: child,
    );
  }
}

abstract class LunaModuleState extends ChangeNotifier {
  /// Reset the state back to the default
  void reset();

  /// Whether a configured module host can be used as a native Dio base URL.
  ///
  /// Dio accepts relative URLs on web, but native platforms require an absolute
  /// URL. Treat incomplete settings as an unconfigured module instead of
  /// throwing during provider creation.
  @protected
  bool hasUsableApiHost(String host) {
    final uri = Uri.tryParse(host.trim());
    return uri != null &&
        uri.hasAuthority &&
        (uri.isScheme('http') || uri.isScheme('https'));
  }
}
