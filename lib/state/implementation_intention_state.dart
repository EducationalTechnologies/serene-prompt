import 'package:implementation_intentions/state/goal_state.dart';

class ImplementationIntentionState extends GoalState {
  int id;
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
