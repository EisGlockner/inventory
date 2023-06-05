import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<List<Map>> getData() async {
  var databasesPath = await getDatabasesPath();
  var path = join(databasesPath, "inventory.db");

  // open the database
  Database db = await openDatabase(path);

  // Get the records
  List<Map> list = await db.rawQuery('SELECT f.name AS fertigkeit,'
      'st1.name AS stat1,'
      'st2.name AS stat2,'
      'st3.name AS stat3 '
      'FROM fertigkeiten AS f '
      'JOIN fertigkeiten_stats AS fs ON fs.fertigkeit_id = f.id '
      'JOIN stats AS st1 ON st1.id = fs.stat1_id '
      'JOIN stats AS st2 ON st2.id = fs.stat2_id '
      'JOIN stats AS st3 ON st3.id = fs.stat3_id ;'
      'WHERE f.name = \'Heilkunde Wunden\';');

  // close the database
  await db.close();

  return list;
}

// Insert Data
// Future<void> insertData({
//   required String name,
//   required int leben,
//   required int mana,
//   required int seelenkraft,
//   required int zaehigkeit,
//   required int proviant,
//   required int isGlaesern,
//   required int isEisern,
//   required int isZaeh,
//   required int isZerbrechlich,
//   required int hasAsp,
//   required int hasKap,
//   required int MU,
//   required int KL,
//   required int IN,
//   required int CH,
//   required int FF,
//   required int GE,
//   required int KO,
//   required int KK,
// }) async {
//   var databasesPath = await getDatabasesPath();
//   var path = join(databasesPath, "inventory.db");
//
//   // open the database
//   Database db = await openDatabase(path);
//
//   // Insert the spieler record
//   int spielerId = await db.insert(
//     'spieler',
//     {
//       'name': name,
//       'leben': leben,
//       'mana': mana,
//       'seelenkraft': seelenkraft,
//       'zaehigkeit': zaehigkeit,
//       'proviant': proviant,
//       'isGlaesern': isGlaesern,
//       'isEisern': isEisern,
//       'isZaeh': isZaeh,
//       'isZerbrechlich': isZerbrechlich,
//       'hasAsp': hasAsp,
//       'hasKap': hasKap,
//     },
//     conflictAlgorithm: ConflictAlgorithm.replace,
//   );
//
//   // Insert the spieler_stats records
//   await db.insert(
//     'spieler_stats',
//     {
//       'spieler_id': spielerId,
//       'stat_id': 1,
//       'wert': MU,
//     },
//     conflictAlgorithm: ConflictAlgorithm.replace,
//   );
//   await db.insert(
//     'spieler_stats',
//     {
//       'spieler_id': spielerId,
//       'stat_id': 2,
//       'wert': KL,
//     },
//     conflictAlgorithm: ConflictAlgorithm.replace,
//   );
//   await db.insert(
//     'spieler_stats',
//     {
//       'spieler_id': spielerId,
//       'stat_id': 3,
//       'wert': IN,
//     },
//     conflictAlgorithm: ConflictAlgorithm.replace,
//   );
//   await db.insert(
//     'spieler_stats',
//     {
//       'spieler_id': spielerId,
//       'stat_id': 4,
//       'wert': CH,
//     },
//     conflictAlgorithm: ConflictAlgorithm.replace,
//   );
//   await db.insert(
//     'spieler_stats',
//     {
//       'spieler_id': spielerId,
//       'stat_id': 5,
//       'wert': FF,
//     },
//     conflictAlgorithm: ConflictAlgorithm.replace,
//   );
//   await db.insert(
//     'spieler_stats',
//     {
//       'spieler_id': spielerId,
//       'stat_id': 6,
//       'wert': GE,
//     },
//     conflictAlgorithm: ConflictAlgorithm.replace,
//   );
//   await db.insert(
//     'spieler_stats',
//     {
//       'spieler_id': spielerId,
//       'stat_id': 7,
//       'wert': KO,
//     },
//     conflictAlgorithm: ConflictAlgorithm.replace,
//   );
//   await db.insert(
//     'spieler_stats',
//     {
//       'spieler_id': spielerId,
//       'stat_id': 8,
//       'wert': KK,
//     },
//     conflictAlgorithm: ConflictAlgorithm.replace,
//   );
//
//   // close the database
//   await db.close();
// }

void printData() async {
  List<Map> data = await testing();
  for (var item in data) {
    print(item);
  }
}

Future<List<Map>> getFertigkeitenData(int spielerId) async {
  var databasesPath = await getDatabasesPath();
  var path = join(databasesPath, "inventory.db");

  // open the database
  Database db = await openDatabase(path);

  // Get the records
  List<Map> list = await db.rawQuery('''
    SELECT f.name AS fertigkeit_name,
       st1.name AS stat1_name,
       st2.name AS stat2_name,
       st3.name AS stat3_name
FROM fertigkeiten AS f
JOIN fertigkeiten_stats AS fs ON fs.fertigkeit_id = f.id
JOIN stats AS st1 ON st1.id = fs.stat1_id
JOIN stats AS st2 ON st2.id = fs.stat2_id
JOIN stats AS st3 ON st3.id = fs.stat3_id
WHERE f.name = 'Heilkunde Wunden';
  ''');

  // close the database
  await db.close();

  return list;
}

// Future<void> deleteData(int spielerId) async {
//   var databasesPath = await getDatabasesPath();
//   var path = join(databasesPath, "inventory.db");
//
//   // open the database
//   Database db = await openDatabase(path);
//
  // Delete the spieler record
//   await db.delete(
//     'spieler',
//     where: 'id = ?',
//     whereArgs: [spielerId],
//   );
//
//   // Delete the spieler_stats records
//   // await db.delete(
//   //   'spieler_stats',
//   //   where: 'spieler_id = ?',
//   //   whereArgs: [spielerId],
//   // );
//
//   // close the database
//   await db.close();
// }

Future<List<Map>> testing() async {
  var databasesPath = await getDatabasesPath();
  var path = join(databasesPath, "inventory.db");

  // open the database
  Database db = await openDatabase(path);

  // Get the records
  List<Map> list = await db.rawQuery('''
    Select * from spieler;
  ''');

  // close the database
  await db.close();

  for (var item in list) {
    print(item);
  }

  return list;
}

Future<void> insertData({
  required String name,
  required int leben,
  required int mana,
  required int seelenkraft,
  required int zaehigkeit,
  required int proviant,
  required int isGlaesern,
  required int isEisern,
  required int isZaeh,
  required int isZerbrechlich,
  required int hasAsp,
  required int hasKap,
  required int MU,
  required int KL,
  required int IN,
  required int CH,
  required int FF,
  required int GE,
  required int KO,
  required int KK,
}) async {
  var databasesPath = await getDatabasesPath();
  var path = join(databasesPath, "inventory.db");

  // open the database
  Database db = await openDatabase(path);

  await db.transaction((txn) async {
    // Insert the spieler record
    int spielerId = await txn.insert(
      'spieler',
      {
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
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Insert the spieler_stats records
    await txn.insert(
      'spieler_stats',
      {
        'spieler_id': spielerId,
        'stat_id': 1,
        'wert': MU,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await txn.insert(
      'spieler_stats',
      {
        'spieler_id': spielerId,
        'stat_id': 2,
        'wert': KL,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await txn.insert(
      'spieler_stats',
      {
        'spieler_id': spielerId,
        'stat_id': 3,
        'wert': IN,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await txn.insert(
      'spieler_stats',
      {
        'spieler_id': spielerId,
        'stat_id': 4,
        'wert': CH,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await txn.insert(
      'spieler_stats',
      {
        'spieler_id': spielerId,
        'stat_id': 5,
        'wert': FF,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await txn.insert(
      'spieler_stats',
      {
        'spieler_id': spielerId,
        'stat_id': 6,
        'wert': GE,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await txn.insert(
      'spieler_stats',
      {
        'spieler_id': spielerId,
        'stat_id': 7,
        'wert': KO,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await txn.insert(
      'spieler_stats',
      {
        'spieler_id': spielerId,
        'stat_id': 8,
        'wert': KK,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  });

  // close the database
  await db.close();
}


/// Delete
Future<void> deleteData(int spielerId) async {
  var databasesPath = await getDatabasesPath();
  var path = join(databasesPath, "inventory.db");

  // open the database
  Database db = await openDatabase(path);

  await db.transaction((txn) async {
    // Delete the spieler record
    await txn.delete(
      'spieler',
      where: 'id = ?',
      whereArgs: [spielerId],
    );

    // Delete the spieler_stats records
    await txn.delete(
      'spieler_stats',
      where: 'spieler_id = ?',
      whereArgs: [spielerId],
    );
  });

  // close the database
  await db.close();
}

