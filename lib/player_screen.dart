import 'package:flutter/material.dart';
import 'package:inventory/data/model.dart';
import 'package:inventory/widgets/player_screen/player_appbar.dart';

class PlayerScreen extends StatelessWidget {
  final Spieler player;

  const PlayerScreen({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade400,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: PlayerAppBar(playerId: player.id!),
      ),
      body: Container(
        child: Text('bla'),
      ),
    );
  }
}
