import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/group_overview_bloc.dart';
import '../../bloc/group_overview_events.dart';
import 'package:inventory/misc.dart' as misc;

class AddGroupDialog {
  static Future<void> show(BuildContext context) async {
    TextEditingController controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Gruppe hinzufügen'),
        content: SizedBox(
          width: misc.scrW(context, 0.75),
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Gruppenname'),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () {
              context.read<GroupOverviewBloc>().add(AddGroup(controller.text));
              Navigator.pop(context);
            },
            child: const Text('Hinzufügen'),
          ),
        ],
      ),
    );
  }
}