import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

// database table and column names
final String tableWords = 'implementationIntentions';
final String columnId = '_id';
final String columnGoal = 'goal';
final String columnHindrance = 'hindrance';

//TODO: Continue here https://pusher.com/tutorials/local-data-flutter

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "TestDB.db");
    return await openDatabase(
      path, 
      version: 1, 
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute("CREATE TABLE goals(id INTEGER PRIMARY KEY, " +
        "goal STRING, " +
        "deadline STRING, " +
        ""
        ")");
    });
  }
}
