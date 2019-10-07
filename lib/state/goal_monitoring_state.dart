import 'package:flutter/material.dart';
import 'package:serene/models/goal.dart';
import 'package:serene/services/data_service.dart';
import 'package:serene/services/database_helpers.dart';

class GoalMonitoringState with ChangeNotifier {
  bool _isFetching = false;
  List<Goal> _goals;
  List<Goal> _openGoals;

  GoalMonitoringState() {
    getOpenGoalsAsync();
  }

  List<Goal> get goals {
    return DataService().goals;
  }

  List<Goal> get openGoals {
    return _openGoals;
  }

  Future<List<Goal>> getGoalsAsync() async {
    _goals = await DataService().getGoals();
    return _goals;
  }

  Future<List<Goal>> getOpenGoalsAsync() async {
    _openGoals = await DataService().getOpenGoals();
    notifyListeners();
  }

  Future<bool> update() async {
    await fetchData();
    return true;
  }

  fetchData() async {
    _isFetching = true;
    await DataService().fetchGoals();
    _isFetching = false;
  }

  deleteGoal(Goal goal) async {
    DataService().deleteGoal(goal);
    await update();
    // notifyListeners();
  }

  updateGoal(Goal goal) async {
    await DBProvider.db.updateGoal(goal);
    // notifyListeners();
  }

  bool get isFetching => _isFetching;
}
