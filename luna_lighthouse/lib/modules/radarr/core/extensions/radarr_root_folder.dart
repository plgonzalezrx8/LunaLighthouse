import 'package:luna_lighthouse/core.dart';
import 'package:luna_lighthouse/extensions/int/bytes.dart';
import 'package:luna_lighthouse/modules/radarr.dart';

extension LunaRadarrRootFolderExtension on RadarrRootFolder? {
  String get lunaPath {
    if (this?.path?.isNotEmpty ?? false) return this!.path!;
    return LunaUI.TEXT_EMDASH;
  }

  String get lunaSpace {
    return this?.freeSpace.asBytes() ?? LunaUI.TEXT_EMDASH;
  }

  String get lunaUnmappedFolders {
    int length = this?.unmappedFolders?.length ?? 0;
    if (this!.unmappedFolders!.length == 1) return 'radarr.UnmappedFolder'.tr();
    return 'radarr.UnmappedFolders'.tr(args: [length.toString()]);
  }
}
