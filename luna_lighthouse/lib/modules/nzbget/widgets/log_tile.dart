import 'package:flutter/material.dart';
import 'package:luna_lighthouse/core.dart';
import 'package:luna_lighthouse/modules/nzbget.dart';

class NZBGetLogTile extends StatelessWidget {
  final NZBGetLogData data;

  const NZBGetLogTile({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LunaBlock(
      title: data.text,
      body: [TextSpan(text: data.timestamp)],
      trailing: const LunaIconButton.arrow(),
      onTap: () async =>
          LunaDialogs().textPreview(context, 'Log Entry', data.text!),
    );
  }
}
