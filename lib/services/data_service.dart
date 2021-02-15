import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:serene/models/assessment.dart';
import 'package:serene/models/goal.dart';
import 'package:serene/models/goal_shield.dart';
import 'package:serene/models/internalisation.dart';
import 'package:serene/models/obstacle.dart';
import 'package:serene/models/outcome.dart';
import 'package:serene/models/recall_task.dart';
import 'package:serene/models/user_data.dart';
import 'package:serene/services/firebase_service.dart';
import 'package:serene/services/local_database_service.dart';
import 'package:serene/services/user_service.dart';
import 'package:serene/shared/materialized_path.dart';

class DataService {
  List<Goal> _goalsCache = [];
  List<Goal> _openGoalsCache = [];
  List<dynamic> _ldtTaskListCache = [];
  List<dynamic> _ldtListStrings = [];
  List<GoalShield> _goalShields;
  List<String> _planCache = [];
  UserService _userService;
  FirebaseService _databaseService;
  int score;

  UserData _userDataCache;

  DataService(this._databaseService, this._userService);

  get goals {
    return UnmodifiableListView(_goalsCache);
  }

  get openGoals {
    return UnmodifiableListView(_openGoalsCache);
  }

  Goal getGoalById(String id) {
    try {
      return _openGoalsCache.firstWhere((g) => g.id == id, orElse: null);
    } catch (error) {
      return null;
    }
  }

  clearCache() {
    this._openGoalsCache.clear();
    this._goalsCache.clear();
    this._planCache.clear();
    this._ldtTaskListCache.clear();
  }

  createGoal(Goal goal) async {
    if (goal.id.isEmpty) {
      throw new Exception("Goal does not have an ID");
    }

    _openGoalsCache.add(goal);
    await _databaseService.createGoal(goal, _userService.getUserEmail());
    if (goal.parentId.isNotEmpty) {
      var parentPath = getGoalById(goal.parentId).path;
      goal.path = MaterializedPath.addToPath(parentPath, goal.path);
    }
  }

  postToServer(Goal goal) async {
    print("Posting Goal to Server");

    var body = json.encode({
      "goal": goal.goalText,
      "start": goal.deadline?.toIso8601String(),
      "end": goal.deadline?.toIso8601String()
    });

    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);

    var url = "https://10.0.2.2:5001/api/LearningSession";

    try {
      var request = await client.postUrl(Uri.parse(url));
      request.headers.set("content-type", "application/json");
      request.add(utf8.encode(body));

      var response = await request.close();

      var reply = await response.transform(utf8.decoder).join();
      print(reply);
    } catch (e) {
      print("error in POST");
      print(e);
    }
  }

  getGoals() async {
    _goalsCache = await LocalDatabaseService.db.getGoals();
    return _goalsCache;
  }

  Future<List<Goal>> getOpenGoals() async {
    if (_openGoalsCache.length == 0) {
      var mail = _userService.getUserEmail();
      _openGoalsCache = await _databaseService.retrieveOpenGoals(mail);
    }
    return _openGoalsCache;
  }

  updateGoal(Goal goal) async {
    var goalIndex = _openGoalsCache.indexOf(goal);
    if (goalIndex >= 0) {
      if (goal.progress >= 100) {
        _openGoalsCache.removeAt(goalIndex);
      }
    }
    await _databaseService.updateGoal(goal, _userService.getUserEmail());
  }

  deleteGoal(Goal goal) async {
    var goalIndex = _openGoalsCache.indexOf(goal);
    if (goalIndex >= 0) {
      _openGoalsCache.removeAt(goalIndex);
    }
    await _databaseService.deleteGoal(goal, _userService.getUserEmail());
  }

  getGoalShields() async {
    String data = await rootBundle.loadString("assets/hindrances.json");
    _goalShields = [];
    var decoded = jsonDecode(data);
    for (var s in decoded) {
      _goalShields.add(GoalShield.fromJson(s));
    }
    return _goalShields;
  }

  saveAssessment(AssessmentModel assessment) async {
    await _databaseService.saveAssessment(
        assessment, _userService.getUserEmail());
  }

  Future<AssessmentModel> getLastSubmittedAssessment(
      String assessmentType) async {
    return await _databaseService.getLastSubmittedAssessment(
        assessmentType, _userService.getUserEmail());
  }

  saveShielding(GoalShield shield) async {
    shield.submissionDate = DateTime.now();
    return await _databaseService.saveShielding(
        shield, _userService.getUserEmail());
  }

  Future<GoalShield> getLastGoalShield() async {
    return await _databaseService
        .getLastSubmittedGoalShield(_userService.getUserEmail());
  }

  saveSelectedOutcomes(List<Outcome> outcomes) async {
    return await _databaseService.saveOutcomes(
        outcomes, _userService.getUserEmail());
  }

  saveSelectedObstacles(List<Obstacle> obstacles) async {
    return await _databaseService.saveObstacles(
        obstacles, _userService.getUserEmail());
  }

  getCurrentImplementationIntention() async {
    if (_planCache.length == 0) {
      String data = await rootBundle.loadString("assets/config/ldt_ii.json");
      for (var plan in jsonDecode(data)) {
        _planCache.add(plan["sentence"]);
      }
    }
    var userData = await getUserData();
    var condition = userData.internalisationCondition;
    var plan = _planCache[condition];
    return plan;
  }

  getLexicalDecisionTaskListII() async {
    if (this._ldtTaskListCache.length == 0) {
      String data = await rootBundle.loadString("assets/config/ldt_ii.json");
      for (var ldtTask in jsonDecode(data)) {
        _ldtTaskListCache.add(ldtTask);
      }
    }

    return _ldtTaskListCache;
  }

  getLexicalDecisionTaskListStrings() async {
    if (this._ldtListStrings.length == 0) {
      String data =
          await rootBundle.loadString("assets/config/ldt_strings.json");
      for (var ldtTask in jsonDecode(data)) {
        _ldtListStrings.add(ldtTask);
      }
    }

    return _ldtListStrings;
  }

  saveInternalisation(Internalisation internalisation) async {
    return await _databaseService.saveInternalisation(
        internalisation, _userService.getUserEmail());
  }

  saveRecallTask(RecallTask recallTask) async {
    return await _databaseService.saveRecallTask(
        recallTask, _userService.getUserEmail());
  }

  Future<Internalisation> getFirstInternalisation() async {
    return await _databaseService
        .getFirstInternalisation(_userService.getUserEmail());
  }

  Future<Internalisation> getLastInternalisation() async {
    return await _databaseService
        .getLastInternalisation(_userService.getUserEmail());
  }

  Future<List<Internalisation>> getLastInternalisations(int number) async {
    return await _databaseService.getLastInternalisations(
        _userService.getUserEmail(), number);
  }

  Future<RecallTask> getLastRecallTask() async {
    return await _databaseService
        .getLastRecallTask(_userService.getUserEmail());
  }

  Future<UserData> getUserData() async {
    if (_userDataCache == null) {
      _userDataCache =
          await _databaseService.getUserData(_userService.getUserEmail());
    }
    return _userDataCache;
  }

  saveObstacles(List<Obstacle> obstacles) async {
    await _databaseService.saveObstacles(
        obstacles, _userService.getUserEmail());
  }

  saveOutcomes(List<Outcome> outcomes) async {
    await _databaseService.saveOutcomes(outcomes, _userService.getUserEmail());
  }

  saveConsent(bool consented) async {
    await _databaseService.saveConsent(_userService.getUserEmail(), consented);
  }

  saveEmojiInternalisation(Internalisation internalisation) async {
    await _databaseService.saveEmojiInternalisation(
        _userService.getUserEmail(), internalisation);
  }

  getScore() async {
    return await _databaseService.getScore(_userService.getUserEmail());
  }

  saveScore(int score) async {
    await _databaseService.saveScore(_userService.getUserEmail(), score);
  }

  logData(dynamic data) async {
    data["user"] = _userService.getUserEmail();
    await _databaseService.logEvent(_userService.getUserEmail(), data);
  }

  updateInternalisationConditionGroup(int group) async {
    await _databaseService.updateInternalisationConditionGroup(
        _userService.getUserEmail(), group);
    _userDataCache.internalisationCondition = group;
  }
}
