import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/group_overview_bloc/group_overview_bloc.dart';
import '../../bloc/group_overview_bloc/group_overview_events.dart';

class PlayerAppBar extends StatelessWidget {
  final int playerId;

  const PlayerAppBar({super.key, required this.playerId});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.delete_forever, color: Colors.black),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Spieler löschen'),
                content: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Möchtest du den Spieler wirklich löschen?'),
                  ],
                ),
                actions: [
                  TextButton(
                    child: const Text('Abbrechen'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text('Löschen'),
                    onPressed: () {
                      context
                          .read<GroupOverviewBloc>()
                          .add(DeletePlayer(playerId));
                      Navigator.of(context)
                          .popUntil((route) => route.isFirst);
                    },
                  ),
                ],
              ),
            );
          },
        )
      ],
    );
  }
}
