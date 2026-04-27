import 'package:flutter/material.dart';
import 'package:luna_lighthouse/core.dart';
import 'package:luna_lighthouse/modules/sonarr.dart';

class SonarrSeriesEditTagsTile extends StatelessWidget {
  const SonarrSeriesEditTagsTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LunaBlock(
      title: 'sonarr.Tags'.tr(),
      body: [
        TextSpan(
          text: (context.watch<SonarrSeriesEditState>().tags?.isEmpty ?? true)
              ? 'luna_lighthouse.NotSet'.tr()
              : context
                  .watch<SonarrSeriesEditState>()
                  .tags
                  ?.map((e) => e.label)
                  .join(', '),
        )
      ],
      trailing: const LunaIconButton.arrow(),
      onTap: () async => await SonarrDialogs().setEditTags(context),
    );
  }
}
