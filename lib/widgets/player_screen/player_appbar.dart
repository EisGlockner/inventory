import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory/data/database_helper.dart';
import 'package:inventory/data/model.dart';

import '../../bloc/cubits/ability_selection_cubit.dart';
import '../../bloc/group_overview_bloc/group_overview_bloc.dart';
import '../../bloc/group_overview_bloc/group_overview_events.dart';
import 'ability_card.dart';

class PlayerAppBar extends StatelessWidget {
  final int playerId;

  const PlayerAppBar({super.key, required this.playerId});

  @override
  Widget build(BuildContext context) {
    final abilitySelectionCubit = context.read<AbilitySelectionCubit>();
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.delete_forever),
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
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                  ),
                ],
              ),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Fertigkeit hinzufügen'),
                content: SizedBox(
                  width: double.maxFinite,
                  height: double.maxFinite,
                  child: FutureBuilder<List<Fertigkeit>>(
                    future: DBHelper.instance.getFertigkeiten(),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasData) {
                        List<Fertigkeit> data = snapshot.data;
                        return ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return AbilityCard(data: data, index: index, cardInfo: abilitySelectionCubit.state[index]);
                          },
                        );
                      } else if (snapshot.hasError) {
                        return const Center(child: Text('Error'));
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                ),
                actions: [
                  OverflowBar(
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Abbrechen'),
                      ),
                      TextButton(
                        onPressed: () {
                          abilitySelectionCubit.saveSelectedAbilities(playerId);
                          abilitySelectionCubit.resetState();
                          Navigator.pop(context);
                        },
                        child: const Text('Speichern'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
