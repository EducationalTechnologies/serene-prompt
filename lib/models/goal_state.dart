import 'package:flutter/material.dart';
import 'package:implementation_intentions/services/database_helpers.dart';

import 'goal.dart';

class GoalState with ChangeNotifier {
  List<Goal> _goals = List();

  _fetchGoals() {
    var goals = DBProvider.db.getGoals();
  }

  getGoals() {
    return _goals;
  }
}