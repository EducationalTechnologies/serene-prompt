import 'package:serene/services/data_service.dart';
import 'package:serene/shared/enums.dart';
import 'package:serene/shared/extensions.dart';

class ExperimentService {
  static const int INTERNALISATION_RECALL_BREAK = 6;
  static const int NUM_CONDITIONS = 3;

  DataService _dataService;

  ExperimentService(this._dataService);

  Future<bool> initialize() async {
    return await Future.delayed(Duration.zero).then((res) => true);
  }

  Future<bool> shouldShowPreLearningAssessment() async {
    var lastPreLearningAssessment = await this
        ._dataService
        .getLastSubmittedAssessment(AssessmentType.preLearning);

    if (lastPreLearningAssessment == null) return true;
    return !lastPreLearningAssessment.submissionDate.isToday();
  }

  Future<bool> shouldShowPostLearningAssessment() async {
    var lastPostLearningAssessment = await this
        ._dataService
        .getLastSubmittedAssessment(AssessmentType.postLearning);

    if (lastPostLearningAssessment == null) return true;
    var diff =
        DateTime.now().difference(lastPostLearningAssessment.submissionDate);

    return diff.inHours > 24;
  }

  Future<bool> shouldShowSRLSurvey() {
    return Future.delayed(Duration.zero).then((res) => true);
  }

  Future<bool> shouldShowDailyQuestion() {
    return Future.delayed(Duration.zero).then((res) => true);
  }

  Future<bool> isTimeForInternalisationTask() async {
    var lastInternalisation = await _dataService.getLastInternalisation();
    // If there is no previous internalisation, we definitely need the first one
    if (lastInternalisation == null) {
      return true;
    }

    if (lastInternalisation.completionDate.isToday()) {
      return false;
    }

    var now = DateTime.now();
    if (now.hour >= 18) {
      return false;
    }
    return true;
  }

  Future<bool> isTimeForRecallTask() async {
    var lastInternalisation = await _dataService.getLastInternalisation();

    if (lastInternalisation == null) {
      return false;
    }

    var now = DateTime.now();
    var hourDiff = now.hour - lastInternalisation.completionDate.hour;
    if (hourDiff >= ExperimentService.INTERNALISATION_RECALL_BREAK) {
      return true;
    }
    return false;
  }

  Future<bool> isTimeForLexicalDecisionTask() async {
    return await Future.delayed(Duration.zero).then((value) {
      return false;
    });
  }

  // TODO: Implement
  Future<bool> isTimeForUsabilityTask() async {
    return await Future.delayed(Duration.zero).then((value) {
      return false;
    });
  }

  Future<InternalisationCondition> getTodaysInternalisationCondition() async {
    var first = await this._dataService.getFirstInternalisation();
    var conditionValue = 0;
    if (first != null) {
      // Creating a "comparison date" from the first internalisation date
      // to ensure that the day difference is always at least one day if the weekday changes
      // for example, if the first has been on monday, at 12 and it is tuesday, at 11, the day difference would be 0
      // to avoid more complex stuff, this comparison simply assumes the first completion at shortly after midnight
      // so all day differences should be at least one day after
      var compareDate = DateTime(first.completionDate.year,
          first.completionDate.month, first.completionDate.day, 0, 0, 1);
      var now = DateTime.now();
      var daysSince = now.difference(compareDate).inDays;

      conditionValue = daysSince % NUM_CONDITIONS;
    }

    return InternalisationCondition.values[conditionValue];
  }

  Future<AppStartupMode> getCurrentStartRoute() async {
    if (await isTimeForInternalisationTask()) {
      return AppStartupMode.internalisationTask;
    }
    if (await isTimeForRecallTask()) {
      return AppStartupMode.recallTask;
    }

    if (await isTimeForLexicalDecisionTask()) {
      return AppStartupMode.lexicalDecisionTask;
    }

    if (await isTimeForUsabilityTask()) {}

    return AppStartupMode.noTasks;
  }
}
