import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory/data/database_helper.dart';

// Events
abstract class HealthEvent {}

class IncrementHealth extends HealthEvent {
  final int value;
  final int playerId;
  final int currentHealth;

  IncrementHealth(this.value, this.playerId, this.currentHealth);
}

class DecrementHealth extends HealthEvent {
  final int value;
  final int playerId;
  final int currentHealth;

  DecrementHealth(this.value, this.playerId, this.currentHealth);
}

class SetHealth extends HealthEvent {
  final int value;
  final int playerId;

  SetHealth(this.value, this.playerId);
}

// State
class HealthState {
  late int health;

  HealthState(this.health);
}

// Cubit
class HealthCubit extends Cubit<HealthState> {
  HealthCubit() : super(HealthState(0));

  void updateHealth(int playerId, int newHealth) {
    DBHelper.instance.updateHealth(playerId, newHealth).then((_) {
      emit(HealthState(newHealth));
    });
  }

  void handleEvent(HealthEvent event) {
    if (event is IncrementHealth) {
      int newHealth = event.currentHealth + event.value;
      updateHealth(event.playerId, newHealth);
    } else if (event is DecrementHealth) {
      int newHealth = event.currentHealth - event.value;
      updateHealth(event.playerId, newHealth);
    } else if (event is SetHealth) {
      updateHealth(event.playerId, event.value);
    }
  }
}
