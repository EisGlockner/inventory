import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory/bloc/player_overview_events.dart';
import 'package:inventory/bloc/player_overview_states.dart';
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
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        int? lastGroup = prefs.getInt('lastGroup');
        lastGroup = lastGroup ?? 0;
        await DBHelper.instance.deleteGruppe(lastGroup);
        int? firstGroup = await DBHelper.instance.getFirstGroupId();
        firstGroup = firstGroup ?? 0;
        await prefs.setInt('lastGroup', firstGroup);
        emit(GroupDeleted());
      } catch (e) {
        print(e);
        emit(PlayerOverviewError());
      }
    });
  }
}
