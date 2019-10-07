import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:serene/models/goal.dart';
import 'package:serene/models/goal_shield.dart';
import 'package:serene/services/database_helpers.dart';
import 'package:serene/services/firebase_service.dart';

class DataService {
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  List<Goal> _goals;
  List<Goal> _openGoals;
  List<GoalShield> _goalShields;

  get goals {
    return _goals;
  }

  get openGoals {
    return _openGoals;
  }

  saveGoal(Goal goal) async {
    await FirebaseService().addGoal(goal);
  }

  getGoals() async {
    _goals = await DBProvider.db.getGoals();

    return _goals;
  }

  getOpenGoals() async {
    _openGoals = await DBProvider.db.getOpenGoals();

    return _openGoals;
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

  fetchOpenGoals() async {
    _openGoals = await DBProvider.db.getOpenGoals();
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
    getOpenGoals();
    return _goalShields;
  }

  DataService._internal() {
    fetchData();
  }
}
