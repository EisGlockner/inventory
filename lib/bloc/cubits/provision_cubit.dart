import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory/data/database_helper.dart';

// Events
abstract class ProvisionEvent {}

class IncrementProvision extends ProvisionEvent {
  final int value;
  final int playerId;
  final int currentProvision;

  IncrementProvision(this.value, this.playerId, this.currentProvision);
}

class DecrementProvision extends ProvisionEvent {
  final int value;
  final int playerId;
  final int currentProvision;

  DecrementProvision(this.value, this.playerId, this.currentProvision);
}

class SetProvision extends ProvisionEvent {
  final int value;
  final int playerId;

  SetProvision(this.value, this.playerId);
}

// State
class ProvisionState {
  late int provision;

  ProvisionState(this.provision);
}

// Cubit
class ProvisionCubit extends Cubit<ProvisionState> {
  ProvisionCubit() : super(ProvisionState(0));

  void updateProvision(int playerId, int newProvision) {
    DBHelper.instance.updateProviant(playerId, newProvision).then((_) {
      emit(ProvisionState(newProvision));
    });
  }

  int handleEvent(ProvisionEvent event) {
    if (event is IncrementProvision) {
      int newProvision = event.currentProvision + event.value;
      updateProvision(event.playerId, newProvision);
      return newProvision;
    } else if (event is DecrementProvision) {
      int newProvision = event.currentProvision - event.value;
      if (newProvision < 0) {
        updateProvision(event.playerId, 0);
        return 0;
      }
      updateProvision(event.playerId, newProvision);
      return newProvision;
    } else if (event is SetProvision) {
      updateProvision(event.playerId, event.value);
      return event.value;
    } else {
      return 0;
    }
  }
}
