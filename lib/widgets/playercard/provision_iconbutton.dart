import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/cubits/provision_cubit.dart';
import '../../icons/inventory_icons.dart';
import '../../misc.dart' as misc;

class ProvisionIcon extends StatelessWidget {
  final int? playerId;
  int currentProvision;

  ProvisionIcon({super.key, required this.playerId, required this.currentProvision});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _showProvisionDialog(context);
      },
      child: SizedBox(
        width: misc.scrW(context, 0.23),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Inventory.proviant,
              color: Colors.brown,
            ),
            BlocBuilder<ProvisionCubit, ProvisionState>(builder: (context, state) {
              return Text(' $currentProvision');
            }),
          ],
        ),
      ),
    );
  }

  void _showProvisionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        int newProvision = currentProvision;
        return BlocBuilder<ProvisionCubit, ProvisionState>(builder: (context, state) {
          return AlertDialog(
            title: const Text('Proviant bearbeiten'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  keyboardType: const TextInputType.numberWithOptions(decimal: false),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  autofocus: true,
                  onChanged: (value) {
                    newProvision = int.tryParse(value) ?? currentProvision;
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
                  _setProvision(context, newProvision);
                },
                child: const Text('=', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),),
              ),
              TextButton(
                onPressed: () {
                  _incrementProvision(context, newProvision);
                },
                child: const Text('+', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),),
              ),
              TextButton(
                onPressed: () {
                  _decrementProvision(context, newProvision);
                },
                child: const Text('-', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),),
              ),
            ],
          );
        });
      },
    );
  }

  void _incrementProvision(BuildContext context, int newProvision) {
    currentProvision = context.read<ProvisionCubit>().handleEvent(
      IncrementProvision(newProvision, playerId!, currentProvision),
    );

    // BlocProvider.of<ProvisionCubit>(context)
    //     .handleEvent(IncrementProvision(newProvision, playerId!, currentProvision));
    Navigator.pop(context);
  }

  void _decrementProvision(BuildContext context, int newProvision) {
    currentProvision = context.read<ProvisionCubit>().handleEvent(
      DecrementProvision(newProvision, playerId!, currentProvision),
    );

    // BlocProvider.of<ProvisionCubit>(context)
    //     .handleEvent(DecrementProvision(currentProvision - newProvision, playerId!), currentProvision);
    Navigator.pop(context);
  }

  void _setProvision(BuildContext context, int newProvision) {
    currentProvision = context.read<ProvisionCubit>().handleEvent(
      SetProvision(newProvision, playerId!),
    );

    // BlocProvider.of<ProvisionCubit>(context)
    //     .handleEvent(SetProvision(newProvision, playerId!));
    Navigator.pop(context);
  }
}
