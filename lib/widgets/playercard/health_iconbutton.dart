import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/cubits/health_cubit.dart';
import '../../icons/inventory_icons.dart';
import 'package:inventory/misc.dart' as misc;

class HealthIcon extends StatelessWidget {
  final int? playerId;
  final int maxHealth;

  HealthIcon(
      {super.key,
      required this.playerId,
      required this.maxHealth});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _showHealthDialog(context);
      },
      child: SizedBox(
        width: misc.scrW(context, 0.23),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Inventory.healthpotion,
              color: Colors.red,
            ),
            BlocBuilder<HealthCubit, List<HealthState>>(
                builder: (context, state) {
              final health =
                  context.read<HealthCubit>().getPlayerHealth(playerId!);
              return Text(' $health');
            }),
          ],
        ),
      ),
    );
  }

  void _showHealthDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        int newHealth = context.read<HealthCubit>().getPlayerHealth(playerId!);
        ;
        return BlocBuilder<HealthCubit, List<HealthState>>(
            builder: (context, state) {
          return AlertDialog(
            title: const Text('Leben bearbeiten'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: false),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  autofocus: true,
                  onChanged: (value) {
                    newHealth = int.tryParse(value) ?? newHealth;
                  },
                ),
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
                  _setHealth(context, newHealth);
                },
                child: const Text(
                  '=',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                ),
              ),
              TextButton(
                onPressed: () {
                  _incrementHealth(context, newHealth);
                },
                child: const Text(
                  '+',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                ),
              ),
              TextButton(
                onPressed: () {
                  _decrementHealth(context, newHealth);
                },
                child: const Text(
                  '-',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                ),
              ),
            ],
          );
        });
      },
    );
  }

// ToDo: Figure out if context.read or BlocProvider.of is better
  void _incrementHealth(BuildContext context, int newHealth) {
    context.read<HealthCubit>().handleEvent(
          IncrementHealth(
            newHealth,
            playerId!,
            context.read<HealthCubit>().getPlayerHealth(playerId!),
            maxHealth,
          ),
          context,
        );

    // BlocProvider.of<HealthCubit>(context)
    //     .handleEvent(IncrementHealth(newHealth, playerId!, currentHealth));
    Navigator.pop(context);
  }

  void _decrementHealth(BuildContext context, int newHealth) {
    context.read<HealthCubit>().handleEvent(
          DecrementHealth(
            newHealth,
            playerId!,
            context.read<HealthCubit>().getPlayerHealth(playerId!),
            maxHealth,
          ),
          context,
        );

    // BlocProvider.of<HealthCubit>(context)
    //     .handleEvent(DecrementHealth(currentHealth - newHealth, playerId!), currentHealth);
    Navigator.pop(context);
  }

  void _setHealth(BuildContext context, int newHealth) {
    context.read<HealthCubit>().handleEvent(
          SetHealth(newHealth, playerId!, maxHealth),
          context,
        );

    // BlocProvider.of<HealthCubit>(context)
    //     .handleEvent(SetHealth(newHealth, playerId!));
    Navigator.pop(context);
  }
}
