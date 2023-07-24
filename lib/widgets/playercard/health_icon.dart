import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/health_cubit.dart';
import '../../icons/inventory_icons.dart';
import 'package:inventory/misc.dart' as misc;

class HealthIcon extends StatelessWidget {
  final int? playerId;
  final int currentHealth;

  HealthIcon({super.key, required this.playerId, required this.currentHealth});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HealthCubit, HealthState>(
      builder: (context, state) {
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
                Text(' $currentHealth'),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showHealthDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        int newHealth = currentHealth;
        return BlocBuilder<HealthCubit, HealthState>(builder: (context, state) {
          return AlertDialog(
            title: const Text("Health bearbeiten"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    newHealth = int.tryParse(value) ?? currentHealth;
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Abbrechen"),
              ),
              TextButton(
                onPressed: () {
                  _incrementHealth(context, newHealth);
                },
                child: const Text("+"),
              ),
              TextButton(
                onPressed: () {
                  _decrementHealth(context, newHealth);
                },
                child: const Text("-"),
              ),
              TextButton(
                onPressed: () {
                  _setHealth(context, newHealth);
                },
                child: const Text("="),
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
      IncrementHealth(newHealth, playerId!, currentHealth),
    );

    // BlocProvider.of<HealthCubit>(context)
    //     .handleEvent(IncrementHealth(newHealth, playerId!, currentHealth));
    Navigator.pop(context);
  }

  void _decrementHealth(BuildContext context, int newHealth) {
    context.read<HealthCubit>().handleEvent(
          DecrementHealth(newHealth, playerId!, currentHealth),
        );
    // BlocProvider.of<HealthCubit>(context)
    //     .handleEvent(DecrementHealth(currentHealth - newHealth, playerId!), currentHealth);
    Navigator.pop(context);
  }

  void _setHealth(BuildContext context, int newHealth) {
    context.read<HealthCubit>().handleEvent(
      SetHealth(newHealth, playerId!),
    );
    // BlocProvider.of<HealthCubit>(context)
    //     .handleEvent(SetHealth(newHealth, playerId!));
    Navigator.pop(context);
  }
}
