import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory/data/database_helper.dart';

// Events
abstract class HealthEvent {}

class IncrementHealth extends HealthEvent {
  final int value;
  final int playerId;
  final int currentHealth;
  final int maxHealth;

  IncrementHealth(
      this.value, this.playerId, this.currentHealth, this.maxHealth);
}

class DecrementHealth extends HealthEvent {
  final int value;
  final int playerId;
  final int currentHealth;
  final int maxHealth;

  DecrementHealth(
      this.value, this.playerId, this.currentHealth, this.maxHealth);
}

class SetHealth extends HealthEvent {
  final int value;
  final int playerId;
  final int maxHealth;

  SetHealth(this.value, this.playerId, this.maxHealth);
}

// State
class HealthState {
  int health;

  HealthState(this.health);
}

// Cubit
class HealthCubit extends Cubit<HealthState> {
  HealthCubit() : super(HealthState(0));

  void updateHealth(int playerId, int newHealth, BuildContext context) {
    DBHelper.instance.updateLeben(playerId, newHealth).then((_) {
      emit(HealthState(newHealth));
    });
  }

  int handleEvent(HealthEvent event, BuildContext context) {
    if (event is IncrementHealth) {
      int newHealth = event.currentHealth + event.value;

      if (newHealth >= event.maxHealth) {
        updateHealth(event.playerId, event.maxHealth, context);
        return event.maxHealth;
      } else {
        updateHealth(event.playerId, newHealth, context);
        return newHealth;
      }

    } else if (event is DecrementHealth) {
      int newHealth = event.currentHealth - event.value;

      if (newHealth < 0) {
        updateHealth(event.playerId, 0, context);
        return 0;
      } else {
        updateHealth(event.playerId, newHealth, context);
        return newHealth;
      }

    } else if (event is SetHealth) {
      if (event.value >= event.maxHealth) {
        updateHealth(event.playerId, event.maxHealth, context);
        return event.maxHealth;
      } else {
        updateHealth(event.playerId, event.value, context);
        return event.value;
      }

    } else {
      return 0;
    }
  }
}
