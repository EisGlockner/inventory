class Spieler {
  final int? id;
  final String name;
  final String spielerName;
  int leben;
  final int maxLeben;
  late final int mana;
  final int maxMana;
  final int seelenkraft;
  final int zaehigkeit;
  final int schicksalspunkte;
  final int proviant;
  final int isGlaesern;
  final int isEisern;
  final int isZaeh;
  final int isZerbrechlich;
  final int hasAsp;
  final int hasKap;
  final int kreuzer;
  final int heller;
  final int silber;
  final int dukaten;

  Spieler({
    this.id,
    required this.name,
    required this.spielerName,
    required this.leben,
    required this.maxLeben,
    required this.mana,
    required this.maxMana,
    required this.seelenkraft,
    required this.zaehigkeit,
    required this.schicksalspunkte,
    required this.proviant,
    required this.isGlaesern,
    required this.isEisern,
    required this.isZaeh,
    required this.isZerbrechlich,
    required this.hasAsp,
    required this.hasKap,
    required this.kreuzer,
    required this.heller,
    required this.silber,
    required this.dukaten,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'spielerName': spielerName,
      'leben': leben,
      'maxLeben': maxLeben,
      'mana': mana,
      'maxMana': maxMana,
      'seelenkraft': seelenkraft,
      'zaehigkeit': zaehigkeit,
      'schicksalspunkte': schicksalspunkte,
      'proviant': proviant,
      'isGlaesern': isGlaesern,
      'isEisern': isEisern,
      'isZaeh': isZaeh,
      'isZerbrechlich': isZerbrechlich,
      'hasAsp': hasAsp,
      'hasKap': hasKap,
      'kreuzer': kreuzer,
      'heller': heller,
      'silber': silber,
      'dukaten': dukaten,
    };
  }

  factory Spieler.fromMap(Map<String, dynamic> map) {
    return Spieler(
      id: map['id'],
      name: map['name'],
      spielerName: map['spielerName'],
      leben: map['leben'],
      maxLeben: map['maxLeben'],
      mana: map['mana'],
      maxMana: map['maxMana'],
      seelenkraft: map['seelenkraft'],
      zaehigkeit: map['zaehigkeit'],
      schicksalspunkte: map['schicksalspunkte'],
      proviant: map['proviant'],
      isGlaesern: map['isGlaesern'],
      isEisern: map['isEisern'],
      isZaeh: map['isZaeh'],
      isZerbrechlich: map['isZerbrechlich'],
      hasAsp: map['hasAsp'],
      hasKap: map['hasKap'],
      kreuzer: map['kreuzer'],
      heller: map['heller'],
      silber: map['silber'],
      dukaten: map['dukaten'],
    );
  }
}

class Stats {
  final int id;
  final String name;

  Stats({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory Stats.fromMap(Map<String, dynamic> map) {
    return Stats(
      id: map['id'],
      name: map['name'],
    );
  }
}

class SpielerStats {
  late int spielerId;
  final int statId;
  final int wert;

  SpielerStats({
    required this.spielerId,
    required this.statId,
    required this.wert,
  });

  Map<String, dynamic> toMap() {
    return {
      'spieler_id': spielerId,
      'stat_id': statId,
      'wert': wert,
    };
  }

  factory SpielerStats.fromMap(Map<String, dynamic> map) {
    return SpielerStats(
      spielerId: map['spieler_id'],
      statId: map['stat_id'],
      wert: map['wert'],
    );
  }
}

class Fertigkeiten {
  final int id;
  final String name;

  Fertigkeiten({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory Fertigkeiten.fromMap(Map<String, dynamic> map) {
    return Fertigkeiten(
      id: map['id'],
      name: map['name'],
    );
  }
}

class FertigkeitenStats {
  final int fertigkeitId;
  final int stat1Id;
  final int stat2Id;
  final int stat3Id;

  FertigkeitenStats({
    required this.fertigkeitId,
    required this.stat1Id,
    required this.stat2Id,
    required this.stat3Id,
  });

  Map<String, dynamic> toMap() {
    return {
      'fertigkeit_id': fertigkeitId,
      'stat1_id': stat1Id,
      'stat2_id': stat2Id,
      'stat3_id': stat3Id,
    };
  }

  factory FertigkeitenStats.fromMap(Map<String, dynamic> map) {
    return FertigkeitenStats(
      fertigkeitId: map['fertigkeit_id'],
      stat1Id: map['stat1_id'],
      stat2Id: map['stat2_id'],
      stat3Id: map['stat3_id'],
    );
  }
}

class SpielerFertigkeiten {
  final int spielerId;
  final int fertigkeitId;
  final int wert;

  SpielerFertigkeiten({
    required this.spielerId,
    required this.fertigkeitId,
    required this.wert,
  });

  Map<String, dynamic> toMap() {
    return {
      'spieler_id': spielerId,
      'fertigkeit_id': fertigkeitId,
      'wert': wert,
    };
  }

  factory SpielerFertigkeiten.fromMap(Map<String, dynamic> map) {
    return SpielerFertigkeiten(
      spielerId: map['spieler_id'],
      fertigkeitId: map['fertigkeit_id'],
      wert: map['wert'],
    );
  }
}

class Gruppen {
  final int id;
  final String name;

  Gruppen({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory Gruppen.fromMap(Map<String, dynamic> map) {
    return Gruppen(
      id: map['id'],
      name: map['name'],
    );
  }
}

class SpielerGruppen {
  final int spielerId;
  final int gruppenId;

  SpielerGruppen({
    required this.spielerId,
    required this.gruppenId,
  });

  Map<String, dynamic> toMap() {
    return {
      'spielerId': spielerId,
      'gruppenId': gruppenId,
    };
  }

  factory SpielerGruppen.fromMap(Map<String, dynamic> map) {
    return SpielerGruppen(
      spielerId: map['spielerId'],
      gruppenId: map['gruppenId'],
    );
  }
}
