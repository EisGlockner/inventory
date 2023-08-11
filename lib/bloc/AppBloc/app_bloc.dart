import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_event.dart';
import 'app_state.dart';
import '../../data/database_helper.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  Completer<void> databaseCompleter = Completer<void>();

  AppBloc() : super(AppInitial()) {
    Future<void> initializeDatabase() async {
      await DBHelper.instance.database;
    }

    on<AppStartedEvent>((event, emit) {
      initializeDatabase().then((_) {
        databaseCompleter.complete();
      });
      emit(AppStarted());
    });
  }
}