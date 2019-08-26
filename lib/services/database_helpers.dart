import 'dart:io';
import 'package:implementation_intentions/models/goal.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';

// database table and column names
final String tableWords = 'implementationIntentions';
final String columnId = '_id';
final String columnGoal = 'goal';
final String columnHindrance = 'hindrance';

const String TABLE_GOALS = "goals";

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
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db
          .execute("CREATE TABLE goals(id INTEGER PRIMARY KEY AUTOINCREMENT, " +
              "goal STRING, " +
              "deadline STRING, " +
              "progress INTEGER"
                  ")");
    });
  }

  insertGoal(Goal goal) async {
    final Database db = await database;

    await db.insert(TABLE_GOALS, goal.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  getGoals() async {
    print("OBTAINING GOALS FROM DATABASE");
    final db = await database;
    var maps = await db.query(TABLE_GOALS);

    return List.generate(maps.length, (i) {
      var deadline;
      if (maps[i]["deadline"] != "") {
        deadline = DateTime.parse(maps[i]["deadline"]);
      }

      return Goal(
          deadline: deadline,
          id: maps[i]["id"],
          goal: maps[i]["goal"],
          progress: maps[i]["progress"]);
    });
  }

  updateGoal(Goal goal) async {
    final db = await database;

    await db.update(TABLE_GOALS, goal.toMap(),
        where: "id = ?", whereArgs: [goal.id]);
  }

  deleteGoal(Goal goal) async {
    final Database db = await database;

    await db.delete(TABLE_GOALS, where: "id = ?", whereArgs: [goal.id]);
  }

  clearDatabase() async {
    final Database db = await database;

    await db.delete(TABLE_GOALS);
  }

  insertSampleData() async {
    List<Goal> _goals = [
      Goal(
          id: 0,
          goal: "Word Bank implementieren",
          deadline: DateTime.now(),
          progress: 40),
      Goal(
          id: 1,
          goal: "Aufgabe 2 b) fertig stellen",
          deadline: DateTime.now(),
          progress: 5),
      Goal(
          id: 2,
          goal: "Ethikantrag ausfüllen",
          deadline: DateTime.now(),
          progress: 20),
    ];

    for (var goal in _goals) {
      await insertGoal(goal);
    }
  }
}
