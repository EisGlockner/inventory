import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory/bloc/group_overview_states.dart';
import 'package:inventory/bloc/player_form_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bloc/group_overview_bloc.dart';
import '../bloc/group_overview_events.dart';
import '../misc.dart';

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
              context.read<GroupOverviewBloc>().add(AddGroup(controller.text));
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
              context.read<GroupOverviewBloc>().add(DeleteGroup());
              Navigator.pop(context);
            },
            child: const Text('Löschen'),
          ),
        ],
      ),
    );
  }

  Future<void> _addPlayer(context) async {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _lebenController = TextEditingController();
    final TextEditingController _manaController = TextEditingController();
    final TextEditingController _seelenkraftController =
        TextEditingController();
    final TextEditingController _zaehigkeitController = TextEditingController();

    BlocBuilder<PlayerFormCubit, Map<String, dynamic>> _myTextFormField(
      TextEditingController textController,
      String lable,
      String field,
      bool isDecimal,
    ) {
      return BlocBuilder<PlayerFormCubit, Map<String, dynamic>>(
          builder: (context, state) {
        return TextFormField(
          controller: textController,
          decoration: InputDecoration(labelText: lable),
          keyboardType: TextInputType.numberWithOptions(decimal: isDecimal),
          onChanged: (String value) {
            context.read<PlayerFormCubit>().updateField(field, value);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Pflichtfeld';
            }
            return null;
          },
        );
      });
    }

    BlocBuilder<PlayerFormCubit, Map<String, dynamic>>
        _myDropdownButtonFormField(String field) {
      return BlocBuilder<PlayerFormCubit, Map<String, dynamic>>(
          builder: (context, state) {
        return DropdownButtonFormField<int>(
          decoration: InputDecoration(labelText: field),
          value: state[field],
          onChanged: (int? newValue) {
            context.read<PlayerFormCubit>().updateField(field, newValue);
          },
          items: List.generate(13, (index) => index + 8)
              .map<DropdownMenuItem<int>>((int value) {
            return DropdownMenuItem<int>(
              value: value,
              child: Text(value.toString()),
            );
          }).toList(),
        );
      });
    }

    BlocBuilder<PlayerFormCubit, Map<String, dynamic>> _myCheckboxListTile(
      String field,
      String label,
    ) {
      return BlocBuilder<PlayerFormCubit, Map<String, dynamic>>(
          builder: (context, state) {
        return CheckboxListTile(
          title: Text(label),
          value: state[field],
          onChanged: (bool? value) {
            context.read<PlayerFormCubit>().updateField(field, value);
          },
        );
      });
    }

    showDialog(
      context: context,
      builder: (context) => BlocProvider(
        create: (context) => PlayerFormCubit(),
        child: AlertDialog(
          title: const Text('Spieler hinzufügen'),
          content: BlocBuilder<PlayerFormCubit, Map<String, dynamic>>(
            builder: (context, state) {
              if (state['isLoading']) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.grey,
                  ),
                );
              }
              return Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _myTextFormField(_nameController, 'Name', 'name', false),
                      _myTextFormField(_lebenController, 'Lep', 'lep', true),
                      _myTextFormField(_manaController, 'Mana', 'mana', true),
                      _myTextFormField(_seelenkraftController, 'Seelenkraft',
                          'seelenkraft', true),
                      _myTextFormField(_zaehigkeitController, 'Zähigkeit',
                          'zaehigkeit', true),
                      const Padding(padding: EdgeInsets.only(top: 25)),
                      Row(
                        children: [
                          Expanded(
                            child: _myDropdownButtonFormField('MU'),
                          ),
                          SizedBox(width: 28),
                          Expanded(
                            child: _myDropdownButtonFormField('KL'),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _myDropdownButtonFormField('IN'),
                          ),
                          SizedBox(width: 28),
                          Expanded(
                            child: _myDropdownButtonFormField('CH'),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _myDropdownButtonFormField('FF'),
                          ),
                          SizedBox(width: 28),
                          Expanded(
                            child: _myDropdownButtonFormField('GE'),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _myDropdownButtonFormField('KO'),
                          ),
                          SizedBox(width: 28),
                          Expanded(
                            child: _myDropdownButtonFormField('KK'),
                          ),
                        ],
                      ),
                      const Padding(padding: EdgeInsets.only(top: 25)),
                      _myCheckboxListTile('isGlaesern', 'Gläsern'),
                      _myCheckboxListTile('isEisern', 'Eisern'),
                      _myCheckboxListTile('isZaeh', 'Zäh'),
                      _myCheckboxListTile('isZerbrechlich', 'Zerbrechlich'),
                      _myCheckboxListTile('hasAsp', 'Asp'),
                      _myCheckboxListTile('hasKap', 'Kap'),
                    ],
                  ),
                ),
              );
            },
          ),
          actions: [
            BlocBuilder<PlayerFormCubit, Map<String, dynamic>>(
              builder: (BuildContext context, state) {
                return TextButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await context
                          .read<PlayerFormCubit>()
                          .savePlayer()
                          .then((value) => context
                              .read<GroupOverviewBloc>()
                              .add(LoadPlayers()))
                          .then((value) => Navigator.of(context).pop());
                    }
                  },
                  child: const Text('Speichern'),
                );
              },
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Abbrechen'),
            )
          ],
        ),
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
            _addPlayer(context);
          },
        ),
      ],
    );
  }
}
