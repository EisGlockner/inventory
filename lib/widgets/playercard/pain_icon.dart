import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory/bloc/cubits/health_cubit.dart';

import '../../icons/inventory_icons.dart';
import '../../misc.dart' as misc;

class PainIcon extends StatelessWidget {
  final int? playerId;
  final int maxHealth;

  PainIcon({super.key, required this.playerId, required this.maxHealth});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: misc.scrW(context, 0.23),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Inventory.schmerz,
            color: Colors.white70,
          ),
          BlocBuilder<HealthCubit, List<HealthState>>(
            builder: (context, state) {
              final int health = context.read<HealthCubit>().getPlayerHealth(playerId!);
              final int painStage;
              if (health <= 5) {
                painStage = 4;
              } else if ((maxHealth * 0.75).ceil() < health) {
                painStage = 0;
              } else if ((maxHealth * 0.5).ceil() < health) {
                painStage = 1;
              } else if ((maxHealth * 0.25).ceil() < health) {
                painStage = 2;
              } else {
                painStage = 3;
              }

              return Text(' $painStage');
            },
          ),
        ],
      ),
    );
  }
}
