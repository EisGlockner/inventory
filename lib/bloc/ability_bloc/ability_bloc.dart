import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory/bloc/ability_bloc/ability_event.dart';
import 'package:inventory/bloc/ability_bloc/ability_state.dart';

class AbilityBloc extends Bloc<AbilityEvent, AbilityState> {
  AbilityBloc() : super(AbilityInitialState());
}