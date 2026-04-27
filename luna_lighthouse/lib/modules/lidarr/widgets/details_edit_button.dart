import 'package:flutter/material.dart';
import 'package:luna_lighthouse/core.dart';
import 'package:luna_lighthouse/modules/lidarr.dart';
import 'package:luna_lighthouse/router/routes/lidarr.dart';

class LidarrDetailsEditButton extends StatefulWidget {
  final LidarrCatalogueData? data;

  const LidarrDetailsEditButton({
    super.key,
    required this.data,
  });

  @override
  State<LidarrDetailsEditButton> createState() => _State();
}

class _State extends State<LidarrDetailsEditButton> {
  @override
  Widget build(BuildContext context) => Consumer<LidarrState>(
        builder: (context, model, widget) => LunaIconButton(
          icon: Icons.edit_rounded,
          onPressed: () async => _enterEditArtist(context),
        ),
      );

  Future<void> _enterEditArtist(BuildContext context) async {
    LidarrRoutes.ARTIST_EDIT.go(
      extra: widget.data,
      params: {
        'artist': widget.data!.artistID.toString(),
      },
    );
  }
}
