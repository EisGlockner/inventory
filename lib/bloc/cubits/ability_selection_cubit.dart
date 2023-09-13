import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/database_helper.dart';
import '../../data/model.dart';

class CardInfo {
  final int index;
  final int value;
  final bool isSelected;

  CardInfo(
      {required this.index, required this.value, required this.isSelected});
}

class AbilitySelectionCubit extends Cubit<List<CardInfo>> {
  AbilitySelectionCubit(int cardCount)
      : super(List<CardInfo>.generate(
            cardCount,
            (index) => CardInfo(
                  index: index,
                  value: 0,
                  isSelected: false,
                )));

  void toggleCardSelection(int index) {
    final List<CardInfo> updatedState = List<CardInfo>.from(state);
    updatedState[index] = CardInfo(
      index: state[index].index,
      value: state[index].value,
      isSelected: !state[index].isSelected,
    );
    emit(updatedState);
  }

  void updateAbilityValue(int index, int newValue) {
    final List<CardInfo> updatedState = List<CardInfo>.from(state);
    updatedState[index] = CardInfo(
      index: state[index].index,
      value: newValue,
      isSelected: state[index].isSelected,
    );
    emit(updatedState);
  }

  void saveSelectedAbilitys(int playerId) {
    final List<CardInfo> currentState = state;
    List<SpielerFertigkeiten> sf = [];

    for (int i = 0; i < currentState.length; i++) {
      if (currentState[i].isSelected) {
        sf.add(SpielerFertigkeiten(
          spielerId: playerId,
          fertigkeitId: currentState[i].index + 1,
          wert: currentState[i].value,
        ));
      }
    }
    DBHelper.instance.insertSpielerFertigkeiten(sf);
  }

  void resetState() {
    emit(List<CardInfo>.generate(
      state.length,
          (index) => CardInfo(
        index: index,
        value: 0,
        isSelected: false,
      ),
    ));
  }
}
