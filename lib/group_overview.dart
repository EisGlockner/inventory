import 'package:flutter/material.dart';
import 'package:inventory/widgets/appbar/appbar.dart';
import 'package:inventory/widgets/group_overview_title.dart';
import 'package:inventory/widgets/group_overview_player.dart';

import 'misc.dart' as misc;

class PlayerOverview extends StatelessWidget {
  const PlayerOverview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade400,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: MyAppBar(),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          misc.scrW(context, 0.04),
          misc.scrH(context, 0.03),
          misc.scrW(context, 0.04),
          0,
        ),
        child: const Column(
          children: [
            PlayerOverviewTitle(),
            Padding(padding: EdgeInsets.only(bottom: 15)),
            Divider(
              color: Colors.black,
              thickness: 1,
            ),
            GroupOverviewPlayer(),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:inventory/widgets/group_overview_player.dart';
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
