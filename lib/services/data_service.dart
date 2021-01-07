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
import 'package:serene/services/firebase_service.dart';
import 'package:serene/services/local_database_service.dart';
import 'package:serene/services/user_service.dart';
import 'package:serene/shared/materialized_path.dart';

class DataService {
  List<Goal> _goalsCache;
  List<Goal> _openGoalsCache = [];
  List<GoalShield> _goalShields;
  UserService _userService;
  FirebaseService _databaseService;

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
  }

  createGoal(Goal goal) async {
    //TODO: Handle the case that saving fails
    if (goal.id.isEmpty) {
      throw new Exception("Goal does not have an ID");
    }

    _openGoalsCache.add(goal);
    await _databaseService.createGoal(goal, _userService.getUserEmail());
    if (goal.parentId.isNotEmpty) {
      var parentPath = getGoalById(goal.parentId).path;
      goal.path = MaterializedPath.addToPath(parentPath, goal.path);
    }

    // TODO: THIS IS FOR TESTING CURRENTLY
    postToServer(goal);
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
    // TODO: Replace with actual code
    return await Future.delayed(Duration.zero).then((value) {
      return "Wenn ich beim Lernen müde werde, dann stehe ich kurz auf und strecke mich";
    });
  }

  Future<int> getInternalisationCondition() async {
    return _userService.getUserData().internalisationCondition;
  }

  saveInternalisation(Internalisation internalisation) async {
    return await _databaseService.saveInternalisation(
        internalisation, _userService.getUserEmail());
  }

  saveRecallTask(RecallTask recallTask) async {
    return await _databaseService.saveRecallTask(
        recallTask, _userService.getUserEmail());
  }

  Future<Internalisation> getLastInternalisation() async {
    return await _databaseService
        .getLastInternalisation(_userService.getUserEmail());
  }
}
