import 'package:flutter/material.dart';

import '../data/model.dart';

class PlayerOverviewWidget extends StatelessWidget {
  final Spieler player;

  PlayerOverviewWidget(this.player, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Hier kannst du die Spielerdaten anzeigen
    return Text(player.name);
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
