import 'package:flutter/cupertino.dart';

class ImplementationIntentionModel with ChangeNotifier {
  String goal = "";
  List<String> shieldingActions = [];
  String _hindrance = "";

  String get hindrance => _hindrance;

  set hindrance(String hindrance) {
    _hindrance = hindrance;
    notifyListeners();
  }

  DateTime _deadline = DateTime.now();

  DateTime get deadline => _deadline;

  set deadline(DateTime deadline) {
    _deadline = deadline;
    notifyListeners();
  }

  setGoal(String goal) {
    this.goal = goal;
    print("New Goal is: $goal");
    notifyListeners();
  }

  getGoal() {
    return this.goal;
  }

  addShieldingAction(String action) {
    print("Adding Shielding Action $action");
    shieldingActions.add(action);
    notifyListeners();
  }

  removeShieldingAction(String action) {
    print("Removing Shielding Action $action");
    shieldingActions.removeWhere((a) => a == action);
    notifyListeners();
  }
}
