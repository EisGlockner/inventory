import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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

    // Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
// Should happen only the first time you launch your application
      print("Creating new copy from asset");

// Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

// Copy from asset
      ByteData data = await rootBundle.load(join("assets", "inventoryDB.db"));
      List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

// Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
      var db = await openDatabase(path, readOnly: true);
      await db.close();
    }
  }

  // insert data into the spieler table
  Future<int?> insertSpieler(Spieler spieler) async {
    Database? db = await instance.database;
    return await db?.insert('spieler', spieler.toMap());
  }

  // insert data into the spieler_stats table
  Future<int?> insertSpielerStats(SpielerStats spielerStats) async {
    Database? db = await instance.database;
    return await db?.insert('spieler_stats', spielerStats.toMap());
  }

  // insert data into the spieler_fertigkeiten table
  Future<int?> insertSpielerFertigkeiten(
      SpielerFertigkeiten spielerFertigkeiten) async {
    Database? db = await instance.database;
    return await db?.insert('spieler_fertigkeiten', spielerFertigkeiten.toMap());
  }

  // insert data into the spieler and spieler_stats table. Both have to be completed or the transaction fails
  Future<void> insertSpielerAndSpielerStats(Spieler spieler,
      SpielerStats spielerStats) async {
    Database? db = await instance.database;
    await db?.transaction((txn) async {
      await txn.insert('spieler', spieler.toMap());
      await txn.insert('spieler_stats', spielerStats.toMap());
    });
  }

  // Füge eine neue Gruppe hinzu
  Future<int?> insertGruppe(String name) async {
    Database? db = await instance.database;
    return await db?.insert('gruppen', {'name': name});
  }

  // Füge einen Spieler zu einer Gruppe hinzu
  Future<int?> addSpielerToGruppe(int spielerId, int gruppenId) async {
    Database? db = await instance.database;
    return await db?.insert('spieler_gruppen', {'spielerId': spielerId, 'gruppenId': gruppenId});
  }

  // get data from the spieler table
  Future<List<Spieler>> getSpieler() async {
    Database? db = await instance.database;
    List<Map>? maps = (await db?.query('spieler'))?.cast<Map>();
    return List.generate(maps!.length, (i) {
      return Spieler.fromMap(Map<String, dynamic>.from(maps[i]));
    });
  }

  // get data from the stats table
  Future<List<Stats>> getStats() async {
    Database? db = await instance.database;
    List<Map>? maps = (await db?.query('stats'))?.cast<Map>();
    return List.generate(maps!.length, (i) {
      return Stats.fromMap(Map<String, dynamic>.from(maps[i]));
    });
  }

  // get data from the spieler_stats table
  Future<List<SpielerStats>> getSpielerStats() async {
    Database? db = await instance.database;
    List<Map>? maps = (await db?.query('spieler_stats'))?.cast<Map>();
    return List.generate(maps!.length, (i) {
      return SpielerStats.fromMap(Map<String, dynamic>.from(maps[i]));
    });
  }

  // get data from the fertigkeiten table
  Future<List<Fertigkeiten>> getFertigkeiten() async {
    Database? db = await instance.database;
    List<Map>? maps = (await db?.query('fertigkeiten'))?.cast<Map>();
    return List.generate(maps!.length, (i) {
      return Fertigkeiten.fromMap(Map<String, dynamic>.from(maps[i]));
    });
  }

  // get data from the fertigkeiten_stats table
  Future<List<FertigkeitenStats>> getFertigkeitenStats() async {
    Database? db = await instance.database;
    List<Map>? maps = (await db?.query('fertigkeiten_stats'))?.cast<Map>();
    return List.generate(maps!.length, (i) {
      return FertigkeitenStats.fromMap(Map<String, dynamic>.from(maps[i]));
    });
  }

  // get data from the spieler_fertigkeiten table
  Future<List<SpielerFertigkeiten>> getSpielerFertigkeiten() async {
    Database? db = await instance.database;
    List<Map>? maps = (await db?.query('spieler_fertigkeiten'))?.cast<Map>();
    return List.generate(maps!.length, (i) {
      return SpielerFertigkeiten.fromMap(Map<String, dynamic>.from(maps[i]));
    });
  }

  // Hole alle Gruppen
  Future<List<Map<String, dynamic>>?> getGruppen() async {
    Database? db = await instance.database;
    return await db?.query('gruppen');
  }

  // Hole alle Spieler in einer Gruppe
  Future<List<Map<String, dynamic>>?> getSpielerInGruppe(int gruppenId) async {
    Database? db = await instance.database;
    return await db?.query('spieler_gruppen', where: 'gruppenId = ?', whereArgs: [gruppenId]);
  }

  // delete data from the spieler table
  Future<int?> deleteSpieler(int id) async {
    Database? db = await instance.database;
    return await db?.delete('spieler', where: 'id = ?', whereArgs: [id]);
  }

// delete data from the spieler_stats table
  Future<int?> deleteSpielerStats(int spielerId) async {
    Database? db = await instance.database;
    return await db?.delete(
        'spieler_stats', where: 'spielerId = ?', whereArgs: [spielerId]);
  }

// delete data from the spieler_fertigkeiten table
  Future<int?> deleteSpielerFertigkeiten(int spielerId) async {
    Database? db = await instance.database;
    return await db?.delete(
        'spieler_fertigkeiten', where: 'spielerId = ?', whereArgs: [spielerId]);
  }

  // Lösche eine Gruppe
  Future<int?> deleteGruppe(int id) async {
    Database? db = await instance.database;
    return await db?.delete('gruppen', where: 'id = ?', whereArgs: [id]);
  }

  // Entferne einen Spieler aus einer Gruppe
  Future<int?> removeSpielerFromGruppe(int spielerId, int gruppenId) async {
    Database? db = await instance.database;
    return await db?.delete('spieler_gruppen', where: 'spielerId = ? AND gruppenId = ?', whereArgs: [spielerId, gruppenId]);
  }

// update data in the spieler table
  Future<int?> updateSpieler(Spieler spieler) async {
    Database? db = await instance.database;
    return await db?.update(
        'spieler', spieler.toMap(), where: 'id = ?', whereArgs: [spieler.id]);
  }

// update data in the spieler_stats table
  Future<int?> updateSpielerStats(SpielerStats spielerStats) async {
    Database? db = await instance.database;
    return await db?.update('spieler_stats', spielerStats.toMap(),
        where: 'spielerId = ? AND statId = ?',
        whereArgs: [spielerStats.spielerId, spielerStats.statId]);
  }

// update data in the spieler_fertigkeiten table
  Future<int?> updateSpielerFertigkeiten(
      SpielerFertigkeiten spielerFertigkeiten) async {
    Database? db = await instance.database;
    return await db?.update('spieler_fertigkeiten', spielerFertigkeiten.toMap(),
        where: 'spielerId = ? AND fertigkeitId = ?',
        whereArgs: [
          spielerFertigkeiten.spielerId,
          spielerFertigkeiten.fertigkeitId
        ]);
  }

  // Aktualisiere eine Gruppe
  Future<int?> updateGruppe(int id, String name) async {
    Database? db = await instance.database;
    return await db?.update('gruppen', {'name': name}, where: 'id = ?', whereArgs: [id]);
  }
}


// // insert data into the stats table
// Future<int> insertStats(Stats stats) async {
//   Database db = await instance.database;
//   return await db.insert('stats', stats.toMap());
// }


// // insert data into the fertigkeiten table
// Future<int> insertFertigkeiten(Fertigkeiten fertigkeiten) async {
//   Database db = await instance.database;
//   return await db.insert('fertigkeiten', fertigkeiten.toMap());
// }

// // insert data into the fertigkeiten_stats table
// Future<int> insertFertigkeitenStats(
//     FertigkeitenStats fertigkeitenStats) async {
//   Database db = await instance.database;
//   return await db.insert('fertigkeiten_stats', fertigkeitenStats.toMap());
// }