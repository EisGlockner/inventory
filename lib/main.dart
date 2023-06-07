import 'package:flutter/material.dart';
import 'package:inventory/bloc/player_overview_bloc.dart';
import 'package:inventory/player_overview.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/database_helper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppBloc()..add(AppStartedEvent()),
      child: BlocListener<AppBloc, AppState>(
        listener: (context, state) {
          if (state is AppStartedState) {
            _initializeDatabase();
          }
        },
        child: BlocProvider(
          create: (context) => PlayerOverviewBloc()..add(LoadPlayers()),
          child: MaterialApp(
            home: PlayerOverview(),
          ),
        ),
      ),
    );
  }

  Future<void> _initializeDatabase() async {
    await DBHelper.instance.database;
  }
}

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(AppInitial()) {
    on<AppStartedEvent>((event, emit) {
      emit(AppStartedState());
    });
  }
}

abstract class AppState {}

class AppInitial extends AppState {}

class AppStartedState extends AppState {}

abstract class AppEvent {}

class AppStartedEvent extends AppEvent {}
