import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/cubits/ability_selection_cubit.dart';
import '../../data/model.dart';

class AbilityCard extends StatelessWidget {
  final List<Fertigkeit> data;
  final int index;
  final CardInfo cardInfo;
  final TextEditingController textController = TextEditingController();

  AbilityCard({required this.data, required this.index, required this.cardInfo});

  @override
  Widget build(BuildContext context) {
    final cardSelectionCubit = context.read<AbilitySelectionCubit>();
    final cardInfo = context.select((AbilitySelectionCubit cubit) => cubit.state[index]);

    return InkWell(
      onTap: () {
        cardSelectionCubit.toggleCardSelection(index);
      },
      child: Card(
        shape: cardInfo.isSelected
            ? RoundedRectangleBorder(
          side: const BorderSide(color: Colors.blue, width: 2),
          borderRadius: BorderRadius.circular(5),
        )
            : RoundedRectangleBorder(
          side: const BorderSide(),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(data[index].name),
              SizedBox(
                width: 50,
                child: TextField(
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                  controller: textController,
                  onChanged: (newValue) {
                    cardSelectionCubit.updateAbilityValue(index, int.tryParse(newValue) ?? 0);
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}