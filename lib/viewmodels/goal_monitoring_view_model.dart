import 'dart:async';

import 'package:flutter/material.dart';
import 'package:serene/models/goal.dart';
import 'package:serene/services/data_service.dart';
import 'package:serene/shared/materialized_path.dart';

class GoalMonitoringVielModel with ChangeNotifier {
  bool _isFetching = false;
  List<Goal> _openGoals = [];

  DataService _dataService;

  Function(Goal) goalAdded;
  Function(Goal) goalRemoved;

  StreamController<Goal> goalStreamController = StreamController<Goal>();
  Stream<Goal> goalStream;

  GoalMonitoringVielModel(this._dataService) {
    _dataService.getOpenGoals().then((goalList) {
      _openGoals = goalList;
      notifyListeners();
    });
  }

  void refetchGoals() {
    _dataService.getOpenGoals().then((goalList) {
      // _openGoals = goalList;
      // sortByTree();
      for (var g in goalList) {
        if (!_openGoals.contains(g)) {
          // goalStreamController.add(g);
          this.goalAdded(g);
          _openGoals.add(g);
        }
      }
      notifyListeners();
    });
  }

  void sortByTree() {
    var ids = _openGoals.map((f) => f.path).toList();
    var tree = MaterializedPath.pathTreeFromPathList(ids);
    var dfList = MaterializedPath.depthFirstFromTree(tree);
    List<Goal> list = [];
    for (var id in dfList) {
      var indexOf = _openGoals.indexWhere((g) => g.id == id);
      if (indexOf >= 0) {
        list.add(_openGoals[indexOf]);
      }
    }
    _openGoals = list;
  }

  List<Goal> get goals {
    return _dataService.goals;
  }

  List<Goal> get openGoals {
    return _openGoals;
  }

  deleteGoal(Goal goal) async {
    _openGoals.remove(goal);
    await _dataService.deleteGoal(goal);
  }

  completeGoal(Goal goal) async {
    await _dataService.updateGoal(goal);
    this.goalRemoved(goal);
  }

  updateGoal(Goal goal) async {
    await _dataService.updateGoal(goal);
    refetchGoals();
  }

  bool get isFetching => _isFetching;
}
