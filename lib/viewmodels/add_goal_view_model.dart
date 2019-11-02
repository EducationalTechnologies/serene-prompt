import 'package:flutter/material.dart';
import 'package:serene/locator.dart';
import 'package:serene/models/tag.dart';
import 'package:serene/services/data_service.dart';
import 'package:serene/models/goal.dart';
import 'package:serene/services/user_service.dart';
import 'package:serene/shared/enums.dart';
import 'package:serene/shared/materialized_path.dart';
import 'package:serene/viewmodels/base_view_model.dart';

class AddGoalViewModel extends BaseViewModel {
  bool _isFetching = false;
  Goal _currentGoal;
  Goal _selectedParentGoal;
  DataService _dataService;
  List<TagModel> _tags = [];
  List<Goal> _potentialParents = [];

  Goal get selectedParentGoal => _selectedParentGoal;
  set selectedParentGoal(Goal selectedParentGoal) {
    _selectedParentGoal = selectedParentGoal;
    _currentGoal.parentId = selectedParentGoal.id;
    _currentGoal.path = MaterializedPath.addToPath(selectedParentGoal.path, _currentGoal.path);
    notifyListeners();
  }

  List<TagModel> get tags => _tags;
  List<Goal> get potentialParents => _potentialParents;

  String _mode = GoalScreenMode.create;
  String get mode => _mode;

  AddGoalViewModel({Goal goal, @required DataService dataService}) {
    _dataService = dataService;
    if (goal == null) {
      final userService = locator.get<UserService>();
      var userId = userService.getUsername();
      _currentGoal = new Goal(goalText: "", progress: 0, userId: userId);
      _mode = GoalScreenMode.create;
    } else {
      this._currentGoal = goal;
      _mode = GoalScreenMode.edit;
    }

    dataService.getTags().then((tags) {
      _tags = tags;
      notifyListeners();
    });

    dataService.getOpenGoals().then((og) {
      _potentialParents = og;
      _potentialParents
          .removeWhere((g) => g.id == _currentGoal.id);
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
      await this._saveNewGoal(this._currentGoal);
    } else {
      await this._dataService.updateGoal(this._currentGoal);
    }
    setState(ViewState.idle);
  }

  Future _saveNewGoal(Goal goal) async {
    await _dataService.createGoal(goal);
  }

  toggleTag(TagModel tag, bool value) {}

  canSubmit() {
    return _currentGoal.goalText.length > 3;
  }

  bool hasParentsAvailable() {
    return potentialParents.length > 1;
  }

  Future init() async {}
}
