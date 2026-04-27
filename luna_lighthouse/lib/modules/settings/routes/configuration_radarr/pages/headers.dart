import 'package:flutter/material.dart';
import 'package:luna_lighthouse/modules.dart';
import 'package:luna_lighthouse/modules/settings.dart';

class ConfigurationRadarrConnectionDetailsHeadersRoute extends StatelessWidget {
  const ConfigurationRadarrConnectionDetailsHeadersRoute({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SettingsHeaderRoute(module: LunaModule.RADARR);
  }
}
