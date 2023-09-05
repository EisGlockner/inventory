import 'dart:async';

import 'package:flutter/material.dart';
import 'package:inventory/bloc/cubits/money_cubit.dart';
import 'package:inventory/bloc/cubits/provision_cubit.dart';
import 'package:inventory/group_overview.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/AppBloc/app_bloc.dart';
import 'bloc/AppBloc/app_event.dart';
import 'bloc/cubits/health_cubit.dart';
import 'bloc/cubits/mana_cubit.dart';
import 'bloc/cubits/player_form_cubit.dart';
import 'bloc/group_overview_bloc/group_overview_bloc.dart';
import 'bloc/group_overview_bloc/group_overview_events.dart';
import 'bloc/group_overview_bloc/group_overview_states.dart';

void main() async {
  await initializeAppAndDatabase();
}

Future<void> initializeAppAndDatabase() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appBloc = AppBloc();
  appBloc.add(AppStartedEvent());
  await appBloc.databaseCompleter.future;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GroupOverviewBloc>(
          create: (context) => GroupOverviewBloc()..add(LoadPlayers()),
          lazy: false,
        ),
        BlocProvider<PlayerFormCubit>(
          create: (context) => PlayerFormCubit(),
        ),
        BlocProvider<HealthCubit>(
          create: (context) => HealthCubit(),
        ),
        BlocProvider<ManaCubit>(
          create: (context) => ManaCubit(),
        ),
        BlocProvider<ProvisionCubit>(
          create: (context) => ProvisionCubit(),
        ),
        BlocProvider<MoneyCubit>(
          create: (context) => MoneyCubit(),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<GroupOverviewBloc, PlayerOverviewState>(
            listener: (context, state) {
              if (state is GroupAdded ||
                  state is GroupDeleted ||
                  state is PlayerDeleted) {
                context.read<GroupOverviewBloc>().add(LoadPlayers());
              }
            },
          ),
        ],
        child: const MaterialApp(
          home: PlayerOverview(),
        ),
      ),
    );
  }
}
