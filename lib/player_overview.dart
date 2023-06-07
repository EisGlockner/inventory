import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory/widgets/player_overview_widget.dart';

import 'bloc/player_overview_bloc.dart';
import 'misc.dart' as misc;

class PlayerOverview extends StatelessWidget {
  PlayerOverview({Key? key}) : super(key: key);

  Future<void> _addGroup(context) async {
    TextEditingController controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Gruppe hinzufügen'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Gruppenname'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () {
              print('Adding group: ${controller.text}');
              context.read<PlayerOverviewBloc>().add(AddGroup(controller.text));
              Navigator.pop(context);
            },
            child: const Text('Hinzufügen'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final playerOverviewBloc = context.read<PlayerOverviewBloc>();
    print('PlayerOverviewBloc: $playerOverviewBloc');

    return BlocProvider(
      create: (context) => PlayerOverviewBloc()..add(LoadPlayers()),
      child: BlocListener<PlayerOverviewBloc, PlayerOverviewState>(
        listener: (context, state) {
          if (state is GroupAdded) {
            context.read<PlayerOverviewBloc>().add(LoadPlayers());
          }
        },
        child: Scaffold(
          backgroundColor: Colors.grey.shade400,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.person_add),
                onPressed: () {
                  // implement player
                },
              ),
              IconButton(
                icon: const Icon(Icons.group_add),
                onPressed: () => _addGroup(context),
              ),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.fromLTRB(misc.scrW(context, 0.04),
                misc.scrH(context, 0.08), misc.scrW(context, 0.04), 0),
            child: Column(
              children: [
                BlocBuilder<PlayerOverviewBloc, PlayerOverviewState>(
                  builder: (context, state) {
                    if (state is PlayerOverviewLoading) {
                      return const CircularProgressIndicator();
                    } else if (state is PlayerOverviewLoaded) {
                      if (state.firstGroupName != null) {
                        return Center(
                          child: Text(
                            state.firstGroupName!,
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
                ),
                const Padding(padding: EdgeInsets.only(bottom: 15)),
                const Divider(
                  color: Colors.black,
                  thickness: 1,
                ),
                BlocBuilder<PlayerOverviewBloc, PlayerOverviewState>(
                  builder: (context, state) {
                    if (state is PlayerOverviewLoading) {
                      return const CircularProgressIndicator();
                    } else if (state is PlayerOverviewLoaded) {
                      if (state.players.isNotEmpty) {
                        return Column(
                          children: state.players
                              .map((player) => PlayerOverviewWidget(player))
                              .toList(),
                        );
                      } else {
                        return const Text('Keine Spieler vorhanden');
                      }
                    } else {
                      return const Text('Error');
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:inventory/widgets/player_overview_widget.dart';
// import 'misc.dart' as misc;
//
// class PlayerOverview extends StatelessWidget {
//   const PlayerOverview({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade400,
//       body: Padding(
//         padding: EdgeInsets.fromLTRB(misc.scrW(context, 0.04),
//             misc.scrH(context, 0.08), misc.scrW(context, 0.04), 0),
//         child: Column(
//           children: [
//             const Center(
//               child: Text(
//                 'Fiese Organisation für weltweite Lumpereien',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//               ),
//             ),
//             const Padding(padding: EdgeInsets.only(bottom: 15)),
//             const Divider(
//               color: Colors.black,
//               thickness: 1,
//             ),
//             PlayerOverviewWidget(),
//             PlayerOverviewWidget(),
//             PlayerOverviewWidget(),
//             PlayerOverviewWidget(),
//             PlayerOverviewWidget(),
//           ],
//         ),
//       ),
//     );
//   }
// }
