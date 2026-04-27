import 'package:flutter/material.dart';

import 'package:luna_lighthouse/core.dart';
import 'package:luna_lighthouse/database/config.dart';
import 'package:luna_lighthouse/system/filesystem/filesystem.dart';

class SettingsSystemBackupRestoreBackupTile extends StatelessWidget {
  const SettingsSystemBackupRestoreBackupTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LunaBlock(
      title: 'settings.BackupToDevice'.tr(),
      body: [TextSpan(text: 'settings.BackupToDeviceDescription'.tr())],
      trailing: const LunaIconButton(icon: Icons.upload_rounded),
      onTap: () async => _backup(context),
    );
  }

  Future<void> _backup(BuildContext context) async {
    try {
      String data = LunaConfig().export();
      String name = DateFormat('y-MM-dd kk-mm-ss').format(DateTime.now());
      bool result = await LunaFileSystem().save(
        context,
        '$name.lunalighthouse',
        data.codeUnits,
      );
      if (result) {
        showLunaSuccessSnackBar(
          title: 'settings.BackupToDevice'.tr(),
          message: '$name.lunalighthouse',
        );
      }
    } catch (error, stack) {
      LunaLogger().error('Failed to create device backup', error, stack);
      showLunaErrorSnackBar(
        title: 'settings.BackupToDevice'.tr(),
        error: error,
      );
    }
  }
}
