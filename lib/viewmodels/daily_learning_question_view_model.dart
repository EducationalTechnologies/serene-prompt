import 'package:serene/services/navigation_service.dart';
import 'package:serene/shared/enums.dart';
import 'package:serene/viewmodels/base_view_model.dart';

class DailyLearningQuestionViewModel extends BaseViewModel {
  final NavigationService _navigationService;

  DailyLearningQuestionViewModel(this._navigationService);

  DailyLearningIntention dailyLearningChoice;

  String _notLearningReason = "";

  String get notLearningReason => _notLearningReason;

  set notLearningReason(String notLearningReason) {
    _notLearningReason = notLearningReason;
    notifyListeners();
  }

  // set willLearnToday(bool willLearnToday) {
  //   _willLearnToday = willLearnToday;
  //   notifyListeners();
  // }

  void onLearningTodaySelected(DailyLearningIntention learningChoice) {
    dailyLearningChoice = learningChoice;
    switch (learningChoice) {
      case DailyLearningIntention.yes:
        // TODO: Handle this case.
        break;
      case DailyLearningIntention.no:
        // TODO: Handle this case.
        break;
      case DailyLearningIntention.alreadyDid:
        // TODO: Handle this case.
        break;
      case DailyLearningIntention.unsure:
        // TODO: Handle this case.
        break;
    }
  }
}
