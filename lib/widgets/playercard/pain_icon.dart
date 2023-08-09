import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory/bloc/cubits/health_cubit.dart';

import '../../icons/inventory_icons.dart';
import '../../misc.dart' as misc;

class PainIcon extends StatelessWidget {
  int currentHealth;

  PainIcon({super.key, required this.currentHealth});

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
          BlocBuilder<HealthCubit, HealthState>(
            builder: (context, state) {
              return Text(' 0');
            },
          ),
        ],
      ),
    );
  }
}
