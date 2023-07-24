import 'package:flutter/material.dart';
import 'package:inventory/bloc/group_overview_bloc.dart';
import 'package:inventory/group_overview.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/group_overview_events.dart';
import 'bloc/group_overview_states.dart';
import 'bloc/health_cubit.dart';
import 'data/database_helper.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppBloc()..add(AppStartedEvent()),
      child: BlocListener<AppBloc, AppState>(
        listener: (context, state) {
          if (state is AppStarted) {
            _initializeDatabase();
          }
        },
        child: BlocProvider(
          create: (context) => GroupOverviewBloc()..add(LoadPlayers()),
          child: BlocListener<GroupOverviewBloc, PlayerOverviewState>(
            listener: (context, state) {
              if (state is GroupAdded || state is GroupDeleted) {
                context.read<GroupOverviewBloc>().add(LoadPlayers());
              }
            },
            child: BlocProvider(
              create: (context) => HealthCubit(),
              child: const MaterialApp(
                home: PlayerOverview(),
              ),
            ),
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
      emit(AppStarted());
    });
  }
}

abstract class AppState {}

class AppInitial extends AppState {}

class AppStarted extends AppState {}

abstract class AppEvent {}

class AppStartedEvent extends AppEvent {}
