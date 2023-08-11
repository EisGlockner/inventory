import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory/data/database_helper.dart';

// Events
abstract class MoneyEvent {}

class IncrementMoney extends MoneyEvent {
  final List<int> money;
  final int playerId;
  final List<int> currentMoney;

  IncrementMoney(
    this.money,
    this.playerId,
    this.currentMoney,
  );
}

class DecrementMoney extends MoneyEvent {
  final List<int> money;
  final int playerId;
  final List<int> currentMoney;

  DecrementMoney(
    this.money,
    this.playerId,
    this.currentMoney,
  );
}

class SetMoney extends MoneyEvent {
  final List<int> money;
  final int playerId;

  SetMoney(this.money, this.playerId);
}

// State
class MoneyState {
  List<int> money;

  MoneyState(this.money);
}

// Cubit
class MoneyCubit extends Cubit<MoneyState> {
  MoneyCubit() : super(MoneyState([0, 0, 0, 0]));

  void updateMoney(int playerId, List<int> money, BuildContext context) {
    DBHelper.instance.updateMoney(playerId, money).then((_) {
      emit(MoneyState(money));
    });
  }

  List<int> handleEvent(MoneyEvent event, BuildContext context) {
    if (event is IncrementMoney) {
      List<int> newMoney = [
        event.currentMoney[0] + event.money[0],
        event.currentMoney[1] + event.money[1],
        event.currentMoney[2] + event.money[2],
        event.currentMoney[3] + event.money[3],
      ];

      updateMoney(event.playerId, newMoney, context);
      return newMoney;
    } else if (event is DecrementMoney) {
      List<int> newMoney = List.from(event.currentMoney);

      for (int i = 3; i >= 0; i--) {
        if (newMoney[i] < event.money[i]) {
          if (i > 0) {
            int deficit = newMoney[i] - event.money[i];
            int difference = deficit * -1;
            difference = difference ~/ 10;
            ++difference;

            int j = i-1;
            while (j >= 0) {
              if (newMoney[j] - difference >= 0) {
                newMoney[i] = deficit + (difference * 10);
                newMoney[i - 1] -= difference;
                break;
              }
              --j;
            }
          }
        } else {
          newMoney[i] -= event.money[i];
        }
      }

      updateMoney(event.playerId, newMoney, context);
      return newMoney;
    } else if (event is SetMoney) {
      updateMoney(event.playerId, event.money, context);
      return event.money;
    } else {
      return [0];
    }
  }
}
