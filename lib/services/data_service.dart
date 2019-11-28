import 'dart:async';
import 'dart:collection';
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
import 'package:serene/shared/materialized_path.dart';

class DataService {
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  List<Goal> _goalsCache;
  List<Goal> _openGoalsCache = [];
  List<TagModel> _tagCache = [];
  List<GoalShield> _goalShields;
  UserService _userService;
  FirebaseService _databaseService;
  StreamController<Goal> goalStream = StreamController<Goal>.broadcast();

  DataService._internal() {
    this._userService = locator.get<UserService>();
    this._databaseService = locator.get<FirebaseService>();
  }

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

  createGoal(Goal goal) async {
    //TODO: Handle the case that saving fails
    if (goal.id.isEmpty) {
      throw new Exception("Goal does not have an ID");
    }

    _openGoalsCache.add(goal);
    goalStream.add(goal);
    await _databaseService.createGoal(goal, _userService.getUserEmail());
    if (goal.parentId.isNotEmpty) {
      var parentPath = getGoalById(goal.parentId).path;
      goal.path = MaterializedPath.addToPath(parentPath, goal.path);
    }
  }

  getGoals() async {
    _goalsCache = await LocalDatabaseService.db.getGoals();
    return _goalsCache;
  }

  Future<List<Goal>> getOpenGoals() async {
    //_openGoals = await DBProvider.db.getOpenGoals();
    if (_openGoalsCache.length == 0) {
      _openGoalsCache =
          await _databaseService.retrieveOpenGoals(_userService.getUserEmail());
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

  Future<List<TagModel>> getTags() async {
    if (_tagCache.length == 0) {
      var userId = _userService.getUserEmail();
      _tagCache = await _databaseService.getTags(userId);
    }
    return _tagCache;
  }

  updateTag(TagModel tag) async {
    await _databaseService.updateTag(tag, _userService.getUserEmail());
    var existingTag =
        _tagCache.firstWhere((t) => tag.id == t.id, orElse: () => null);
    if (existingTag != null) {
      existingTag.name = tag.name;
    } else {
      _tagCache.add(tag);
    }
  }

  saveTag(TagModel tag) async {
    var tagId =
        await _databaseService.createTag(tag, _userService.getUserEmail());
    tag.id = tagId;
    var existingTag =
        _tagCache.firstWhere((t) => tag.id == t.id, orElse: () => null);
    if (existingTag != null) {
      existingTag.name = tag.name;
    } else {
      _tagCache.add(tag);
    }
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

  Future<AssessmentModel> getLastSubmittedAssessment(String assessmentType) async {
    return await _databaseService.getLastSubmittedAssessment(
        assessmentType, _userService.getUserEmail());
  }

  saveShielding(GoalShield shield) async {
    shield.submissionDate = DateTime.now();
    return await _databaseService.saveShielding(shield, _userService.getUserEmail());
  }

  Future<GoalShield> getLastGoalShield() async {
    return await _databaseService.getLastSubmittedGoalShield(_userService.getUserEmail());
  }
}
