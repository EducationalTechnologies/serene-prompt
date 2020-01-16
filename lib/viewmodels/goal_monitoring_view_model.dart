import 'package:flutter/material.dart';
import 'package:serene/models/goal.dart';
import 'package:serene/services/data_service.dart';
import 'package:serene/shared/materialized_path.dart';

class GoalMonitoringVielModel with ChangeNotifier {
  bool _isFetching = false;
  List<Goal> _openGoals;

  DataService _dataService;

  GoalMonitoringVielModel(this._dataService) {
    // _getOpenGoalsAsync();
    _dataService.getOpenGoals().then((goalList) {
      _openGoals = goalList;

      // var tree = _pathTreeFromGoals(_openGoals);
      sortByTree();
      notifyListeners();
    });
  }

  void refetchGoals() {
    _dataService.getOpenGoals().then((goalList) {
      _openGoals = goalList;
      sortByTree();
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
    await _dataService.deleteGoal(goal);
  }

  updateGoal(Goal goal) async {
    await _dataService.updateGoal(goal);
    refetchGoals();
  }

  bool get isFetching => _isFetching;
}
