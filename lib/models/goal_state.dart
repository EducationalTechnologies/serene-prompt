import 'package:flutter/material.dart';
import 'package:implementation_intentions/services/database_helpers.dart';

import 'goal.dart';

class GoalState with ChangeNotifier {
  List<Goal> _goals = List();
  bool _isFetching = false;
  Goal _currentGoal;

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
  }

  Future init() async {
    this.fetchGoals();
  }

  fetchGoals() async {
    print("FETCHING GOALS");
    var goals = await DBProvider.db.getGoals();
    this._goals = goals;
    notifyListeners();
  }

  getGoals() {
    return _goals;
  }
}
