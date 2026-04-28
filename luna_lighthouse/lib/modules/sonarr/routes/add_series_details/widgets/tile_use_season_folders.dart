import 'package:flutter/material.dart';
import 'package:luna_lighthouse/core.dart';
import 'package:luna_lighthouse/modules/sonarr.dart';

class SonarrSeriesAddDetailsUseSeasonFoldersTile extends StatelessWidget {
  const SonarrSeriesAddDetailsUseSeasonFoldersTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LunaBlock(
      title: 'sonarr.SeasonFolders'.tr(),
      trailing: LunaSwitch(
        value: context.watch<SonarrSeriesAddDetailsState>().useSeasonFolders,
        onChanged: (value) {
          context.read<SonarrSeriesAddDetailsState>().useSeasonFolders = value;
          SonarrDatabase.ADD_SERIES_DEFAULT_USE_SEASON_FOLDERS.update(value);
        },
      ),
    );
  }
}
