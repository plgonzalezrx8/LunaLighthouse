import 'package:luna_lighthouse/core.dart';
import 'package:luna_lighthouse/modules/tautulli.dart';

extension LunaTautulliTranscodeDecisionExtension on TautulliTranscodeDecision? {
  String get localizedName {
    switch (this) {
      case TautulliTranscodeDecision.TRANSCODE:
        return 'tautulli.Transcode'.tr();
      case TautulliTranscodeDecision.COPY:
        return 'tautulli.DirectStream'.tr();
      case TautulliTranscodeDecision.DIRECT_PLAY:
        return 'tautulli.DirectPlay'.tr();
      case TautulliTranscodeDecision.BURN:
        return 'tautulli.Burn'.tr();
      case TautulliTranscodeDecision.NULL:
      default:
        return 'tautulli.None'.tr();
    }
  }
}
