import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/database_helper.dart';
import '../data/model.dart';

class PlayerOverviewBloc
    extends Bloc<PlayerOverviewEvent, PlayerOverviewState> {
  PlayerOverviewBloc() : super(PlayerOverviewInitial()) {
    on<LoadPlayers>((event, emit) async {
      emit(PlayerOverviewLoading());
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        int? lastGroup = prefs.getInt('lastGroup');
        List<Gruppen> groups = await DBHelper.instance.getGruppen();
        List<Spieler> players = await DBHelper.instance.getSpieler();
        String? groupName;
        if (lastGroup != null) {
          groupName = await DBHelper.instance.getGruppenName(lastGroup);
        }

        emit(PlayerOverviewLoaded(players, groupName, groups));
      } catch (e, stacktrace) {
        print(e);
        print(stacktrace);
        emit(PlayerOverviewError());
      }
    });

    on<AddGroup>((event, emit) async {
      emit(InsertingGroup());
      try {
        int? groupId = await DBHelper.instance.insertGruppe(event.name);

        if (groupId != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setInt('lastGroup', groupId);
        }
        emit(GroupAdded());
      } catch (e) {
        print(e);
        emit(PlayerOverviewError());
      }
    });

    on<DeleteGroup>((event, emit) async {
      emit(DeletingGroup());
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        int? lastGroup = prefs.getInt('lastGroup');
        await DBHelper.instance.deleteGruppe(lastGroup!);
        int? firstGroup = await DBHelper.instance.getFirstGroupId();
        await prefs.setInt('lastGroup', firstGroup!);
        emit(GroupDeleted());
      } catch (e) {
        print(e);
        emit(PlayerOverviewError());
      }
    });

    on <LoadGroup>((event, emit) async {
      try {
        emit(GroupLoading());
        List<Gruppen> gruppen = await DBHelper.instance.getGruppen();
        emit(GroupLoaded(gruppen));
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
  final String? groupName;
  final List<Gruppen> groups;

  PlayerOverviewLoaded(this.players, this.groupName, this.groups);
}

class PlayerOverviewError extends PlayerOverviewState {}

class InsertingGroup extends PlayerOverviewState {}

class GroupAdded extends PlayerOverviewState {}

class DeletingGroup extends PlayerOverviewState {}

class GroupDeleted extends PlayerOverviewState {}

class GroupLoading extends PlayerOverviewState {}

class GroupLoaded extends PlayerOverviewState {
  final List<Gruppen> gruppen;

  GroupLoaded(this.gruppen);
}

abstract class PlayerOverviewEvent {}

class LoadPlayers extends PlayerOverviewEvent {}

class AddGroup extends PlayerOverviewEvent {
  final String name;

  AddGroup(this.name);
}

class DeleteGroup extends PlayerOverviewEvent {}

class LoadGroup extends PlayerOverviewEvent {}
