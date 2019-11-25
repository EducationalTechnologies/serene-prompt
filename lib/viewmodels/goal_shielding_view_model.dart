import 'package:flutter/material.dart';
import 'package:serene/models/goal.dart';
import 'package:serene/models/goal_shield.dart';
import 'package:serene/services/data_service.dart';

class GoalShieldingViewModel with ChangeNotifier {
  int id;
  List<String> hindrances = [
    "Überforderung",
    "Ablenkung",
    "Lustlosigkeit",
    "Körperliche Verfassung"
  ];
  List<String> shields = [
    "Wenn ich mich überfordert fühle, dann sage ich mir, dass ich es schaffen kann",
    "Wenn mir der Gedanke kommt, etwas anderes (nebenher) zu machen, bringe ich mich dazu, noch etwas weiterzulernen",
    "Wenn ich gar keine Lust mehr auf das Lernen habe, dann sage ich mir, dass ich es aus gutem Grund tue.",
    "Wenn ich mich krank und müde fühle, höre ich auf mich krank und müde zu fühlen!"
  ];
  String _selectedShieldingAction;
  String _hindrance;
  List<Goal> _selectedGoals = [];
  DataService _dataService;
  List<Goal> _openGoals;
  List<Goal> get openGoals {
    return _openGoals;
  }

  String get selectedShieldingAction => _selectedShieldingAction;

  set selectedShieldingAction(String selectedShieldingAction) {
    _selectedShieldingAction = selectedShieldingAction;
    notifyListeners();
  }

  GoalShieldingViewModel(this._dataService) {
    this._hindrance = hindrances[0];
    this._selectedShieldingAction = shields[0];

    _dataService.getOpenGoals().then((goalList) {
      _openGoals = goalList;
      notifyListeners();
    });
  }

  List<Goal> get selectedGoals => _selectedGoals;

  toggleGoal(Goal selectedGoal) {
    if (_selectedGoals.contains(selectedGoal)) {
      _selectedGoals.remove(selectedGoal);
    } else {
      _selectedGoals.add(selectedGoal);
    }
    notifyListeners();
  }

  selectHindrance(String hindrance) {
    this.hindrance = hindrance;
    var hindex = this.hindrances.indexOf(hindrance);
    this.selectedShieldingAction = shields[hindex];
  }

  String get hindrance => _hindrance;

  set hindrance(String hindrance) {
    _hindrance = hindrance;
    notifyListeners();
  }

  canMoveNext() {
    return _selectedGoals.length > 0;
  }

  saveShielding() async {
    var shield = GoalShield(
        id: DateTime.now().toIso8601String(),
        hindrance: this.hindrance,
        shields: []);
    await this._dataService.saveShielding(shield);
  }
}
