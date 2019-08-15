import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:implementation_intentions/models/goal.dart';
import 'package:implementation_intentions/models/goal_shield.dart';
import 'package:implementation_intentions/services/database_helpers.dart';

class DataService {
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  bool _isDirty;
  List<Goal> _goals;
  List<GoalShield> _goalShields;

  get goals {
    // if (_goals == null || _isDirty) {
    //   _goals = await DBProvider.db.getGoals();
    // }
    return _goals;
  }

  getGoalShields() async {
    if (_goalShields == null || _isDirty) {
      String data = await rootBundle.loadString("assets/hindrances.json");
      _goalShields = [];
      var decoded = jsonDecode(data);
      for (var s in decoded) {
        _goalShields.add(GoalShield.fromJson(s));
      }
    }
    return _goalShields;
  }

  // TODO: This is currently a very temporary solution
  fetchData() async {
    _goals = await DBProvider.db.getGoals();

    String data = await rootBundle.loadString("assets/hindrances.json");
    _goalShields = [];
    var decoded = jsonDecode(data);
    for (var s in decoded) {
      _goalShields.add(GoalShield.fromJson(s));
    }
    return _goalShields;
  }

  DataService._internal() {
    fetchData();
    // getGoals();
    // getGoalShields();
  }
}
