import 'package:serene/viewmodels/base_view_model.dart';

class DailyLearningQuestionViewModel extends BaseViewModel {
  List<String> reasons = [
    "Keine Motivation",
    "Keine offenen Aufgaben",
    "Keine Zeit",
    "Sonstiges"
  ];

  bool _willLearnToday = true;

  bool get willLearnToday => _willLearnToday;

  set willLearnToday(bool willLearnToday) {
    _willLearnToday = willLearnToday;
    notifyListeners();
  }

  String selectedReason;
}
