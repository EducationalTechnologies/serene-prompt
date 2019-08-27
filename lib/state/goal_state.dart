import 'package:flutter/material.dart';
import 'package:implementation_intentions/models/goal.dart';
import 'package:implementation_intentions/services/data_service.dart';
import 'package:implementation_intentions/services/database_helpers.dart';

class GoalState with ChangeNotifier {
  bool _isFetching = false;
  Goal _currentGoal;
  List<Goal> _goals;

  GoalState() {
    _currentGoal = new Goal(goal: "", deadline: DateTime.now(), progress: 0);
  }

  GoalState.fromGoal(Goal goal) {
    this._currentGoal = goal;
  }

  List<Goal> get goals {
    return _goals;
  }

  Future<List<Goal>> getGoalsAsync() async {
    if (_goals == null) {
      _goals = await DataService().getGoals();
    }
    return _goals;
  }

  Goal get currentGoal {
    // TODO: Do not always use a deadline
    if (_currentGoal == null) {
      _currentGoal = new Goal(goal: "", deadline: DateTime.now(), progress: 0);
    }
    return _currentGoal;
  }

  set currentGoal(Goal currentGoal) {
    _currentGoal = currentGoal;
    notifyListeners();
  }

  bool get isFetching => _isFetching;

  Future saveCurrentGoal() async {
    await DBProvider.db.insertGoal(this._currentGoal);
    notifyListeners();
  }

  Future saveNewGoal(Goal goal) async {
    await DBProvider.db.insertGoal(goal);
    notifyListeners();
  }

  Future init() async {}
}
