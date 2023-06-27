import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/group_overview_bloc.dart';
import '../../bloc/group_overview_events.dart';

class DeleteGruppeDialog extends StatefulWidget {
  const DeleteGruppeDialog({super.key});

  @override
  DeleteGruppeDialogState createState() => DeleteGruppeDialogState();
}

class DeleteGruppeDialogState extends State<DeleteGruppeDialog> {
  bool deleteSpieler = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Gruppe löschen'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Möchten Sie die Gruppe wirklich löschen?'),
          CheckboxListTile(
            title: const Text('Auch Spieler löschen'),
            value: deleteSpieler,
            onChanged: (value) {
              setState(() {
                deleteSpieler = value ?? false;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('Abbrechen'),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        TextButton(
          child: const Text('Löschen'),
          onPressed: () {
            context.read<GroupOverviewBloc>().add(DeleteGroup(deleteSpieler));
            Navigator.of(context).pop(context);
          },
        ),
      ],
    );
  }
}