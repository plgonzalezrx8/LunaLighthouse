import 'package:flutter/material.dart';

import 'package:luna_lighthouse/core.dart';
import 'package:luna_lighthouse/router/routes/settings.dart';

class AboutRoute extends StatefulWidget {
  const AboutRoute({
    super.key,
  });

  @override
  State<AboutRoute> createState() => _State();
}

class _State extends State<AboutRoute> with LunaScrollControllerMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late final Future<PackageInfo> _packageInfo = PackageInfo.fromPlatform();

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
      title: 'settings.About'.tr(),
      scrollControllers: [scrollController],
    );
  }

  Widget _body() {
    return FutureBuilder<PackageInfo>(
      future: _packageInfo,
      builder: (context, snapshot) {
        final info = snapshot.data;
        final version = info?.version ?? 'luna_lighthouse.Unknown'.tr();
        final build = info?.buildNumber ?? 'luna_lighthouse.Unknown'.tr();
        final packageName = info?.packageName ?? 'luna_lighthouse.Unknown'.tr();

        return LunaListView(
          controller: scrollController,
          children: [
            _brandHeader(version, build),
            LunaBlock(
              title: 'settings.Version'.tr(),
              body: [TextSpan(text: version)],
              trailing: const LunaIconButton(icon: Icons.new_releases_rounded),
            ),
            LunaBlock(
              title: 'settings.Build'.tr(),
              body: [TextSpan(text: build)],
              trailing: const LunaIconButton(icon: Icons.numbers_rounded),
            ),
            LunaBlock(
              title: 'settings.Package'.tr(),
              body: [TextSpan(text: packageName)],
              trailing: const LunaIconButton(icon: Icons.inventory_2_rounded),
            ),
            LunaBlock(
              title: 'settings.License'.tr(),
              body: [TextSpan(text: 'settings.LicenseDescription'.tr())],
              customBodyMaxLines: 2,
              trailing: const LunaIconButton(icon: Icons.description_rounded),
            ),
            LunaBlock(
              title: 'settings.OpenSource'.tr(),
              body: [TextSpan(text: 'settings.OpenSourceDescription'.tr())],
              customBodyMaxLines: 2,
              trailing: const LunaIconButton(icon: Icons.code_rounded),
              onTap: SettingsRoutes.ABOUT_OPEN_SOURCE.go,
            ),
          ],
        );
      },
    );
  }

  Widget _brandHeader(String version, String build) {
    return Padding(
      padding: LunaUI.MARGIN_DEFAULT,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(LunaUI.BORDER_RADIUS),
            child: Image.asset(
              LunaAssets.appIcon,
              height: 104.0,
              width: 104.0,
              semanticLabel: 'LunaLighthouse',
            ),
          ),
          const SizedBox(height: LunaUI.DEFAULT_MARGIN_SIZE),
          LunaText.title(
            text: 'LunaLighthouse',
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
          const SizedBox(height: LunaUI.MARGIN_SIZE_HALF),
          LunaText.subtitle(
            text: 'settings.VersionBuild'.tr(args: [version, build]),
            textAlign: TextAlign.center,
            maxLines: 2,
            softWrap: true,
            overflow: TextOverflow.visible,
          ),
        ],
      ),
    );
  }
}
