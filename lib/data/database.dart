import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<void> copyDB() async {
  var databasesPath = await getDatabasesPath();
  var path = join(databasesPath, "inventory.db");

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
