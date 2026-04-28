import 'package:flutter/material.dart';
import 'package:luna_lighthouse/core.dart';
import 'package:luna_lighthouse/modules/radarr.dart';
import 'package:luna_lighthouse/router/routes/radarr.dart';

class RadarrManualImportBottomActionBar extends StatelessWidget {
  const RadarrManualImportBottomActionBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LunaBottomActionBar(
      actions: [
        LunaButton.text(
          text: 'radarr.Quick'.tr(),
          icon: Icons.search_rounded,
          onTap: () async => RadarrAPIHelper().quickImport(
            context: context,
            path: context.read<RadarrManualImportState>().currentPath,
          ),
        ),
        LunaButton.text(
          text: 'radarr.Interactive'.tr(),
          icon: Icons.person_rounded,
          onTap: () => RadarrRoutes.MANUAL_IMPORT_DETAILS.go(queryParams: {
            'path': context.read<RadarrManualImportState>().currentPath,
          }),
        ),
      ],
    );
  }
}
