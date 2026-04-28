import 'package:flutter/material.dart';
import 'package:luna_lighthouse/core.dart';
import 'package:luna_lighthouse/modules/radarr.dart';

class RadarrMovieDetailsFilesExtraFileBlock extends StatelessWidget {
  final RadarrExtraFile file;

  const RadarrMovieDetailsFilesExtraFileBlock({
    super.key,
    required this.file,
  });

  @override
  Widget build(BuildContext context) {
    return LunaTableCard(
      content: [
        LunaTableContent(title: 'relative path', body: file.lunaRelativePath),
        LunaTableContent(title: 'type', body: file.lunaType),
        LunaTableContent(title: 'extension', body: file.lunaExtension),
      ],
    );
  }
}
