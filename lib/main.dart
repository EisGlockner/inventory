import 'package:flutter/material.dart';
import 'package:inventory/group_overview.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/cubits/health_cubit.dart';
import 'bloc/cubits/mana_cubit.dart';
import 'bloc/cubits/player_form_cubit.dart';
import 'bloc/group_overview_bloc/group_overview_bloc.dart';
import 'bloc/group_overview_bloc/group_overview_events.dart';
import 'bloc/group_overview_bloc/group_overview_states.dart';
import 'data/database_helper.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AppBloc()..add(AppStartedEvent()),
          child: BlocListener<AppBloc, AppState>(
            listener: (context, state) {
              if (state is AppStarted) {
                _initializeDatabase();
              }
            },
          ),
        ),
        BlocProvider(
          create: (context) => GroupOverviewBloc()..add(LoadPlayers()),
          child: BlocListener<GroupOverviewBloc, PlayerOverviewState>(
            listener: (context, state) {
              if (state is GroupAdded || state is GroupDeleted) {
                context.read<GroupOverviewBloc>().add(LoadPlayers());
              }
            },
          ),
        ),
        BlocProvider(
          create: (context) => PlayerFormCubit(),
        ),
        BlocProvider(
          create: (context) => HealthCubit(),
        ),
        BlocProvider(
          create: (context) => ManaCubit(),
        ),
      ],
      child: const MaterialApp(
        home: PlayerOverview(),
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
