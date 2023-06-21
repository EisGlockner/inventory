import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/model.dart';
import '../data/database_helper.dart';

class PlayerFormCubit extends Cubit<Map<String, dynamic>> {
  PlayerFormCubit()
      : super({
    'name': '',
    'leben': '',
    'mana': '',
    'seelenkraft': '',
    'zaehigkeit': '',
    'proviant': 0,
    'isGlaesern': false,
    'isEisern': false,
    'isZaeh': false,
    'isZerbrechlich': false,
    'hasAsp': false,
    'hasKap': false,
    'isLoading': false,
    'MU': null,
    'KL': null,
    'IN': null,
    'CH': null,
    'FF': null,
    'GE': null,
    'KO': null,
    'KK': null,
  });

  void updateField(String field, dynamic value) {
    emit({...state, field: value});
  }

  Future<void> savePlayer() async {
    emit({...state, 'isLoading': true});
    final spieler = Spieler(
      name: state['name'],
      leben: int.parse(state['lep']),
      mana: int.parse(state['mana']),
      seelenkraft: int.parse(state['seelenkraft']),
      zaehigkeit: int.parse(state['zaehigkeit']),
      proviant: int.parse(state['proviant']),
      isGlaesern: state['isGlaesern'],
      isEisern: state['isEisern'],
      isZaeh: state['isZaeh'],
      isZerbrechlich: state['isZerbrechlich'],
      hasAsp: state['hasAsp'],
      hasKap: state['hasKap'],
    );
    final spielerId = await DBHelper.instance.insertSpieler(spieler);

    final spielerStatsList = [
      SpielerStats(
        spielerId: spielerId!,
        statId: 1,
        wert: state['MU'],
      ),
      SpielerStats(
        spielerId: spielerId,
        statId: 2,
        wert: state['KL'],
      ),
      SpielerStats(
        spielerId: spielerId,
        statId: 3,
        wert: state['IN'],
      ),
      SpielerStats(
        spielerId: spielerId,
        statId: 4,
        wert: state['CH'],
      ),
      SpielerStats(
        spielerId: spielerId,
        statId: 5,
        wert: state['FF'],
      ),
      SpielerStats(
        spielerId: spielerId,
        statId: 6,
        wert: state['GE'],
      ),
      SpielerStats(
        spielerId: spielerId,
        statId: 7,
        wert: state['KO'],
      ),
      SpielerStats(
        spielerId: spielerId,
        statId: 8,
        wert: state['KK'],
      ),
    ];
    await DBHelper.instance.insertSpielerStats(spielerStatsList);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? lastGroup = prefs.getInt('lastGroup');

    await DBHelper.instance.insertSpielerToGruppe(spielerId, lastGroup!);

    emit({...state, 'isLoading': false});
  }
}
