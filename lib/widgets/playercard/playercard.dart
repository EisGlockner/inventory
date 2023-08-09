import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory/widgets/playercard/health_iconbutton.dart';
import 'package:inventory/widgets/playercard/money_iconbutton.dart';
import 'package:inventory/widgets/playercard/pain_icon.dart';
import 'package:inventory/widgets/playercard/provision_iconbutton.dart';

import '../../bloc/group_overview_bloc/group_overview_bloc.dart';
import '../../bloc/group_overview_bloc/group_overview_states.dart';
import 'mana_iconbutton.dart';

class GroupOverviewPlayer extends StatelessWidget {
  const GroupOverviewPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupOverviewBloc, PlayerOverviewState>(
      builder: (context, state) {
        if (state is PlayerOverviewLoading) {
          return const CircularProgressIndicator(
            color: Colors.grey,
          );
        } else if (state is PlayerOverviewLoaded) {
          if (state.players.isNotEmpty) {
            return Column(
              children: state.players
                  .map(
                    (player) => Column(
                      children: [
                        const Padding(padding: EdgeInsets.only(bottom: 15)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(player.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500)),
                            MoneyIcon(
                              money: [
                                player.dukaten,
                                player.silber,
                                player.heller,
                                player.kreuzer,
                              ],
                              playerId: player.id,
                            ),
                          ],
                        ),
                        const Padding(padding: EdgeInsets.only(bottom: 8)),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 20),
                        ),
                        Row(
                          children: [
                            HealthIcon(
                                playerId: player.id,
                                currentHealth: player.leben,
                                maxHealth: player.maxLeben),
                            ManaIcon(
                              player: player,
                              currentMana: player.mana,
                            ),
                            PainIcon(currentHealth: player.leben),
                            ProvisionIcon(
                                playerId: player.id,
                                currentProvision: player.proviant),
                          ],
                        ),
                        const Padding(padding: EdgeInsets.only(bottom: 15)),
                        const Divider(
                          color: Colors.black,
                          thickness: 1,
                        ),
                      ],
                    ),
                  )
                  .toList(),
            );
          } else {
            return const Center(
              child: Text(
                'Keine Spieler vorhanden',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            );
          }
        } else {
          return const Text('Error');
        }
      },
    );
  }
}
