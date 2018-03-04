import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class a {
  Future abc()async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "demo.db");

    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
// When creating the db, create the table
          await db.execute(
              "CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)");
        });
  }
}

