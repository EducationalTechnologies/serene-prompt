import 'package:flutter/material.dart';
import 'package:serene/models/goal.dart';
import 'package:serene/services/data_service.dart';
import 'package:serene/shared/materialized_path.dart';

class GoalMonitoringVielModel with ChangeNotifier {
  bool _isFetching = false;
  List<Goal> _goals;
  List<Goal> _openGoals;

  DataService _dataService;
  // DataService _dataService;

  GoalMonitoringVielModel(this._dataService) {
    // _getOpenGoalsAsync();
    _dataService.getOpenGoals().then((goalList) {
      _openGoals = goalList;

      // var tree = _pathTreeFromGoals(_openGoals);
      notifyListeners();
    });
  }

  List<Goal> get goals {
    return _dataService.goals;
  }

  List<Goal> get openGoals {
    return _openGoals;
  }

  Future<List<Goal>> getGoalsAsync() async {
    _goals = await DataService().getGoals();
    return _goals;
  }

  deleteGoal(Goal goal) async {
    _dataService.deleteGoal(goal);
  }

  updateGoal(Goal goal) async {
    _dataService.updateGoal(goal);
  }

  bool get isFetching => _isFetching;
}
