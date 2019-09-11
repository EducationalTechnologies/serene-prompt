import 'package:flutter/material.dart';
import 'package:implementation_intentions/models/goal.dart';
import 'package:implementation_intentions/services/database_helpers.dart';

class GoalState with ChangeNotifier {
  bool _isFetching = false;
  Goal _currentGoal;

  GoalState() {
    _currentGoal = new Goal(goalText: "", progress: 0);
  }

  GoalState.fromGoal(Goal goal) {
    this._currentGoal = goal;
  }

  Goal get currentGoal {
    if (_currentGoal == null) {
      _currentGoal = new Goal(goalText: "", progress: 0);
    }
    return _currentGoal;
  }

  set currentGoal(Goal currentGoal) {
    _currentGoal = currentGoal;
    notifyListeners();
  }

  bool get isFetching => _isFetching;

  Future saveCurrentGoal() async {
    var goal = this._currentGoal;
    await this.saveNewGoal(goal);
    notifyListeners();
  }

  Future saveNewGoal(Goal goal) async {
    await DBProvider.db.insertGoal(goal);
    notifyListeners();
  }

  Future init() async {}
}
