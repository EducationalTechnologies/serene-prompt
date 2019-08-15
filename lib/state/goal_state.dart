import 'package:flutter/material.dart';
import 'package:implementation_intentions/models/goal.dart';
import 'package:implementation_intentions/services/data_service.dart';
import 'package:implementation_intentions/services/database_helpers.dart';

class GoalState with ChangeNotifier {
  bool _isFetching = false;
  Goal _currentGoal;

  List<Goal> get goals {
    return DataService().goals;
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
  }

  Future init() async {}
}
