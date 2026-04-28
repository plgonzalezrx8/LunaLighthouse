import 'package:flutter/material.dart';
import 'package:luna_lighthouse/modules.dart';
import 'package:luna_lighthouse/modules/settings.dart';

class ConfigurationSonarrConnectionDetailsHeadersRoute extends StatelessWidget {
  const ConfigurationSonarrConnectionDetailsHeadersRoute({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SettingsHeaderRoute(module: LunaModule.SONARR);
  }
}
