import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/group_overview_bloc.dart';
import '../bloc/group_overview_states.dart';

class GroupOverviewPlayer extends StatelessWidget {

  const GroupOverviewPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupOverviewBloc, PlayerOverviewState>(
      builder: (context, state) {
        if (state is PlayerOverviewLoading) {
          return const CircularProgressIndicator(
            color: Colors.grey,
          );
        } else if (state is PlayerOverviewLoaded) {
          if (state.players.isNotEmpty) {
            return Column(
              children: state.players.map((player) =>
                  Text(player.name),
              ).toList(),
            );
          } else {
            return const Center(
              child: Text(
                'Keine Spieler vorhanden',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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

// import 'package:flutter/material.dart';
// import 'package:inventory/icons/inventory_icons.dart';
// import 'package:inventory/misc.dart' as misc;
//
// class PlayerOverviewWidget extends StatelessWidget {
//   String name = 'Kommodore Patrick Vanzan';
//   int dukaten = 12;
//   int silber = 8;
//   int heller = 2;
//   int kreuzer = 6;
//
//   PlayerOverviewWidget({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         const Padding(padding: EdgeInsets.only(bottom: 15)),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
//             Text('$dukaten''D $silber' 'S $heller' 'H $kreuzer' 'K'),
//           ],
//         ),
//         const Padding(padding: EdgeInsets.only(bottom: 20)),
//         Row(
//           children: [
//             Container(
//               width: misc.scrW(context, 0.23),
//               child: Row(
//                 children: const [
//                   Icon(Inventory.healthpotion, color: Colors.red,),
//                   Text(' 35'),
//                 ],
//               ),
//             ),
//             Container(
//               width: misc.scrW(context, 0.23),
//               child: Row(
//                 children: const [
//                   Icon(Inventory.twelvegods, color: Colors.yellow,),
//                   Text(' 14'),
//                 ],
//               ),
//             ),
//             Container(
//               width: misc.scrW(context, 0.23),
//               child: Row(
//                 children: const [
//                   Icon(Inventory.schmerz, color: Colors.white70,),
//                   Text(' 2'),
//                 ],
//               ),
//             ),
//             Container(
//               width: misc.scrW(context, 0.23),
//               child: Row(
//                 children: const [
//                   Icon(Inventory.proviant, color: Colors.brown,),
//                   Text(' 6'),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         const Padding(padding: EdgeInsets.only(bottom: 15)),
//         const Divider(
//           color: Colors.black,
//           thickness: 1,
//         ),
//       ],
//     );
//   }
// }
