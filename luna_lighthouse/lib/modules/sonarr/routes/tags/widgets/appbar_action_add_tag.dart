import 'package:flutter/material.dart';
import 'package:luna_lighthouse/core.dart';
import 'package:luna_lighthouse/modules/sonarr.dart';

class SonarrTagsAppBarActionAddTag extends StatelessWidget {
  final bool asDialogButton;

  const SonarrTagsAppBarActionAddTag({
    super.key,
    this.asDialogButton = false,
  });

  @override
  Widget build(BuildContext context) {
    if (asDialogButton)
      return LunaDialog.button(
        text: 'luna_lighthouse.Add'.tr(),
        textColor: Colors.white,
        onPressed: () async => _onPressed(context),
      );
    return LunaIconButton(
      icon: Icons.add_rounded,
      onPressed: () async => _onPressed(context),
    );
  }

  Future<void> _onPressed(BuildContext context) async {
    Tuple2<bool, String> result = await SonarrDialogs().addNewTag(context);
    if (result.item1)
      SonarrAPIController()
          .addTag(context: context, label: result.item2)
          .then((value) {
        if (value) context.read<SonarrState>().fetchTags();
      });
  }
}
