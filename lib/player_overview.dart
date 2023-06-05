import 'package:flutter/material.dart';
import 'package:inventory/widgets/player_overview_widget.dart';
import 'misc.dart' as misc;

class PlayerOverview extends StatelessWidget {
  const PlayerOverview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade400,
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
            PlayerOverviewWidget(),
            PlayerOverviewWidget(),
            PlayerOverviewWidget(),
            PlayerOverviewWidget(),
            PlayerOverviewWidget(),
          ],
        ),
      ),
    );
  }
}
