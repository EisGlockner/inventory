import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory/data/database_helper.dart';

// Events
abstract class HealthEvent {}

class IncrementHealth extends HealthEvent {
  final int value;
  final int playerId;
  final int maxHealth;

  IncrementHealth(
      this.value, this.playerId, this.maxHealth);
}

class DecrementHealth extends HealthEvent {
  final int value;
  final int playerId;
  final int maxHealth;

  DecrementHealth(
      this.value, this.playerId, this.maxHealth);
}

class SetHealth extends HealthEvent {
  final int value;
  final int playerId;
  final int maxHealth;

  SetHealth(this.value, this.playerId, this.maxHealth);
}

// State
class HealthState {
  int playerId;
  int health;

  HealthState(this.playerId, this.health);
}

// Cubit
class HealthCubit extends Cubit<List<HealthState>> {
  HealthCubit() : super([]);

  void addPlayer(int playerId, int initialHealth) {
    final newState = [...state, HealthState(playerId, initialHealth)];
    emit(newState);
  }

  void updateHealth(int playerId, int newHealth) {
    final updatedState = state.map((healthState) {
      if (healthState.playerId == playerId) {
        DBHelper.instance.updateLeben(playerId, newHealth);
        return HealthState(playerId, newHealth);
      }
      return healthState;
    }).toList();

    emit(updatedState);
  }

  int getPlayerHealth(int playerId) {
    final healthState =
        state.firstWhere((healthState) => healthState.playerId == playerId);
    return healthState.health;
  }

  void handleEvent(HealthEvent event) {
    if (event is IncrementHealth) {
      int newHealth = getPlayerHealth(event.playerId) + event.value;
      if (newHealth >= event.maxHealth) {
        updateHealth(event.playerId, event.maxHealth);
      } else {
        updateHealth(event.playerId, newHealth);
      }
    } else if (event is DecrementHealth) {
      int newHealth = getPlayerHealth(event.playerId) - event.value;

      if (newHealth < 0) {
        updateHealth(event.playerId, 0);
      } else {
        updateHealth(event.playerId, newHealth);
      }
    } else if (event is SetHealth) {
      if (event.value >= event.maxHealth) {
        updateHealth(event.playerId, event.maxHealth);
      } else {
        updateHealth(event.playerId, event.value);
      }
    }
  }
}
