import 'package:flutter/foundation.dart';
import 'package:serene/models/goal.dart';
import 'package:serene/services/database_helpers.dart';

class GoalMonitorItemState with ChangeNotifier {
  String get goalText => _goal.goalText;
  int get progress => _goal.progress;
  Goal get goal => _goal;

  setProgress(int progress) async {
    _goal.progress = progress;
    await DBProvider.db.updateGoal(_goal);
    notifyListeners();
  }

  setGoalText(String goalText) async {
    _goal.goalText = goalText;
    await DBProvider.db.updateGoal(_goal);
    notifyListeners();
  }

  commitChanges() async {
    await DBProvider.db.updateGoal(_goal);
    notifyListeners();
  }

  Goal _goal;

  GoalMonitorItemState(this._goal);
}
