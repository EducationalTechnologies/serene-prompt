import 'package:flutter/material.dart';
import 'package:serene/services/data_service.dart';
import 'package:serene/models/goal.dart';
import 'package:serene/services/user_service.dart';
import 'package:serene/shared/enums.dart';
import 'package:serene/viewmodels/base_view_model.dart';

class AddGoalViewModel extends BaseViewModel {
  bool _isFetching = false;
  Goal _currentGoal;
  DataService _dataService;
  String _mode = GoalScreenMode.create;
  String get mode => _mode;

  AddGoalViewModel({Goal goal, @required DataService dataService}) {
    _dataService = dataService;
    if (goal == null) {
      final userService = UserService();
      var userId = userService.getUsername();
      _currentGoal = new Goal(goalText: "", progress: 0, userId: userId);
      _mode = GoalScreenMode.create;
    } else {
      this._currentGoal = goal;
      _mode = GoalScreenMode.edit;
    }
  }

  Goal get currentGoal {
    if (_currentGoal == null) {
      _currentGoal = new Goal(goalText: "", progress: 0);
    }
    return _currentGoal;
  }

  // set currentGoal(Goal currentGoal) {
  //   _currentGoal = currentGoal;
  //   notifyListeners();
  // }

  clearDeadline() {
    _currentGoal.deadline = null;
    notifyListeners();
  }

  bool get isFetching => _isFetching;

  Future saveCurrentGoal() async {
    setState(ViewState.busy);
    if (this.mode == GoalScreenMode.create) {
      await this._saveNewGoal(this._currentGoal);
    } else {
      await this._dataService.updateGoal(this._currentGoal);
    }
    setState(ViewState.idle);
  }

  Future _saveNewGoal(Goal goal) async {
    await _dataService.saveGoal(goal);
  }

  canSubmit() {
    return _currentGoal.goalText.length > 3;
  }

  Future init() async {}
}