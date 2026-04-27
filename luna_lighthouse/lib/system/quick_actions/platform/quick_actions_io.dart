import 'package:luna_lighthouse/database/tables/luna_lighthouse.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:luna_lighthouse/modules.dart';
import 'package:luna_lighthouse/system/platform.dart';

// ignore: always_use_package_imports
import '../quick_actions.dart';

bool isPlatformSupported() => LunaPlatform.isMobile;
LunaQuickActions getQuickActions() {
  if (isPlatformSupported()) return IO();
  throw UnsupportedError('LunaQuickActions unsupported');
}

class IO implements LunaQuickActions {
  final QuickActions _quickActions = const QuickActions();

  @override
  Future<void> initialize() async {
    _quickActions.initialize(actionHandler);
    setActionItems();
  }

  @override
  void actionHandler(String action) {
    LunaModule.fromKey(action)?.launch();
  }

  @override
  void setActionItems() {
    _quickActions.setShortcutItems(<ShortcutItem>[
      if (LunaLighthouseDatabase.QUICK_ACTIONS_TAUTULLI.read())
        LunaModule.TAUTULLI.shortcutItem,
      if (LunaLighthouseDatabase.QUICK_ACTIONS_SONARR.read())
        LunaModule.SONARR.shortcutItem,
      if (LunaLighthouseDatabase.QUICK_ACTIONS_SEARCH.read())
        LunaModule.SEARCH.shortcutItem,
      if (LunaLighthouseDatabase.QUICK_ACTIONS_SABNZBD.read())
        LunaModule.SABNZBD.shortcutItem,
      if (LunaLighthouseDatabase.QUICK_ACTIONS_RADARR.read())
        LunaModule.RADARR.shortcutItem,
      if (LunaLighthouseDatabase.QUICK_ACTIONS_OVERSEERR.read())
        LunaModule.OVERSEERR.shortcutItem,
      if (LunaLighthouseDatabase.QUICK_ACTIONS_NZBGET.read())
        LunaModule.NZBGET.shortcutItem,
      if (LunaLighthouseDatabase.QUICK_ACTIONS_LIDARR.read())
        LunaModule.LIDARR.shortcutItem,
      LunaModule.SETTINGS.shortcutItem,
    ]);
  }
}
