import 'package:flutter/material.dart';
import 'package:luna_lighthouse/core.dart';
import 'package:luna_lighthouse/modules/tautulli.dart';

class TautulliLogsNewslettersState extends ChangeNotifier {
  TautulliLogsNewslettersState(BuildContext context) {
    fetchLogs(context);
  }

  Future<TautulliNewsletterLogs>? _logs;
  Future<TautulliNewsletterLogs>? get logs => _logs;
  Future<void> fetchLogs(BuildContext context) async {
    if (context.read<TautulliState>().enabled) {
      _logs = context.read<TautulliState>().api!.notifications.getNewsletterLog(
            length: TautulliDatabase.CONTENT_LOAD_LENGTH.read(),
          );
    }
    notifyListeners();
  }
}
