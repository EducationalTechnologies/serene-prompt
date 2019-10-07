import 'package:flutter/material.dart';
import 'package:serene/models/goal.dart';

class GoalShieldingState with ChangeNotifier {
  int id;
  List<String> hindrances = [
    "Überforderung",
    "Ablenkung",
    "Lustlosigkeit",
    "Meine Verfassung"
  ];
  List<String> shields = [
    "Wenn ich mich überfordert fühle, dann sage ich mir, dass ich es schaffen kann",
    "wenn mir der Gedanke kommt, etwas anderes (nebenher) zu machen, bringe ich mich dazu, noch etwas weiterzulernen",
    "Wenn ich gar keine Lust mehr auf das Lernen habe, dann sage ich mir, dass ich es aus gutem Grund tue.",
    "Wenn ich mich krank und müde fühle, höre ich auf mich krank und müde zu fühlen!"
  ];
  String _selectedShieldingAction;

  String get selectedShieldingAction => _selectedShieldingAction;

  set selectedShieldingAction(String selectedShieldingAction) {
    _selectedShieldingAction = selectedShieldingAction;
    notifyListeners();
  }

  String _hindrance;
  Goal _selectedGoal;
  String _shieldingSentence = "";

  String get shieldingSentence => _shieldingSentence;

  set shieldingSentence(String shieldingSentence) {
    _shieldingSentence = shieldingSentence;
    notifyListeners();
  }

  GoalShieldingState() {
    this._hindrance = hindrances[0];
    this._shieldingSentence = shields[0];
  }

  Goal get selectedGoal => _selectedGoal;

  set selectedGoal(Goal selectedGoal) {
    _selectedGoal = selectedGoal;
    notifyListeners();
  }

  selectHindrance(String hindrance) {
    this.hindrance = hindrance;
    var hindex = this.hindrances.indexOf(hindrance);
    this.shieldingSentence = shields[hindex];
  }

  String get hindrance => _hindrance;

  set hindrance(String hindrance) {
    _hindrance = hindrance;
    notifyListeners();
  }
}
