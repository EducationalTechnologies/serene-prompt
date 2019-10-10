import 'package:flutter/material.dart';
import 'package:serene/services/data_service.dart';
import 'package:serene/models/goal.dart';
import 'package:serene/services/database_helpers.dart';
import 'package:serene/services/user_service.dart';

class GoalState with ChangeNotifier {
  bool _isFetching = false;
  Goal _currentGoal;

  GoalState() {
    final userService = UserService();
    // userService.getUsername();
    _currentGoal =
        new Goal(goalText: "", progress: 0, userId: userService.getUsername());
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

  clearDeadline() {
    _currentGoal.deadline = null;
    notifyListeners();
  }

  bool get isFetching => _isFetching;

  Future saveCurrentGoal() async {
    await this._saveNewGoal(this._currentGoal);
    notifyListeners();
  }

  Future _saveNewGoal(Goal goal) async {
    await DataService().saveGoal(goal);
  }

  Future init() async {}
}
