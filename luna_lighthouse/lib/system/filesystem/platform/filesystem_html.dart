import 'dart:js_interop';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:luna_lighthouse/system/filesystem/file.dart';
import 'package:luna_lighthouse/system/filesystem/filesystem.dart';
import 'package:luna_lighthouse/system/logger.dart';
import 'package:luna_lighthouse/vendor.dart';
import 'package:luna_lighthouse/widgets/ui.dart';
import 'package:web/web.dart' as web;

bool isPlatformSupported() => true;
LunaFileSystem getFileSystem() {
  if (isPlatformSupported()) return _Web();
  throw UnsupportedError('LunaFileSystem unsupported');
}

class _Web implements LunaFileSystem {
  @override
  Future<void> nuke() async {}

  @override
  Future<bool> save(BuildContext context, String name, List<int> data) async {
    try {
      final blob = web.Blob(
        <web.BlobPart>[Uint8List.fromList(data).toJS].toJS,
        web.BlobPropertyBag(type: 'application/octet-stream'),
      );
      final url = web.URL.createObjectURL(blob);
      final anchor = web.HTMLAnchorElement()
        ..href = url
        ..download = name;

      web.document.body?.appendChild(anchor);
      anchor.click();
      anchor.remove();
      web.URL.revokeObjectURL(url);
      return true;
    } catch (error, stack) {
      LunaLogger().error('Failed to save to filesystem', error, stack);
      rethrow;
    }
  }

  @override
  Future<LunaFile?> read(BuildContext context, List<String> extensions) async {
    try {
      final result = await FilePicker.platform.pickFiles(withData: true);

      if (result?.files.isNotEmpty ?? false) {
        String? _ext = result!.files[0].extension;
        if (LunaFileSystem.isValidExtension(extensions, _ext)) {
          return LunaFile(
            name: result.files[0].name,
            data: result.files[0].bytes!,
          );
        } else {
          showLunaErrorSnackBar(
            title: 'luna_lighthouse.InvalidFileTypeSelected'.tr(),
            message: extensions.map((s) => '.$s').join(', '),
          );
        }
      }

      return null;
    } catch (error, stack) {
      LunaLogger().error('Failed to read from filesystem', error, stack);
      rethrow;
    }
  }
}
