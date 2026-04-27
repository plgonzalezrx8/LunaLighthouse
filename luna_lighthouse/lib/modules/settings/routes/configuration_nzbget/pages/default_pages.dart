import 'package:flutter/material.dart';
import 'package:luna_lighthouse/core.dart';
import 'package:luna_lighthouse/database/tables/nzbget.dart';
import 'package:luna_lighthouse/modules/nzbget.dart';

class ConfigurationNZBGetDefaultPagesRoute extends StatefulWidget {
  const ConfigurationNZBGetDefaultPagesRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<ConfigurationNZBGetDefaultPagesRoute> createState() => _State();
}

class _State extends State<ConfigurationNZBGetDefaultPagesRoute>
    with LunaScrollControllerMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return LunaScaffold(
      scaffoldKey: _scaffoldKey,
      appBar: _appBar() as PreferredSizeWidget?,
      body: _body(),
    );
  }

  Widget _appBar() {
    return LunaAppBar(
      title: 'settings.DefaultPages'.tr(),
      scrollControllers: [scrollController],
    );
  }

  Widget _body() {
    return LunaListView(
      controller: scrollController,
      children: [
        _homePage(),
      ],
    );
  }

  Widget _homePage() {
    const _db = NZBGetDatabase.NAVIGATION_INDEX;
    return _db.listenableBuilder(
      builder: (context, _) => LunaBlock(
        title: 'luna_lighthouse.Home'.tr(),
        body: [TextSpan(text: NZBGetNavigationBar.titles[_db.read()])],
        trailing: LunaIconButton(
          icon: NZBGetNavigationBar.icons[_db.read()],
        ),
        onTap: () async {
          List values = await NZBGetDialogs.defaultPage(context);
          if (values[0]) _db.update(values[1]);
        },
      ),
    );
  }
}
