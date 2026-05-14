import 'package:flutter/material.dart';

import 'package:luna_lighthouse/core.dart';

class ComingSoonRoute extends StatefulWidget {
  const ComingSoonRoute({
    super.key,
  });

  @override
  State<ComingSoonRoute> createState() => _State();
}

class _State extends State<ComingSoonRoute> with LunaScrollControllerMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return LunaScaffold(
      scaffoldKey: _scaffoldKey,
      appBar: _appBar(),
      body: _body(),
    );
  }

  PreferredSizeWidget _appBar() {
    return LunaAppBar(
      title: 'settings.ComingSoon'.tr(),
      scrollControllers: [scrollController],
    );
  }

  Widget _body() {
    return LunaListView(
      controller: scrollController,
      children: [
        LunaBlock(
          title: 'settings.ComingSoon'.tr(),
          body: [TextSpan(text: 'settings.ComingSoonDescription'.tr())],
          customBodyMaxLines: 2,
          trailing: const LunaIconButton(icon: Icons.upcoming_rounded),
        ),
        LunaDivider(),
        _deferredFeatureBlock(
          title: 'settings.ComingSoonCloudAccount'.tr(),
          body: 'settings.ComingSoonCloudAccountDescription'.tr(),
          icon: Icons.account_circle_rounded,
        ),
        _deferredFeatureBlock(
          title: 'settings.ComingSoonCloudSync'.tr(),
          body: 'settings.ComingSoonCloudSyncDescription'.tr(),
          icon: LunaIcons.CLOUD_UPLOAD,
        ),
        _deferredFeatureBlock(
          title: 'settings.ComingSoonHostedPushNotifications'.tr(),
          body: 'settings.ComingSoonHostedPushNotificationsDescription'.tr(),
          icon: Icons.notifications_paused_rounded,
        ),
        _deferredFeatureBlock(
          title: 'settings.ComingSoonNotificationRelay'.tr(),
          body: 'settings.ComingSoonNotificationRelayDescription'.tr(),
          icon: Icons.webhook_rounded,
        ),
      ],
    );
  }

  Widget _deferredFeatureBlock({
    required String title,
    required String body,
    required IconData icon,
  }) {
    return LunaBlock(
      disabled: true,
      title: title,
      body: [TextSpan(text: body)],
      customBodyMaxLines: 2,
      trailing: LunaIconButton(icon: icon),
    );
  }
}
