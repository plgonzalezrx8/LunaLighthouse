import 'package:flutter/material.dart';
import 'package:luna_lighthouse/core.dart';
import 'package:luna_lighthouse/modules/radarr.dart';

class RadarrMoviesEditMinimumAvailabilityTile extends StatelessWidget {
  const RadarrMoviesEditMinimumAvailabilityTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Selector<RadarrMoviesEditState, RadarrAvailability>(
      selector: (_, state) => state.availability,
      builder: (context, availability, _) => LunaBlock(
        title: 'radarr.MinimumAvailability'.tr(),
        body: [TextSpan(text: availability.readable)],
        trailing: const LunaIconButton.arrow(),
        onTap: () async {
          Tuple2<bool, RadarrAvailability?> _values =
              await RadarrDialogs().editMinimumAvailability(context);
          if (_values.item1)
            context.read<RadarrMoviesEditState>().availability = _values.item2!;
        },
      ),
    );
  }
}
