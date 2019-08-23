import 'package:flutter/foundation.dart';
import 'package:implementation_intentions/models/goal.dart';
import 'package:implementation_intentions/services/database_helpers.dart';

class GoalMonitorItemState with ChangeNotifier {
  String get goalText => _goal.goal;
  int get progress => _goal.progress;
  Goal get goal => _goal;

  set progress(int progress) {
    _goal.progress = progress;
    DBProvider.db.updateGoal(_goal);
    notifyListeners();
  }

  set goalText(String goalText) {
    _goal.goal = goalText;
    DBProvider.db.updateGoal(_goal);
    notifyListeners();
  }

  Goal _goal;

  GoalMonitorItemState(this._goal);
}
