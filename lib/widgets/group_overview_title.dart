import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/group_overview_bloc/group_overview_bloc.dart';
import '../bloc/group_overview_bloc/group_overview_states.dart';

class PlayerOverviewTitle extends StatelessWidget {
  const PlayerOverviewTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupOverviewBloc, PlayerOverviewState>(
      builder: (context, state) {
        if (state is PlayerOverviewLoading) {
          return const CircularProgressIndicator(color: Colors.grey,);
        } else if (state is PlayerOverviewLoaded) {
          if (state.groupName != null) {
            return Center(
              child: Text(
                state.groupName!,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w600),
              ),
            );
          } else {
            return const Center(
              child: Text(
                'Keine Gruppen vorhanden',
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w600),
              ),
            );
          }
        } else {
          return const Text('Error');
        }
      },
    );
  }
}
