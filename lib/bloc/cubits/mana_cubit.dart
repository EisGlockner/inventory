import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory/data/database_helper.dart';
import 'package:inventory/data/model.dart';

/// For the Mana Icon i need more variables like hasAsp, hasKap, ... so i give the player as parameter instead of the single values

// Events
abstract class ManaEvent {}

class IncrementMana extends ManaEvent {
  final int value;
  final Spieler player;
  final int currentMana;

  IncrementMana(this.value, this.player, this.currentMana);
}

class DecrementMana extends ManaEvent {
  final int value;
  final Spieler player;
  final int currentMana;

  DecrementMana(this.value, this.player, this.currentMana);
}

class SetMana extends ManaEvent {
  final int value;
  final Spieler player;

  SetMana(this.value, this.player);
}

// State
class ManaState {
  late int mana;

  ManaState(this.mana);
}

// Cubit
class ManaCubit extends Cubit<ManaState> {
  ManaCubit() : super(ManaState(0));

  void updateMana(int playerId, int newMana) {
    DBHelper.instance.updateMana(playerId, newMana).then((_) {
      emit(ManaState(newMana));
    });
  }

  int handleEvent(ManaEvent event) {
    if (event is IncrementMana) {
      int newMana = event.currentMana + event.value;

      if (newMana >= event.player.maxMana) {
        updateMana(event.player.id!, event.player.maxMana);
        return event.player.maxMana;
      } else {
        updateMana(event.player.id!, newMana);
        return newMana;
      }

    } else if (event is DecrementMana) {
      int newMana = event.currentMana - event.value;

      if (newMana < 0) {
        updateMana(event.player.id!, 0);
        return 0;
      } else {
        updateMana(event.player.id!, newMana);
        return newMana;
      }

    } else if (event is SetMana) {
      if (event.value >= event.player.maxMana) {
        updateMana(event.player.id!, event.player.maxMana);
        return event.player.maxMana;
      } else {
        updateMana(event.player.id!, event.value);
        return event.value;
      }

    } else {
      return 0;
    }
  }
}
