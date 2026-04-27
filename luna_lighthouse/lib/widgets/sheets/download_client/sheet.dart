import 'package:flutter/material.dart';
import 'package:luna_lighthouse/database/models/profile.dart';
import 'package:luna_lighthouse/modules.dart';
import 'package:luna_lighthouse/modules/nzbget.dart';
import 'package:luna_lighthouse/modules/sabnzbd/routes.dart';
import 'package:luna_lighthouse/utils/dialogs.dart';
import 'package:luna_lighthouse/vendor.dart';
import 'package:luna_lighthouse/widgets/pages/invalid_route.dart';
import 'package:luna_lighthouse/widgets/ui.dart';

class DownloadClientSheet extends LunaBottomModalSheet {
  Future<LunaModule?> getDownloadClient() async {
    final profile = LunaProfile.current;
    final nzbget = profile.nzbgetEnabled;
    final sabnzbd = profile.sabnzbdEnabled;

    if (nzbget && sabnzbd) {
      return LunaDialogs().selectDownloadClient();
    }
    if (nzbget) {
      return LunaModule.NZBGET;
    }
    if (sabnzbd) {
      return LunaModule.SABNZBD;
    }

    return null;
  }

  @override
  Future<dynamic> show({
    Widget Function(BuildContext context)? builder,
  }) async {
    final module = await getDownloadClient();
    if (module != null) {
      return showModal(builder: (context) {
        if (module == LunaModule.SABNZBD) {
          return const SABnzbdRoute(showDrawer: false);
        }
        if (module == LunaModule.NZBGET) {
          return const NZBGetRoute(showDrawer: false);
        }
        return InvalidRoutePage();
      });
    }
  }
}
