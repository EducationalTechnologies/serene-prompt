import 'package:flutter/material.dart';
import 'package:serene/locator.dart';
import 'package:serene/services/data_service.dart';
import 'package:serene/models/goal.dart';
import 'package:serene/services/user_service.dart';
import 'package:serene/shared/enums.dart';
import 'package:serene/shared/id_generator.dart';
import 'package:serene/shared/materialized_path.dart';
import 'package:serene/viewmodels/base_view_model.dart';

class AddGoalViewModel extends BaseViewModel {
  bool _isFetching = false;
  Goal _currentGoal;
  Goal _selectedParentGoal;
  DataService _dataService;
  List<Goal> _potentialParents = [];

  Goal get selectedParentGoal => _selectedParentGoal;
  set selectedParentGoal(Goal selectedParentGoal) {
    _selectedParentGoal = selectedParentGoal;
    _currentGoal.parentId = selectedParentGoal.id;
    _currentGoal.path =
        MaterializedPath.addToPath(selectedParentGoal.path, _currentGoal.path);
    notifyListeners();
  }

  List<Goal> get potentialParents => _potentialParents;

  String _mode = GoalScreenMode.create;
  String get mode => _mode;

  AddGoalViewModel({Goal goal, @required DataService dataService}) {
    _dataService = dataService;
    if (goal == null) {
      final userService = locator.get<UserService>();
      var userId = userService.getUsername();
      var id = IdGenerator.generatePushId();
      var path = MaterializedPath.toPathString(id);
      _currentGoal = new Goal(userId: userId, id: id, path: path);
      _mode = GoalScreenMode.create;
    } else {
      this._currentGoal = goal;
      _mode = GoalScreenMode.edit;
      if (this._currentGoal.parentId.isNotEmpty) {
        this._selectedParentGoal =
            this._dataService.getGoalById(this._currentGoal.parentId);
      }
    }

    dataService.getOpenGoals().then((og) {
      _potentialParents = og.where((g) => g.id != currentGoal.id).toList();
      // _potentialParents.removeWhere((g) => g.id == _currentGoal.id);
      notifyListeners();
    });
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
      await this._dataService.createGoal(this._currentGoal);
    } else {
      await this._dataService.updateGoal(this._currentGoal);
    }
    setState(ViewState.idle);
  }

  Future deleteCurrentGoal() async {
    setState(ViewState.busy);
    await this._dataService.deleteGoal(this._currentGoal);
    setState(ViewState.idle);
  }

  canSubmit() {
    return _currentGoal.goalText.length > 0;
  }

  bool hasParentsAvailable() {
    return potentialParents.length > 1;
  }

  Future init() async {}
}
