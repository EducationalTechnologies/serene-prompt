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

    await db.insert("goals", goal.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  getGoals() async {
    final db = await database;
    var maps = await db.query("goals");

    return List.generate(maps.length, (i) {
      return Goal(
          deadline: DateTime.parse(maps[i]["deadline"]),
          id: maps[i]["id"],
          goal: maps[i]["goal"],
          progress: maps[i]["progress"]);
    });
  }

  updateGoal(Goal goal) async {
    final db = await database;

    await db
        .update("goals", goal.toMap(), where: "id = ?", whereArgs: [goal.id]);
  }

  clearDatabase() async {
    final Database db = await database;

    await db.delete("goals");
  }

  insertSampleData() async {
    List<Goal> _goals = [
      Goal(
          id: 0,
          goal: "My Learning Goal Number one",
          deadline: DateTime.now(),
          progress: 40),
      Goal(
          id: 1,
          goal: "Second Thing that I have to do",
          deadline: DateTime.now(),
          progress: 5),
      Goal(id: 0, goal: "Number three", deadline: DateTime.now(), progress: 10),
      Goal(
          id: 3,
          goal: "At position four I have to do this kind of thing",
          deadline: DateTime.now(),
          progress: 20),
      Goal(
          id: 0,
          goal: "The fifth item in this list is this",
          deadline: DateTime.now(),
          progress: 30),
      Goal(
          id: 5,
          goal: "And the sixth one then is this",
          deadline: DateTime.now(),
          progress: 10),
      Goal(
          id: 0,
          goal: "My Learning Goal Number one",
          deadline: DateTime.now(),
          progress: 0),
    ];

    for (var goal in _goals) {
      await insertGoal(goal);
    }
  }
}
