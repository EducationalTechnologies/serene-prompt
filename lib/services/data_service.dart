import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:serene/models/goal.dart';
import 'package:serene/models/goal_shield.dart';
import 'package:serene/services/database_helpers.dart';

class DataService {
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  List<Goal> _goals;
  List<GoalShield> _goalShields;

  get goals {
    return _goals;
  }

  getGoals() async {
    if (_goals == null) _goals = await DBProvider.db.getGoals();

    return _goals;
  }

  fetchOpenGoals() async {
    
  }

  deleteGoal(Goal goal) async {
    await DBProvider.db.deleteGoal(goal);
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

  fetchGoals() async {
    _goals = await DBProvider.db.getGoals();
  }

  fetchGoalShields() async {
    String data = await rootBundle.loadString("assets/hindrances.json");
    _goalShields = [];
    var decoded = jsonDecode(data);
    for (var s in decoded) {
      _goalShields.add(GoalShield.fromJson(s));
    }
  }

  // TODO: This is currently a very temporary solution
  fetchData() async {
    fetchGoals();
    fetchGoalShields();
    return _goalShields;
  }

  DataService._internal() {
    fetchData();
    // getGoals();
    // getGoalShields();
  }
}
