import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class HealthEvent {}

class IncrementHealth extends HealthEvent {
  final int value;

  IncrementHealth(this.value);
}

class DecrementHealth extends HealthEvent {
  final int value;

  DecrementHealth(this.value);
}

// State
class HealthState {
  final int health;

  HealthState(this.health);
}

// Cubit
class HealthCubit extends Cubit<HealthState> {
  HealthCubit() : super(HealthState(0));

  void incrementHealth(int value) {
    final newHealth = state.health + value;
    emit(HealthState(newHealth));
  }

  void decrementHealth(int value) {
    final newHealth = state.health - value;
    emit(HealthState(newHealth));
  }
}
