import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory/icons/inventory_icons.dart';

import 'package:inventory/misc.dart' as misc;
import '../../bloc/cubits/mana_cubit.dart';
import '../../data/model.dart';

/// For the Mana Icon i need more variables like hasAsp, hasKap, ... so i give the player as parameter instead of the single values
class ManaIcon extends StatelessWidget {
  final Spieler player;
  int currentMana;

  ManaIcon({super.key, required this.player, required this.currentMana});

  @override
  Widget build(BuildContext context) {
    return player.hasAsp == 1 || player.hasKap == 1
        ? InkWell(
            onTap: () {
              _showManaDialog(context);
            },
            child: SizedBox(
              width: misc.scrW(context, 0.23),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  player.hasAsp == 1
                      ? const Icon(
                          Inventory.mana,
                          color: Colors.blue,
                        )
                      : const Icon(
                          Inventory.twelvegods,
                          color: Colors.yellow,
                        ),
                  BlocBuilder<ManaCubit, ManaState>(builder: (context, state) {
                    return Text(' $currentMana');
                  }),
                ],
              ),
            ),
          )
        : SizedBox(
            width: misc.scrW(context, 0.23),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.close,
                  color: Colors.grey,
                ),
                Text(' 0'),
              ],
            ),
        );
  }

  void _showManaDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        int newMana = player.mana;
        return BlocBuilder<ManaCubit, ManaState>(builder: (context, state) {
          return AlertDialog(
            title: const Text('Mana bearbeiten'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: false),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) {
                    newMana = int.tryParse(value) ?? player.mana;
                  },
                )
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Abbrechen'),
              ),
              TextButton(
                onPressed: () {
                  _incrementMana(context, newMana);
                },
                child: const Text('+'),
              ),
              TextButton(
                onPressed: () {
                  _decrementMana(context, newMana);
                },
                child: const Text('-'),
              ),
              TextButton(
                onPressed: () {
                  _setMana(context, newMana);
                },
                child: const Text('='),
              ),
            ],
          );
        });
      },
    );
  }

  void _incrementMana(BuildContext context, int newMana) {
    currentMana = context.read<ManaCubit>().handleEvent(
          IncrementMana(newMana, player, currentMana),
        );
    Navigator.pop(context);
  }

  void _decrementMana(BuildContext context, int newMana) {
    currentMana = context.read<ManaCubit>().handleEvent(
          DecrementMana(newMana, player, currentMana),
        );
    Navigator.pop(context);
  }

  void _setMana(BuildContext context, int newMana) {
    currentMana = context.read<ManaCubit>().handleEvent(
          SetMana(newMana, player, currentMana),
        );
    Navigator.pop(context);
  }
}
