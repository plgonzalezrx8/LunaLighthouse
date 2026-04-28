import 'package:flutter/material.dart';
import 'package:luna_lighthouse/core.dart';
import 'package:luna_lighthouse/modules/sonarr.dart';

class SonarrSeriesEditSeasonFoldersTile extends StatelessWidget {
  const SonarrSeriesEditSeasonFoldersTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LunaBlock(
      title: 'sonarr.UseSeasonFolders'.tr(),
      trailing: LunaSwitch(
        value: context.watch<SonarrSeriesEditState>().useSeasonFolders,
        onChanged: (value) {
          context.read<SonarrSeriesEditState>().useSeasonFolders = value;
        },
      ),
    );
  }
}
