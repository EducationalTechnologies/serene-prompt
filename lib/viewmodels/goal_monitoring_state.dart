import 'package:flutter/material.dart';
import 'package:serene/models/goal.dart';
import 'package:serene/services/data_service.dart';

class GoalMonitoringState with ChangeNotifier {
  bool _isFetching = false;
  List<Goal> _goals;
  List<Goal> _openGoals;

  DataService _dataService;
  // DataService _dataService;

  GoalMonitoringState(this._dataService) {
    // _getOpenGoalsAsync();
    _dataService.getOpenGoals().then((goalList) {
      _openGoals = goalList;
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
