import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory/widgets/player_overview_widget.dart';

import 'bloc/player_overview_bloc.dart';
import 'misc.dart' as misc;

class PlayerOverview extends StatelessWidget {
  const PlayerOverview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PlayerOverviewBloc()..add(LoadPlayers()),
      child: Scaffold(
        backgroundColor: Colors.grey.shade400,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('Player Overview'),
          actions: [
            IconButton(
              icon: const Icon(Icons.person_add),
              onPressed: () {
                // add player function
              },
            ),
            IconButton(
              icon: const Icon(Icons.group_add),
              onPressed: () {
                // add group function
              },
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(misc.scrW(context, 0.04),
              misc.scrH(context, 0.08), misc.scrW(context, 0.04), 0),
          child: Column(
            children: [
              const Center(
                child: Text(
                  'Fiese Organisation für weltweite Lumpereien',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
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
                    return Column(
                      children: state.players
                          .map((player) => PlayerOverviewWidget(player))
                          .toList(),
                    );
                  } else {
                    return const Text('Error loading Data');
                  }
                },
              ),
            ],
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
