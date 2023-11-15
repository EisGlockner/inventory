import 'package:flutter/material.dart';
import 'package:inventory/data/database_helper.dart';
import 'package:inventory/data/model.dart';
import 'package:inventory/widgets/player_screen/player_appbar.dart';

class PlayerScreen extends StatelessWidget {
  final Spieler player;

  const PlayerScreen({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade400,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: PlayerAppBar(playerId: player.id!),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Text(
                player.name,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
            Center(child: Text(player.spielerName)),
            const Padding(padding: EdgeInsets.only(top: 30)),
            FutureBuilder<List<SpielerStats>>(
              future: DBHelper.instance.getSpielerStats(player.id!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox.shrink();
                } else if (snapshot.hasError) {
                  return const Text('Fehler beim Laden der Daten');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('Keine Daten verfügbar');
                } else {
                  return SizedBox(
                    height: _calculateGridViewHeight(
                      snapshot.data!.length,
                      MediaQuery.of(context).size.width < 900 ? 4 : 8,
                    ),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            MediaQuery.of(context).size.width < 900 ? 4 : 8,
                        childAspectRatio: 2,
                      ),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final List<String> stats = [
                          'MU',
                          'KL',
                          'IN',
                          'CH',
                          'FF',
                          'GE',
                          'KO',
                          'KK'
                        ];
                        return _buildStatCard(
                            stats[index], snapshot.data![index].wert);
                      },
                    ),
                  );
                }
              },
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
              child: Divider(
                color: Colors.black,
                thickness: 1,
              ),
            ),
            SizedBox(
              height: 50,
              child: GridView.count(
                crossAxisCount: 3,
                childAspectRatio: 2,
                children: [
                  _buildStatCard('SK', player.seelenkraft),
                  _buildStatCard('ZK', player.zaehigkeit),
                  _buildStatCard('SP', player.schicksalspunkte),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(10, 20, 10, 15),
              child: Divider(
                color: Colors.black,
                thickness: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
              child: SizedBox(
                width: double.maxFinite,
                height: double.maxFinite,
                child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: DBHelper.instance.getFertigkeitValue(player.id!),
                    builder:
                        (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasData) {
                        List<Map<String, dynamic>> data = snapshot.data;
                        return ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(width: 150, child: Text(data[index]['fertigkeit_name'])),
                                    SizedBox(width: 30, child: Text(data[index]['spieler_fertigkeit_wert'].toString())),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          data[index]['stat1_name'].toString(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          data[index]['spieler_stat1_wert'].toString(),
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          data[index]['stat2_name'].toString(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          data[index]['spieler_stat2_wert'].toString(),
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          data[index]['stat3_name'].toString(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          data[index]['spieler_stat3_wert'].toString(),
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            });
                      } else {
                        return const Placeholder();
                      }
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _calculateGridViewHeight(int itemCount, axisCount) {
    int rowCount = (itemCount / axisCount).ceil();
    return 50.0 * rowCount.toDouble();
  }

  Widget _buildStatCard(String statName, int statValue) {
    return Card(
      color: Colors.transparent,
      elevation: 0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            statName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            statValue.toString(),
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
