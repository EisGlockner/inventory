class Spieler {
  final int? id;
  final String name;
  final int leben;
  final int mana;
  final int seelenkraft;
  final int zaehigkeit;
  final int? proviant;
  final int isGlaesern;
  final int isEisern;
  final int isZaeh;
  final int isZerbrechlich;
  final int hasAsp;
  final int hasKap;

  Spieler({
    this.id,
    required this.name,
    required this.leben,
    required this.mana,
    required this.seelenkraft,
    required this.zaehigkeit,
    this.proviant,
    required this.isGlaesern,
    required this.isEisern,
    required this.isZaeh,
    required this.isZerbrechlich,
    required this.hasAsp,
    required this.hasKap,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'leben': leben,
      'mana': mana,
      'seelenkraft': seelenkraft,
      'zaehigkeit': zaehigkeit,
      'proviant': proviant,
      'isGlaesern': isGlaesern,
      'isEisern': isEisern,
      'isZaeh': isZaeh,
      'isZerbrechlich': isZerbrechlich,
      'hasAsp': hasAsp,
      'hasKap': hasKap,
    };
  }

  factory Spieler.fromMap(Map<String, dynamic> map) {
    return Spieler(
        id: map['id'],
        name: map['name'],
        leben: map['leben'],
        mana: map['mana'],
        seelenkraft: map['seelenkraft'],
        zaehigkeit: map['zaehigkeit'],
        proviant: map['proviant'],
        isGlaesern: map['isGlaesern'],
        isEisern: map['isEisern'],
        isZaeh: map['isZaeh'],
        isZerbrechlich: map['isZerbrechlich'],
        hasAsp: map['hasAsp'],
        hasKap: map['hasKap']);
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
  final int spielerId;
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
