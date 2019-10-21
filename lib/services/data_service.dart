import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:serene/locator.dart';
import 'package:serene/models/assessment.dart';
import 'package:serene/models/goal.dart';
import 'package:serene/models/goal_shield.dart';
import 'package:serene/services/firebase_service.dart';
import 'package:serene/services/local_database_service.dart';
import 'package:serene/services/user_service.dart';

class DataService {
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  List<Goal> _goals;
  List<Goal> _openGoalsCache = [];
  List<GoalShield> _goalShields;

  DataService._internal() {
    //TODO: Create initialize service
  }

  get goals {
    return _goals;
  }

  get openGoals {
    return _openGoalsCache;
  }

  saveGoal(Goal goal) async {
    _openGoalsCache.add(goal);
    //TODO: Handle the case that saving fails
    await FirebaseService().addGoal(goal);
  }

  getGoals() async {
    _goals = await LocalDatabaseService.db.getGoals();
    return _goals;
  }

  Future<List<Goal>> getOpenGoals() async {
    //_openGoals = await DBProvider.db.getOpenGoals();
    if (_openGoalsCache.length == 0) {
      var userId = locator.get<UserService>().getUsername();
      _openGoalsCache = await FirebaseService().getOpenGoals(userId);
    }
    return _openGoalsCache;
  }

  deleteGoal(Goal goal) async {
    await FirebaseService().deleteGoal(goal);
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

  fetchGoalShields() async {
    String data = await rootBundle.loadString("assets/hindrances.json");
    _goalShields = [];
    var decoded = jsonDecode(data);
    for (var s in decoded) {
      _goalShields.add(GoalShield.fromJson(s));
    }
  }

  updateGoal(Goal goal) async {
    await FirebaseService().updateGoal(goal);
  }

  saveAssessment(AssessmentModel assessment) async {
    await FirebaseService().saveAssessment(assessment);
  }
}
