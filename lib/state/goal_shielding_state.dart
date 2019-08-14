import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:implementation_intentions/models/goal.dart';
import 'package:implementation_intentions/services/database_helpers.dart';

class GoalShieldingState with ChangeNotifier {
  int id;
  List<String> hindrances = [];
  List<String> shields = ["A", "B", "C"];
  List<String> selectedShieldingActions = [];
  String _hindrance = "";
  // TODO: Put Goals in a service
  List<Goal> goals = List();

  readHindranceJson() async {
    // String data = await rootBundle.loadString("assets/hindrances.json");
    // var jsonResult = jsonDecode(data);
    // print(jsonResult);
  }

  fetchData() async {
    print("FETCHING GOALS IN GOAL SHIELDING STATE");
    goals = await DBProvider.db.getGoals();
    readHindranceJson();
    notifyListeners();
    return goals;
  }

  String get hindrance => _hindrance;

  set hindrance(String hindrance) {
    _hindrance = hindrance;
    notifyListeners();
  }

  DateTime _deadline = DateTime.now();

  DateTime get deadline => _deadline;

  set deadline(DateTime deadline) {
    _deadline = deadline;
    notifyListeners();
  }

  addShieldingAction(String action) {
    print("Adding Shielding Action $action");
    selectedShieldingActions.add(action);
    notifyListeners();
  }

  removeShieldingAction(String action) {
    print("Removing Shielding Action $action");
    selectedShieldingActions.removeWhere((a) => a == action);
    notifyListeners();
  }
}
