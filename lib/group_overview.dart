import 'package:flutter/material.dart';
import 'package:inventory/widgets/appbar/appbar.dart';
import 'package:inventory/widgets/group_overview_title.dart';
import 'package:inventory/widgets/playercard/playercard.dart';

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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            misc.scrW(context, 0.04),
            misc.scrH(context, 0.03),
            misc.scrW(context, 0.04),
            misc.scrW(context, 0.04),
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
      ),
    );
  }
}
