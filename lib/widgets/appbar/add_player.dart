import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/group_overview_bloc.dart';
import '../../bloc/group_overview_events.dart';
import '../../bloc/player_form_cubit.dart';
import 'package:inventory/misc.dart' as misc;

class AddPlayerDialog {
  static Future<void> show(BuildContext context) async {
    final formKey = GlobalKey<FormState>();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController playerNameController = TextEditingController();
    final TextEditingController lebenController = TextEditingController();
    final TextEditingController manaController = TextEditingController();
    final TextEditingController seelenkraftController = TextEditingController();
    final TextEditingController zaehigkeitController = TextEditingController();
    final TextEditingController schicksalspunkteController = TextEditingController();
    final TextEditingController kreuzerController = TextEditingController();
    final TextEditingController hellerController = TextEditingController();
    final TextEditingController silberController = TextEditingController();
    final TextEditingController dukatenController = TextEditingController();

    Widget myTextFormField(
      TextEditingController textController,
      String label,
      String field,
      bool isDecimal,
    ) {
      return BlocBuilder<PlayerFormCubit, Map<String, dynamic>>(
        builder: (context, state) {
          return TextFormField(
            controller: textController,
            decoration: InputDecoration(labelText: label),
            keyboardType: isDecimal == true
                ? const TextInputType.numberWithOptions(decimal: false)
                : TextInputType.text,
            inputFormatters: isDecimal == true
                ? [FilteringTextInputFormatter.digitsOnly]
                : [],
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
        },
      );
    }

    Widget myDropdownButtonFormField(String field) {
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
        },
      );
    }

    Widget myCheckboxListTile(String field, String label) {
      return BlocBuilder<PlayerFormCubit, Map<String, dynamic>>(
        builder: (context, state) {
          return CheckboxListTile(
            title: Text(label),
            value: state[field],
            onChanged: (bool? value) {
              context.read<PlayerFormCubit>().updateField(field, value);
            },
          );
        },
      );
    }

    await showDialog(
      context: context,
      builder: (context) => BlocProvider(
        create: (context) => PlayerFormCubit(),
        child: AlertDialog(
          title: const Text('Spieler hinzufügen'),
          content: SizedBox(
            width: misc.scrW(context, 0.75),
            child: BlocBuilder<PlayerFormCubit, Map<String, dynamic>>(
              builder: (context, state) {
                if (state['isLoading']) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.grey,
                    ),
                  );
                }
                return Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        myTextFormField(nameController, 'Name', 'name', false),
                        myTextFormField(playerNameController, 'Spielername',
                            'spielerName', false),
                        myTextFormField(lebenController, 'Lep', 'lep', true),
                        myTextFormField(manaController, 'Mana', 'mana', true),
                        myTextFormField(seelenkraftController, 'Seelenkraft',
                            'seelenkraft', true),
                        myTextFormField(zaehigkeitController, 'Zähigkeit',
                            'zaehigkeit', true),
                        myTextFormField(schicksalspunkteController, 'Schicksalspunkte',
                            'schicksalspunkte', true),

                        const Padding(padding: EdgeInsets.only(top: 25)),

                        Row(
                          children: [
                            Expanded(
                              child: myDropdownButtonFormField('MU'),
                            ),
                            const SizedBox(width: 28),
                            Expanded(
                              child: myDropdownButtonFormField('KL'),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: myDropdownButtonFormField('IN'),
                            ),
                            const SizedBox(width: 28),
                            Expanded(
                              child: myDropdownButtonFormField('CH'),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: myDropdownButtonFormField('FF'),
                            ),
                            const SizedBox(width: 28),
                            Expanded(
                              child: myDropdownButtonFormField('GE'),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: myDropdownButtonFormField('KO'),
                            ),
                            const SizedBox(width: 28),
                            Expanded(
                              child: myDropdownButtonFormField('KK'),
                            ),
                          ],
                        ),

                        const Padding(padding: EdgeInsets.only(top: 25)),

                        myTextFormField(kreuzerController, 'Kreuzer', 'kreuzer', true),
                        myTextFormField(hellerController, 'Heller', 'heller', true),
                        myTextFormField(silberController, 'Silber', 'silber', true),
                        myTextFormField(dukatenController, 'Dukaten', 'dukaten', true),

                        const Padding(padding: EdgeInsets.only(top: 25)),

                        myCheckboxListTile('isGlaesern', 'Gläsern'),
                        myCheckboxListTile('isEisern', 'Eisern'),
                        myCheckboxListTile('isZaeh', 'Zäh'),
                        myCheckboxListTile('isZerbrechlich', 'Zerbrechlich'),
                        myCheckboxListTile('hasAsp', 'Asp'),
                        myCheckboxListTile('hasKap', 'Kap'),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          actions: [
            BlocBuilder<PlayerFormCubit, Map<String, dynamic>>(
              builder: (BuildContext context, state) {
                return TextButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
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
            ),
          ],
        ),
      ),
    );
  }
}
