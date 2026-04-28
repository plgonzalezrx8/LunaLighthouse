import 'package:flutter/material.dart';
import 'package:luna_lighthouse/core.dart';
import 'package:luna_lighthouse/modules/tautulli.dart';

class TautulliActivityStatus extends StatelessWidget {
  final TautulliActivity? activity;

  const TautulliActivityStatus({
    required this.activity,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LunaHeader(
      text: activity!.lunaSessionsHeader,
      subtitle: [
        activity!.lunaSessions,
        activity!.lunaBandwidth,
      ].join('\n'),
    );
  }
}
