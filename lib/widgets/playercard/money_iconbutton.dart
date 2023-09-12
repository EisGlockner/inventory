import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory/bloc/cubits/money_cubit.dart';

class MoneyIcon extends StatelessWidget {
  List<int> money;
  final int? playerId;

  MoneyIcon({
    super.key,
    required this.money,
    required this.playerId,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _showMoneyDialog(context);
      },
      child: BlocBuilder<MoneyCubit, MoneyState>(builder: (context, state) {
        return Text('${money[0]}D ${money[1]}S ${money[2]}H ${money[3]}K');
      }),
    );
  }

  void _showMoneyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        List<int> newMoney = [0, 0, 0, 0];
        return AlertDialog(
          title: const Text('Geld bearbeiten'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(child: Text('Dukaten (${money[0]})')),
                  Expanded(
                    child: TextField(
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: false),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (value) {
                        newMoney[0] = int.tryParse(value) ?? 0;
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(child: Text('Silber (${money[1]})')),
                  Expanded(
                    child: TextField(
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: false),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (value) {
                        newMoney[1] = int.tryParse(value) ?? 0;
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(child: Text('Heller (${money[2]})')),
                  Expanded(
                    child: TextField(
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: false),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (value) {
                        newMoney[2] = int.tryParse(value) ?? 0;
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(child: Text('Kreuzer (${money[3]})')),
                  Expanded(
                    child: TextField(
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: false),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (value) {
                        newMoney[3] = int.tryParse(value) ?? 0;
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            OverflowBar(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Abbrechen'),
                ),
                TextButton(
                  onPressed: () {
                    _setMoney(context, newMoney);
                  },
                  child: const Text(
                    '=',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _incrementMoney(context, newMoney);
                  },
                  child: const Text(
                    '+',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _decrementMoney(context, newMoney);
                  },
                  child: const Text(
                    '-',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _incrementMoney(BuildContext context, List<int> newMoney) {
    money = context.read<MoneyCubit>().handleEvent(
          IncrementMoney(newMoney, playerId!, money),
          context,
        );

    // BlocProvider.of<ProvisionCubit>(context)
    //     .handleEvent(IncrementProvision(newProvision, playerId!, currentProvision));
    Navigator.pop(context);
  }

  void _decrementMoney(BuildContext context, List<int> newMoney) {
    money = context.read<MoneyCubit>().handleEvent(
          DecrementMoney(newMoney, playerId!, money),
          context,
        );

    // BlocProvider.of<ProvisionCubit>(context)
    //     .handleEvent(DecrementProvision(currentProvision - newProvision, playerId!), currentProvision);
    Navigator.pop(context);
  }

  void _setMoney(BuildContext context, List<int> newMoney) {
    money = context.read<MoneyCubit>().handleEvent(
          SetMoney(newMoney, playerId!),
          context,
        );

    // BlocProvider.of<ProvisionCubit>(context)
    //     .handleEvent(SetProvision(newProvision, playerId!));
    Navigator.pop(context);
  }
}
