import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory/bloc/player_overview_states.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bloc/player_overview_bloc.dart';
import '../bloc/player_overview_events.dart';

class MyAppBar extends StatelessWidget {
  const MyAppBar({super.key});

  Future<void> _addGroup(context) async {
    TextEditingController controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Gruppe hinzufügen'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Gruppenname'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () {
              context.read<PlayerOverviewBloc>().add(AddGroup(controller.text));
              Navigator.pop(context);
            },
            child: const Text('Hinzufügen'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteGroup(context) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Gruppe löschen?'),
        content: const Text('möchten sie die Gruppe wirklich löschen?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () {
              context.read<PlayerOverviewBloc>().add(DeleteGroup());
              Navigator.pop(context);
            },
            child: const Text('Löschen'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        IconButton(
          onPressed: () {
            _deleteGroup(context);
          },
          icon: const Icon(Icons.delete),
        ),
        Theme(
          data: Theme.of(context).copyWith(cardColor: Colors.grey.shade400),
          child: PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'new_group') {
                _addGroup(context);
              } else {
                // implement Group selection
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'new_group',
                child: Text('Neue Gruppe hinzufügen'),
              ),
              PopupMenuItem(
                enabled: false,
                child: BlocBuilder<PlayerOverviewBloc, PlayerOverviewState>(
                  builder: (context, state) {
                    if (state is PlayerOverviewLoaded) {
                      if (state.groups.isNotEmpty) {
                        return Column(
                          children: state.groups
                              .map((group) =>
                              PopupMenuItem(
                                value: group.id,
                                child: Text(group.name),
                              ))
                              .toList(),
                        );
                      } else {
                        return const Text('Keine Gruppen vorhanden');
                      }
                    }
                    return AppBar();
                  },
                ),
              ),
            ],
            icon: const Icon(Icons.group, color: Colors.white),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.person_add),
          onPressed: () {
            // implement player
          },
        ),
      ],
    );
  }
}
