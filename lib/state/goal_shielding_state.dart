import 'package:flutter/material.dart';
import 'package:implementation_intentions/models/goal.dart';

class GoalShieldingState with ChangeNotifier {
  int id;
  List<String> hindrances = ["A", "B", "C"];
  List<String> shields = ["A", "B", "C"];
  List<String> selectedShieldingActions = [];
  String _hindrance = "A";
  Goal _selectedGoal;

  Goal get selectedGoal => _selectedGoal;

  set selectedGoal(Goal selectedGoal) {
    _selectedGoal = selectedGoal;
  }
  
  int _selectedGoalIndex;

  int get selectedGoalIndex => _selectedGoalIndex;

  set selectedGoalIndex(int selectedIndex) {
    _selectedGoalIndex = selectedIndex;
    notifyListeners();
  }

  String get hindrance => _hindrance;

  set hindrance(String hindrance) {
    _hindrance = hindrance;
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
