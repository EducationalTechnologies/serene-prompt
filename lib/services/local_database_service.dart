import 'dart:io';
import 'package:serene/models/goal.dart';
import 'package:serene/shared/enums.dart';
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
const String TABLE_SETTINGS = "settings";
const int DB_VERSION = 4;

class LocalDatabaseService {
  LocalDatabaseService._();
  static final LocalDatabaseService db = LocalDatabaseService._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "TestDB.db");
    return await openDatabase(path,
        version: DB_VERSION,
        onOpen: (db) {},
        onUpgrade: _onUpgrade, onCreate: (Database db, int version) async {
      await db.execute(
          "CREATE TABLE $TABLE_GOALS(id INTEGER PRIMARY KEY AUTOINCREMENT, " +
              "goalText STRING, " +
              "deadline STRING, " +
              "documentId STRING, " +
              "difficulty STRING, " +
              "userId STRING, " +
              "progressIndicator STRING, " +
              "progress INTEGER"
                  ")");

      await db.execute("CREATE TABLE $TABLE_SETTINGS(key STRING PRIMARY KEY, " +
          // "key STRING, " +
          "value STRING " +
          ")");
    });
  }

//TODO: Write a better migration script
  _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion != newVersion) {
      await db.execute("DROP TABLE IF EXISTS $TABLE_GOALS");
      await db.execute(
          "CREATE TABLE IF NOT EXISTS $TABLE_GOALS(id STRING PRIMARY KEY, " +
              "goalText STRING, " +
              "deadline STRING, " +
              "documentId STRING, " +
              "difficulty STRING, " +
              "userId STRING, " +
              "progressIndicator STRING, " +
              "progress INTEGER"
                  ")");

      await db.execute("DROP TABLE IF EXISTS $TABLE_SETTINGS");
      await db.execute(
          "CREATE TABLE IF NOT EXISTS $TABLE_SETTINGS(key STRING PRIMARY KEY, " +
              // "key STRING, " +
              "value STRING " +
              ")");
    }
  }

  upsertSetting(String key, String value) async {
    final db = await database;
    await db.insert(TABLE_SETTINGS, {"key": key, "value": value},
        conflictAlgorithm: ConflictAlgorithm.replace);
    // var existing =
    //     await db.rawQuery("select * from $TABLE_SETTINGS where key = $key");
    // // var result = await db.query(TABLE_GOALS, where: whereString);

    // if (existing.length == 0) {
    //   await db.insert(TABLE_SETTINGS, {"key": key, "value": value},
    //       conflictAlgorithm: ConflictAlgorithm.replace);
    // } else {
    //   await db.update(TABLE_SETTINGS, {"key": key, "value": value});
    // }
  }

  Future<List<Map<String, dynamic>>> getAllSettings() async {
    final db = await database;

    var existing = await db.rawQuery("select * from $TABLE_SETTINGS");

    return existing;
  }

  getSettingsValue(String key) async {
    final db = await database;

    var existing =
        await db.rawQuery("select * from $TABLE_SETTINGS where key = $key");

    if (existing == null) return null;
    return existing[0][key];
  }

  insertGoal(Goal goal) async {
    final Database db = await database;

    await db.insert(TABLE_GOALS, goal.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  getGoalListFromMap(List<Map<String, dynamic>> map) {
    return List.generate(map.length, (i) {
      DateTime deadline;
      var progressIndicator = GoalProgressIndicator.checkbox;
      if (map[i]["deadline"] != "") {
        deadline = DateTime.parse(map[i]["deadline"]);
      }
      if (map[i].containsKey("progressIndicator")) {
        progressIndicator = map[i]["progressIndicator"];
      }

      return Goal(
          deadline: deadline,
          id: map[i]["id"],
          goalText: (map[i]["goalText"]).toString(),
          progressIndicator: progressIndicator,
          difficulty: map[i]["difficulty"],
          userId: map[i]["userId"],
          progress: map[i]["progress"]);
    });
  }

  getOpenGoals() async {
    print("Fetching OPEN goals from database");
    final db = await database;

    // var result = await db.query(TABLE_GOALS, where: whereString);

    var result =
        await db.rawQuery("select * from $TABLE_GOALS where progress < 100");

    return getGoalListFromMap(result);
  }

  getGoals() async {
    print("OBTAINING GOALS FROM DATABASE");
    final db = await database;
    var maps = await db.query(TABLE_GOALS);

    return List.generate(maps.length, (i) {
      DateTime deadline;
      var progressIndicator = GoalProgressIndicator.checkbox;
      var goalDifficulty = GoalDifficulty.medium;
      if (maps[i]["deadline"] != "") {
        deadline = DateTime.parse(maps[i]["deadline"]);
      }
      if (maps[i].containsKey("progressIndicator")) {
        progressIndicator = maps[i]["progressIndicator"];
      }
      if (maps[i].containsKey("difficulty")) {
        goalDifficulty = maps[i]["difficulty"];
      }

      return Goal(
          deadline: deadline,
          id: maps[i]["id"],
          goalText: maps[i]["goalText"].toString(),
          progressIndicator: progressIndicator,
          difficulty: goalDifficulty,
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
          id: "0",
          goalText: "Fix the audio recording issue",
          progressIndicator: GoalProgressIndicator.checkbox,
          deadline: DateTime.now(),
          progress: 40),
      Goal(
          id: "1",
          goalText: "Create the informed consent screen",
          progressIndicator: GoalProgressIndicator.slider,
          deadline: DateTime.now(),
          progress: 5),
      Goal(
          id: "2",
          goalText: "Ethikantrag ausfüllen",
          progressIndicator: GoalProgressIndicator.checkbox,
          deadline: DateTime.now(),
          progress: 20),
    ];

    for (var goal in _goals) {
      await insertGoal(goal);
    }
  }
}
