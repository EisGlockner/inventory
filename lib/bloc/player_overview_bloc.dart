import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/database_helper.dart';
import '../data/model.dart';

class PlayerOverviewBloc extends Bloc<PlayerOverviewEvent, PlayerOverviewState> {
  PlayerOverviewBloc() : super(PlayerOverviewInitial()) {
    on<LoadPlayers>((event, emit) async {
      emit(PlayerOverviewLoading());
      try {
        List<Spieler> players = await DBHelper.instance.getSpieler();
        emit(PlayerOverviewLoaded(players));
      } catch (e) {
        emit(PlayerOverviewError());
      }
    });
  }
}

abstract class PlayerOverviewState {}

class PlayerOverviewInitial extends PlayerOverviewState {}

class PlayerOverviewLoading extends PlayerOverviewState {}

class PlayerOverviewLoaded extends PlayerOverviewState {
  final List<Spieler> players;

  PlayerOverviewLoaded(this.players);
}

class PlayerOverviewError extends PlayerOverviewState {}

abstract class PlayerOverviewEvent {}

class LoadPlayers extends PlayerOverviewEvent {}