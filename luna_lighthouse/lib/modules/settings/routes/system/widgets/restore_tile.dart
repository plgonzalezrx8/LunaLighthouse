import 'package:flutter/material.dart';

import 'package:luna_lighthouse/core.dart';
import 'package:luna_lighthouse/database/config.dart';
import 'package:luna_lighthouse/system/filesystem/file.dart';
import 'package:luna_lighthouse/system/filesystem/filesystem.dart';

class SettingsSystemBackupRestoreRestoreTile extends StatelessWidget {
  const SettingsSystemBackupRestoreRestoreTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LunaBlock(
      title: 'settings.RestoreFromDevice'.tr(),
      body: [TextSpan(text: 'settings.RestoreFromDeviceDescription'.tr())],
      trailing: const LunaIconButton(icon: Icons.download_rounded),
      onTap: () async => _restore(context),
    );
  }

  Future<void> _restore(BuildContext context) async {
    try {
      LunaFile? file = await LunaFileSystem().read(context, ['lunalighthouse']);
      if (file != null) await _decryptBackup(context, file);
    } catch (error, stack) {
      LunaLogger().error('Failed to restore device backup', error, stack);
      showLunaErrorSnackBar(
        title: 'settings.RestoreFromDevice'.tr(),
        error: error,
      );
    }
  }

  Future<void> _decryptBackup(
    BuildContext context,
    LunaFile file,
  ) async {
    String encrypted = String.fromCharCodes(file.data);
    try {
      await LunaConfig().import(context, encrypted);
      showLunaSuccessSnackBar(
        title: 'settings.RestoreFromDevice'.tr(),
        message: 'settings.ConfigurationDescription'.tr(),
      );
    } catch (_) {
      showLunaErrorSnackBar(
        title: 'settings.RestoreFromDevice'.tr(),
        message: 'luna_lighthouse.IncorrectEncryptionKey'.tr(),
        showButton: true,
        buttonText: 'luna_lighthouse.Retry'.tr(),
        buttonOnPressed: () async => _decryptBackup(context, file),
      );
    }
  }
}
