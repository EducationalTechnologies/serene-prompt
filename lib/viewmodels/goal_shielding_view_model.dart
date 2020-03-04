import 'package:flutter/material.dart';
import 'package:serene/models/goal.dart';
import 'package:serene/models/goal_shield.dart';
import 'package:serene/services/data_service.dart';
import 'package:serene/services/user_service.dart';

class GoalShieldingViewModel with ChangeNotifier {
  int id;
  List<String> hindrances = [
    "Überforderung",
    "Ablenkung",
    "Lustlosigkeit",
    "Körperliche Verfassung"
  ];
  List<String> shieldsPersonalized = [
    "Wenn ich mich überfordert fühle, dann sage ich mir, dass ich es schaffen kann.",
    "Wenn ich merke, dass ich abgelenkt bin, dann konzentriere ich mich wieder auf meine Aufgabe.",
    "Wenn ich gar keine Lust mehr auf das Lernen habe, dann sage ich mir, dass ich es aus gutem Grund tue.",
    "Wenn ich mich nicht in der Verfassung zum Lernen fühle, dann bringe ich mich dazu, es zumindest zu probieren."
  ];

  String shieldGeneric =
      "Wenn mir der Gedanke kommt, für heute mit dem Lernen aufzuhören, dann sage ich mir, dass ich heute so lange lernen werde, bis ich meine Tagesziele erreicht habe!";
  
  String _selectedShieldingAction;
  String _hindrance;
  List<Goal> _selectedGoals = [];
  DataService _dataService;
  UserService _userService;
  List<Goal> _openGoals;
  List<Goal> get openGoals {
    return _openGoals;
  }

  String get shieldingSentence => _selectedShieldingAction;

  set shieldingSentence(String selectedShieldingAction) {
    _selectedShieldingAction = selectedShieldingAction;
    notifyListeners();
  }

  GoalShieldingViewModel(this._dataService, this._userService) {
    this._hindrance = "";
    // this._selectedShieldingAction = shieldsPersonalized[0];

    _dataService.getOpenGoals().then((goalList) {
      _openGoals = goalList;
      notifyListeners();
    });
  }

  void refetchGoals() {
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
    var hindranceIndex = this.hindrances.indexOf(hindrance);
    this.shieldingSentence = shieldsPersonalized[hindranceIndex];
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
        shields: [_selectedShieldingAction],
        goalsToShield: _selectedGoals.map((g) => g.goalText).toList());
    await this._dataService.saveShielding(shield);
  }

}
