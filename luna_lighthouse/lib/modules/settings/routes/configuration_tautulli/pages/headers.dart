import 'package:flutter/material.dart';
import 'package:luna_lighthouse/modules.dart';
import 'package:luna_lighthouse/modules/settings.dart';

class ConfigurationTautulliConnectionDetailsHeadersRoute
    extends StatelessWidget {
  const ConfigurationTautulliConnectionDetailsHeadersRoute({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SettingsHeaderRoute(module: LunaModule.TAUTULLI);
  }
}
