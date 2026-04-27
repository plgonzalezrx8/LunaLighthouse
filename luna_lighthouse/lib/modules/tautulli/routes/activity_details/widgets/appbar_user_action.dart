import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:luna_lighthouse/core.dart';
import 'package:luna_lighthouse/modules/tautulli.dart';
import 'package:luna_lighthouse/router/routes/tautulli.dart';

class TautulliActivityDetailsUserAction extends StatelessWidget {
  final int sessionKey;

  const TautulliActivityDetailsUserAction({
    super.key,
    required this.sessionKey,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.select<TautulliState, Future<TautulliActivity?>>(
          (state) => state.activity!),
      builder: (context, AsyncSnapshot<TautulliActivity?> snapshot) {
        if (snapshot.hasError) return Container();
        if (snapshot.hasData) {
          TautulliSession? session = snapshot.data!.sessions!
              .firstWhereOrNull((element) => element.sessionKey == sessionKey);
          if (session != null)
            return LunaIconButton(
              icon: Icons.person_rounded,
              onPressed: () async => _onPressed(context, session.userId!),
            );
        }
        return Container();
      },
    );
  }

  void _onPressed(BuildContext context, int userId) {
    TautulliRoutes.USER_DETAILS.go(params: {
      'user': userId.toString(),
    });
  }
}
