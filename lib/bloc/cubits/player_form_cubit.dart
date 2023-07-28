import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model.dart';
import '../../data/database_helper.dart';

class PlayerFormCubit extends Cubit<Map<String, dynamic>> {
  PlayerFormCubit()
      : super({
          'name': '',
          'spielerName': '',
          'leben': '',
          'mana': '0',
          'seelenkraft': '',
          'zaehigkeit': '',
          'schicksalspunkte': '',
          'proviant': '0',
          'isGlaesern': false,
          'isEisern': false,
          'isZaeh': false,
          'isZerbrechlich': false,
          'hasAsp': false,
          'hasKap': false,
          'kreuzer': '0',
          'heller': '0',
          'silber': '0',
          'dukaten': '0',
          'isLoading': false,
          'MU': 8,
          'KL': 8,
          'IN': 8,
          'CH': 8,
          'FF': 8,
          'GE': 8,
          'KO': 8,
          'KK': 8,
        });

  void updateField(String field, dynamic value) {
    emit({...state, field: value});
  }

  Future<void> savePlayer() async {
    emit({...state, 'isLoading': true});

    final spieler = Spieler(
      name: state['name'],
      spielerName: state['spielerName'],
      leben: int.parse(state['leben']),
      maxLeben: int.parse(state['leben']),
      mana: int.parse(state['mana']),
      maxMana: int.parse(state['mana']),
      seelenkraft: int.parse(state['seelenkraft']),
      zaehigkeit: int.parse(state['zaehigkeit']),
      schicksalspunkte: int.parse(state['schicksalspunkte']),
      proviant: int.parse(state['proviant']),
      isGlaesern: state['isGlaesern'] == false ? 0 : 1,
      isEisern: state['isEisern'] == false ? 0 : 1,
      isZaeh: state['isZaeh'] == false ? 0 : 1,
      isZerbrechlich: state['isZerbrechlich'] == false ? 0 : 1,
      hasAsp: state['hasAsp'] == false ? 0 : 1,
      hasKap: state['hasKap'] == false ? 0 : 1,
      kreuzer: int.parse(state['kreuzer']),
      heller: int.parse(state['heller']),
      silber: int.parse(state['silber']),
      dukaten: int.parse(state['dukaten']),
    );

    final spielerStatsList = [
      SpielerStats(
        spielerId: 0,
        statId: 1,
        wert: state['MU'],
      ),
      SpielerStats(
        spielerId: 0,
        statId: 2,
        wert: state['KL'],
      ),
      SpielerStats(
        spielerId: 0,
        statId: 3,
        wert: state['IN'],
      ),
      SpielerStats(
        spielerId: 0,
        statId: 4,
        wert: state['CH'],
      ),
      SpielerStats(
        spielerId: 0,
        statId: 5,
        wert: state['FF'],
      ),
      SpielerStats(
        spielerId: 0,
        statId: 6,
        wert: state['GE'],
      ),
      SpielerStats(
        spielerId: 0,
        statId: 7,
        wert: state['KO'],
      ),
      SpielerStats(
        spielerId: 0,
        statId: 8,
        wert: state['KK'],
      ),
    ];

    DBHelper.instance.insertSpielerAndSpielerStats(spieler, spielerStatsList);

    emit({...state, 'isLoading': false});
  }
}
