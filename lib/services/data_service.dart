import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:serene/locator.dart';
import 'package:serene/models/assessment.dart';
import 'package:serene/models/goal.dart';
import 'package:serene/models/goal_shield.dart';
import 'package:serene/models/tag.dart';
import 'package:serene/services/firebase_service.dart';
import 'package:serene/services/local_database_service.dart';
import 'package:serene/services/user_service.dart';

class DataService {
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  List<Goal> _goals;
  List<Goal> _openGoalsCache = [];
  List<TagModel> _tagCache = [];
  List<GoalShield> _goalShields;
  UserService _userService;
  FirebaseService _databaseService;

  DataService._internal() {
    this._userService = locator.get<UserService>();
    this._databaseService = locator.get<FirebaseService>();
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
    await _databaseService.addGoal(goal);
  }

  getGoals() async {
    _goals = await LocalDatabaseService.db.getGoals();
    return _goals;
  }

  Future<List<Goal>> getOpenGoals() async {
    //_openGoals = await DBProvider.db.getOpenGoals();
    if (_openGoalsCache.length == 0) {
      var userId = _userService.getUsername();
      _openGoalsCache = await _databaseService.getOpenGoals(userId);
    }
    return _openGoalsCache;
  }

  Future<List<TagModel>> getTags() async {
    if (_tagCache.length == 0) {
      var userId = _userService.getUsername();
      _openGoalsCache = await _databaseService.getTags(userId);
    }
    return _tagCache;
  }

  saveTag(TagModel tag) async {
    var existingTag = _tagCache.firstWhere((t) => tag.id == t.id);
    if (existingTag != null) {
      existingTag.name = tag.name;
    } else {
      _tagCache.add(tag);
    }

    await _databaseService.addTag(tag, _userService.getUsername());
  }

  deleteGoal(Goal goal) async {
    await _databaseService.deleteGoal(goal);
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

  updateGoal(Goal goal) async {
    await _databaseService.updateGoal(goal);
  }

  saveAssessment(AssessmentModel assessment) async {
    await _databaseService.saveAssessment(assessment);
  }
}
