import 'dart:io';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../misc.dart';
import 'model.dart';

class DBHelper {
  static const _databaseName = "inventory.db";

  DBHelper._privateConstructor();

  static final DBHelper instance = DBHelper._privateConstructor();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, _databaseName);

    var exists = await databaseExists(path);

    if (!exists) {
      print("Creating new copy from asset");

      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      ByteData data = await rootBundle.load(join("assets", "inventoryDB.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }
  }

  Future<Database> _openDatabase() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, _databaseName);
    return await openDatabase(path);
  }

  Future<void> _closeDatabase(Database db) async {
    await db.close();
  }

  // insert data into the spieler table
  Future<int?> insertSpieler(Spieler spieler) async {
    Database? db = await _openDatabase();
    int? result = await db.insert('spieler', spieler.toMap());
    _closeDatabase(db);
    print(result);
    return result;
  }

  // insert data into the spieler_stats table
  Future<void> insertSpielerStats(List<SpielerStats> spielerStatsList) async {
    Database? db = await _openDatabase();
    await db.transaction((txn) async {
      for (final spielerStats in spielerStatsList) {
        await txn.insert('spieler_stats', spielerStats.toMap());
      }
    });
    _closeDatabase(db);
  }

  // insert data into the spieler_fertigkeiten table
  Future<int?> insertSpielerFertigkeiten(
      SpielerFertigkeiten spielerFertigkeiten) async {
    Database? db = await _openDatabase();
    var result = await db
        .insert('spieler_fertigkeiten', spielerFertigkeiten.toMap())
        .then((_) {
      _closeDatabase(db);
    });
    return result;
  }

  // insert data into the spieler and spieler_stats table. Both have to be completed or the transaction fails
  Future<int?> insertSpielerAndSpielerStats(
      Spieler spieler, List<SpielerStats> spielerStatsList) async {
    Database? db = await _openDatabase();
    var result = await db.transaction((txn) async {
      // insert Spieler and get id for following inserts
      int playerId = await txn.insert('spieler', spieler.toMap());
      // insert every playerstat
      for (final spielerStats in spielerStatsList) {
        spielerStats.spielerId = playerId;
        await txn.insert('spieler_stats', spielerStats.toMap());
      }
      // Get current Group and insert player in it
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? lastGroup = prefs.getInt(currentGroup);
      txn.insert(
          'spieler_gruppen', {'spielerId': playerId, 'gruppenId': lastGroup});
    });
    _closeDatabase(db);
    return result;
  }

  // Füge eine neue Gruppe hinzu
  Future<int?> insertGruppe(String name) async {
    Database db = await _openDatabase();
    int? result = await db.insert('gruppen', {'name': name});
    _closeDatabase(db);
    return result;
  }

  // Füge einen Spieler zu einer Gruppe hinzu
  Future<int?> insertSpielerToGruppe(int spielerId, int gruppenId) async {
    Database? db = await _openDatabase();
    var result = await db.insert('spieler_gruppen',
        {'spielerId': spielerId, 'gruppenId': gruppenId}).then((_) {
      _closeDatabase(db);
    });
    return result;
  }

// get data from the spieler table
  Future<List<Spieler>> getSpieler() async {
    Database? db = await _openDatabase();
    List<Map>? maps = (await db.query('spieler')).cast<Map>();
    _closeDatabase(db);
    if (maps.isNotEmpty) {
      return List.generate(maps.length, (i) {
        return Spieler.fromMap(Map<String, dynamic>.from(maps[i]));
      });
    } else {
      return [];
    }
  }

  Future<List<Spieler>> getSpielerInGruppen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? lastGroup = prefs.getInt(currentGroup);
    Database? db = await _openDatabase();
    List<Map>? maps = (await db.rawQuery('''
    SELECT spieler.*
    FROM spieler
    INNER JOIN spieler_gruppen ON spieler.id = spieler_gruppen.spielerId
    WHERE spieler_gruppen.gruppenId = $lastGroup
  ''')).cast<Map>();
    _closeDatabase(db);
    if (maps.isNotEmpty) {
      return List.generate(maps.length, (i) {
        return Spieler.fromMap(Map<String, dynamic>.from(maps[i]));
      });
    } else {
      return [];
    }
  }

  // get data from the stats table
  Future<List<Stats>> getStats() async {
    Database? db = await _openDatabase();
    List<Map>? maps = (await db.query('stats')).cast<Map>();
    await _closeDatabase(db);
    if (maps.isNotEmpty) {
      return List.generate(maps.length, (i) {
        return Stats.fromMap(Map<String, dynamic>.from(maps[i]));
      });
    } else {
      return [];
    }
  }

  // get data from the spieler_stats table
  Future<List<SpielerStats>> getSpielerStats() async {
    Database? db = await _openDatabase();
    List<Map>? maps = (await db.query('spieler_stats')).cast<Map>();
    await _closeDatabase(db);
    if (maps.isNotEmpty) {
      return List.generate(maps.length, (i) {
        return SpielerStats.fromMap(Map<String, dynamic>.from(maps[i]));
      });
    } else {
      return [];
    }
  }

  // get data from the fertigkeiten table
  Future<List<Fertigkeiten>> getFertigkeiten() async {
    Database? db = await _openDatabase();
    List<Map>? maps = (await db.query('fertigkeiten')).cast<Map>();
    await _closeDatabase(db);
    if (maps.isNotEmpty) {
      return List.generate(maps.length, (i) {
        return Fertigkeiten.fromMap(Map<String, dynamic>.from(maps[i]));
      });
    } else {
      return [];
    }
  }

  // get data from the fertigkeiten_stats table
  Future<List<FertigkeitenStats>> getFertigkeitenStats() async {
    Database? db = await _openDatabase();
    List<Map>? maps = (await db.query('fertigkeiten_stats')).cast<Map>();
    await _closeDatabase(db);
    if (maps.isNotEmpty) {
      return List.generate(maps.length, (i) {
        return FertigkeitenStats.fromMap(Map<String, dynamic>.from(maps[i]));
      });
    } else {
      return [];
    }
  }

  // get data from the spieler_fertigkeiten table
  Future<List<SpielerFertigkeiten>> getSpielerFertigkeiten() async {
    Database? db = await _openDatabase();
    List<Map>? maps = (await db.query('spieler_fertigkeiten')).cast<Map>();
    await _closeDatabase(db);
    if (maps.isNotEmpty) {
      return List.generate(maps.length, (i) {
        return SpielerFertigkeiten.fromMap(Map<String, dynamic>.from(maps[i]));
      });
    } else {
      return [];
    }
  }

  // Hole alle Gruppen
  Future<List<Gruppen>> getGruppen() async {
    Database db = await _openDatabase();
    var maps = (await db.query('gruppen')).cast<Map>();
    await _closeDatabase(db);
    if (maps.isNotEmpty) {
      return List.generate(maps.length, (i) {
        return Gruppen.fromMap(Map<String, dynamic>.from(maps[i]));
      });
    } else {
      return [];
    }
  }

  // Hole den ersten Entry in Gruppen
  Future<int?> getFirstGroupId() async {
    Database db = await _openDatabase();
    var result = await db.query('gruppen', orderBy: 'id DESC', limit: 1);
    await _closeDatabase(db);

    if (result.isNotEmpty) {
      return result.first['id'] as int?;
    } else {
      return null;
    }
  }

  Future<String?> getGruppenName(int id) async {
    Database db = await _openDatabase();
    List<Map<String, dynamic>> result = await db.query('gruppen',
        columns: ['name'], where: 'id = ?', whereArgs: [id]);
    await _closeDatabase(db);
    if (result.isNotEmpty) {
      return result.first['name'] as String;
    } else {
      return null;
    }
  }

  // Hole alle Spieler in einer Gruppe
  Future<List<Map<String, dynamic>>?> getSpielerInGruppe(int gruppenId) async {
    Database? db = await _openDatabase();
    var result = await db.query('spieler_gruppen',
        where: 'gruppenId = ?', whereArgs: [gruppenId]);
    await _closeDatabase(db);
    return result;
  }

  // delete data from the spieler table
  Future<int?> deleteSpieler(int id) async {
    Database? db = await _openDatabase();
    var result = await db.delete('spieler', where: 'id = ?', whereArgs: [id]);
    _closeDatabase(db);
    return result;
  }

// delete data from the spieler_stats table
  Future<int?> deleteSpielerStats(int spielerId) async {
    Database? db = await _openDatabase();
    var result = await db.delete('spieler_stats',
        where: 'spielerId = ?', whereArgs: [spielerId]).then((_) {
      _closeDatabase(db);
    });
    return result;
  }

// delete data from the spieler_fertigkeiten table
  Future<int?> deleteSpielerFertigkeiten(int spielerId) async {
    Database? db = await _openDatabase();
    var result = await db.delete('spieler_fertigkeiten',
        where: 'spielerId = ?', whereArgs: [spielerId]).then((_) {
      _closeDatabase(db);
    });
    return result;
  }

  // Lösche eine Gruppe
  Future<int?> deleteGruppe(int id, bool deleteSpieler) async {
    Database? db = await _openDatabase();
    int? result;
    try {
      result = await db.transaction((txn) async {
        await txn.delete('gruppen', where: 'id = ?', whereArgs: [id]);
        //Also delete players in the group
        if (deleteSpieler) {
          await txn.delete('spieler',
              where:
                  'id IN (SELECT spielerId FROM spieler_gruppen WHERE gruppenId = ?)',
              whereArgs: [id]);
        }
        await txn
            .delete('spieler_gruppen', where: 'gruppenId = ?', whereArgs: [id]);
        return null;
      });
      _closeDatabase(db);
      return null;
    } on DatabaseException catch (e) {
      print(e.toString());
    }
    return result;
  }

  // Entferne einen Spieler aus einer Gruppe
  Future<int?> deleteSpielerFromGruppe(int spielerId, int gruppenId) async {
    Database? db = await _openDatabase();
    var result = await db.delete('spieler_gruppen',
        where: 'spielerId = ? AND gruppenId = ?',
        whereArgs: [spielerId, gruppenId]).then((_) {
      _closeDatabase(db);
    });
    return result;
  }

// update data in the spieler table
  Future<int?> updateSpieler(Spieler spieler) async {
    Database? db = await _openDatabase();
    var result = await db.update('spieler', spieler.toMap(),
        where: 'id = ?', whereArgs: [spieler.id]).then((_) {
      _closeDatabase(db);
    });
    return result;
  }

  Future<int?> updateLeben(int playerId, int newHealth) async {
    Database? db = await _openDatabase();
    var result = await db
        .update(
      'spieler',
      {'leben': newHealth},
      where: 'id = ?',
      whereArgs: [playerId],
    )
        .then((_) {
      _closeDatabase(db);
    });
    return result;
  }

  Future<int?> updateMana(int playerId, int newMana) async {
    Database? db = await _openDatabase();
    var result = await db
        .update(
      'spieler',
      {'mana': newMana},
      where: 'id = ?',
      whereArgs: [playerId],
    )
        .then((_) {
      _closeDatabase(db);
    });
    return result;
  }

  Future<int?> updateProviant(int playerId, int newProviant) async {
    Database? db = await _openDatabase();
    var result = await db
        .update(
      'spieler',
      {'proviant': newProviant},
      where: 'id = ?',
      whereArgs: [playerId],
    )
        .then((_) {
      _closeDatabase(db);
    });
    return result;
  }

  Future<int?> updateMoney(
      int playerId, List<int> money) async {
    Database? db = await _openDatabase();
    var result = await db
        .update(
      'spieler',
      {
        'dukaten': money[0],
        'silber': money[1],
        'heller': money[2],
        'kreuzer': money[3],
      },
      where: 'id = ?',
      whereArgs: [playerId],
    )
        .then((_) {
      _closeDatabase(db);
    });
    return result;
  }

// update data in the spieler_stats table
  Future<int?> updateSpielerStats(SpielerStats spielerStats) async {
    Database? db = await _openDatabase();
    var result = await db.update('spieler_stats', spielerStats.toMap(),
        where: 'spielerId = ? AND statId = ?',
        whereArgs: [spielerStats.spielerId, spielerStats.statId]).then((_) {
      _closeDatabase(db);
    });
    return result;
  }

// update data in the spieler_fertigkeiten table
  Future<int?> updateSpielerFertigkeiten(
      SpielerFertigkeiten spielerFertigkeiten) async {
    Database? db = await _openDatabase();
    var result = await db.update(
        'spieler_fertigkeiten', spielerFertigkeiten.toMap(),
        where: 'spielerId = ? AND fertigkeitId = ?',
        whereArgs: [
          spielerFertigkeiten.spielerId,
          spielerFertigkeiten.fertigkeitId
        ]).then((_) {
      _closeDatabase(db);
    });
    return result;
  }

  // Aktualisiere eine Gruppe
  Future<int?> updateGruppe(int id, String name) async {
    Database? db = await _openDatabase();
    var result = await db
        .update('gruppen', {'name': name}, where: 'id = ?', whereArgs: [id])
        .then((_) {
      _closeDatabase(db);
    });
    return result;
  }
}

// // insert data into the stats table
// Future<int> insertStats(Stats stats) async {
//   Database db = await _openDatabase(;
//   return await db.insert('stats', stats.toMap());
// }

// // insert data into the fertigkeiten table
// Future<int> insertFertigkeiten(Fertigkeiten fertigkeiten) async {
//   Database db = await _openDatabase(;
//   return await db.insert('fertigkeiten', fertigkeiten.toMap());
// }

// // insert data into the fertigkeiten_stats table
// Future<int> insertFertigkeitenStats(
//     FertigkeitenStats fertigkeitenStats) async {
//   Database db = await _openDatabase(;
//   return await db.insert('fertigkeiten_stats', fertigkeitenStats.toMap());
// }
