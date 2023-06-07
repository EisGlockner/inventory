import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/database_helper.dart';
import '../data/model.dart';

class PlayerOverviewBloc extends Bloc<PlayerOverviewEvent, PlayerOverviewState> {
  PlayerOverviewBloc() : super(PlayerOverviewInitial()) {
    on<LoadPlayers>((event, emit) async {
      emit(PlayerOverviewLoading());
      try {
        List<Spieler> players = await DBHelper.instance.getSpieler();
        List<Map<String, dynamic>>? groups = await DBHelper.instance.getGruppen();
        String? firstGroupName;
        if (groups != null && groups.isNotEmpty) {
          firstGroupName = groups.first['name'];
        }

        emit(PlayerOverviewLoaded(players, firstGroupName));
      } catch (e, stacktrace) {
        print(e);
        print(stacktrace);
        emit(PlayerOverviewError());
      }
    });

    on<AddGroup>((event, emit) async {
      try {
        int? result = await DBHelper.instance.insertGruppe(event.name);
        emit(GroupAdded());
      } catch (e) {
        print(e);
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
  final String? firstGroupName;

  PlayerOverviewLoaded(this.players, this.firstGroupName);
}

class PlayerOverviewError extends PlayerOverviewState {}

abstract class PlayerOverviewEvent {}

class LoadPlayers extends PlayerOverviewEvent {}

class GroupAdded extends PlayerOverviewState {}

class AddGroup extends PlayerOverviewEvent {
  final String name;

  AddGroup(this.name);
}