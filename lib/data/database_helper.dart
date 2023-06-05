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

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
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
        print('looking for parent OK');
      } catch (_) {}

// Copy from asset
      ByteData data = await rootBundle.load(join("assets", "inventoryDB.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      print('copy from asset OK');

// Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
      print('write object OK');
    } else {
      print("Opening existing database");
      var db = await openDatabase(path, readOnly: true);
      print(db.isOpen);
      await db.close();
      print(db.isOpen);
    }
  }

  // insert data into the spieler table
  Future<int> insertSpieler(Spieler spieler) async {
    Database db = await instance.database;
    return await db.insert('spieler', spieler.toMap());
  }

  // insert data into the spieler_stats table
  Future<int> insertSpielerStats(SpielerStats spielerStats) async {
    Database db = await instance.database;
    return await db.insert('spieler_stats', spielerStats.toMap());
  }

  // insert data into the spieler_fertigkeiten table
  Future<int> insertSpielerFertigkeiten(
      SpielerFertigkeiten spielerFertigkeiten) async {
    Database db = await instance.database;
    return await db.insert('spieler_fertigkeiten', spielerFertigkeiten.toMap());
  }

  // get data from the spieler table
  Future<List<Spieler>> getSpieler() async {
    Database db = await instance.database;
    List<Map> maps = await db.query('spieler');
    return List.generate(maps.length, (i) {
      return Spieler.fromMap(Map<String, dynamic>.from(maps[i]));
    });
  }

  // get data from the stats table
  Future<List<Stats>> getStats() async {
    Database db = await instance.database;
    List<Map> maps = await db.query('stats');
    return List.generate(maps.length, (i) {
      return Stats.fromMap(Map<String, dynamic>.from(maps[i]));
    });
  }

  // get data from the spieler_stats table
  Future<List<SpielerStats>> getSpielerStats() async {
    Database db = await instance.database;
    List<Map> maps = await db.query('spieler_stats');
    return List.generate(maps.length, (i) {
      return SpielerStats.fromMap(Map<String, dynamic>.from(maps[i]));
    });
  }

  // get data from the fertigkeiten table
  Future<List<Fertigkeiten>> getFertigkeiten() async {
    Database db = await instance.database;
    List<Map> maps = await db.query('fertigkeiten');
    return List.generate(maps.length, (i) {
      return Fertigkeiten.fromMap(Map<String, dynamic>.from(maps[i]));
    });
  }

  // get data from the fertigkeiten_stats table
  Future<List<FertigkeitenStats>> getFertigkeitenStats() async {
    Database db = await instance.database;
    List<Map> maps = await db.query('fertigkeiten_stats');
    return List.generate(maps.length, (i) {
      return FertigkeitenStats.fromMap(Map<String, dynamic>.from(maps[i]));
    });
  }

  // get data from the spieler_fertigkeiten table
  Future<List<SpielerFertigkeiten>> getSpielerFertigkeiten() async {
    Database db = await instance.database;
    List<Map> maps = await db.query('spieler_fertigkeiten');
    return List.generate(maps.length, (i) {
      return SpielerFertigkeiten.fromMap(Map<String, dynamic>.from(maps[i]));
    });
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