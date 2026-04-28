import 'package:flutter/material.dart';
import 'package:luna_lighthouse/core.dart';
import 'package:luna_lighthouse/modules/tautulli.dart';

class TautulliAppBarGlobalSettingsAction extends StatelessWidget {
  const TautulliAppBarGlobalSettingsAction({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LunaIconButton(
      icon: Icons.more_vert_rounded,
      onPressed: () async {
        Tuple2<bool, TautulliGlobalSettingsType?> values =
            await TautulliDialogs().globalSettings(context);
        if (values.item1) values.item2!.execute(context);
      },
    );
  }
}
