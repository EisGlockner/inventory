import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../bloc/group_overview_bloc/group_overview_bloc.dart';
import '../../bloc/group_overview_bloc/group_overview_events.dart';
import '../../bloc/group_overview_bloc/group_overview_states.dart';
import '../../misc.dart';
import 'add_group.dart';
import 'add_player.dart';
import 'delete_group.dart';

class MyAppBar extends StatelessWidget {
  const MyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        IconButton(
          onPressed: () async {
            await showDialog(context: context, builder: (context) => const DeleteGruppeDialog());
          },
          icon: const Icon(Icons.delete),
        ),
        Theme(
          data: Theme.of(context).copyWith(cardColor: Colors.grey.shade400),
          child: PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'new_group') {
                await AddGroupDialog.show(context);
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'new_group',
                child: Text('Neue Gruppe hinzufügen'),
              ),
              PopupMenuItem(
                enabled: false,
                child: BlocBuilder<GroupOverviewBloc, PlayerOverviewState>(
                  builder: (context, state) {
                    if (state is PlayerOverviewLoaded) {
                      if (state.groups.isNotEmpty) {
                        return Column(
                          children: state.groups
                              .map(
                                (group) => PopupMenuItem(
                                  onTap: () async {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setInt(currentGroup, group.id).then(
                                        (value) => context
                                            .read<GroupOverviewBloc>()
                                            .add(LoadPlayers()));
                                  },
                                  child: Text(group.name),
                                ),
                              )
                              .toList(),
                        );
                      } else {
                        return const Text('Keine Gruppen vorhanden');
                      }
                    } else {
                      return const CircularProgressIndicator(color: Colors.grey,);
                    }
                  },
                ),
              ),
            ],
            icon: const Icon(Icons.group, color: Colors.white),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.person_add),
          onPressed: () async {
            await AddPlayerDialog.show(context);
          },
        ),
      ],
    );
  }
}
