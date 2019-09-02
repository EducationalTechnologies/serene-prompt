import 'package:flutter/material.dart';
import 'package:implementation_intentions/models/goal.dart';
import 'package:implementation_intentions/services/data_service.dart';
import 'package:implementation_intentions/services/database_helpers.dart';

class GoalMonitoringState with ChangeNotifier {
  bool _isFetching = false;
  Goal _currentGoal;
  List<Goal> _goals;

  List<Goal> get goals {
    return _goals;
  }

  Future<List<Goal>> getGoalsAsync() async {
    _goals = await DataService().getGoals();
    // _goals = [
    //   Goal(deadline: DateTime.now(), goal: "Goal", id: 2, progress: 20)
    // ];
    // notifyListeners();
    return _goals;
  }

  fetchData() async {
    _isFetching = true;
    await DataService().fetchGoals();
    _isFetching = false;
    notifyListeners();
  }

  deleteGoal(Goal goal) async {
    DataService().deleteGoal(goal);
    this._goals.removeWhere((g) => g.id == goal.id);
    notifyListeners();
  }

  Goal get currentGoal {
    if (_currentGoal == null) {
      _currentGoal =
          new Goal(id: 0, goal: "", deadline: DateTime.now(), progress: 0);
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
