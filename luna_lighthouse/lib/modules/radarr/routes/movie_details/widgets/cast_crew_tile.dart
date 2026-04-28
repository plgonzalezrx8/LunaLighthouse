import 'package:flutter/material.dart';
import 'package:luna_lighthouse/core.dart';
import 'package:luna_lighthouse/extensions/string/links.dart';
import 'package:luna_lighthouse/modules/radarr.dart';

class RadarrMovieDetailsCastCrewTile extends StatelessWidget {
  final RadarrMovieCredits credits;

  const RadarrMovieDetailsCastCrewTile({
    super.key,
    required this.credits,
  });

  @override
  Widget build(BuildContext context) {
    return LunaBlock(
      title: credits.personName,
      posterPlaceholderIcon: LunaIcons.USER,
      posterUrl: credits.images!.isEmpty ? null : credits.images![0].url,
      body: [
        TextSpan(text: _position),
        TextSpan(
          text: credits.type!.readable,
          style: TextStyle(
            fontWeight: LunaUI.FONT_WEIGHT_BOLD,
            color: credits.type == RadarrCreditType.CAST
                ? LunaColours.accent
                : LunaColours.orange,
          ),
        ),
      ],
      onTap: credits.personTmdbId?.toString().openTmdbPerson,
    );
  }

  String? get _position {
    switch (credits.type) {
      case RadarrCreditType.CREW:
        return credits.job!.isEmpty ? LunaUI.TEXT_EMDASH : credits.job;
      case RadarrCreditType.CAST:
        return credits.character!.isEmpty
            ? LunaUI.TEXT_EMDASH
            : credits.character;
      default:
        return LunaUI.TEXT_EMDASH;
    }
  }
}
