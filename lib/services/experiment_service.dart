import 'package:serene/services/data_service.dart';
import 'package:serene/services/notification_service.dart';
import 'package:serene/shared/enums.dart';
import 'package:serene/shared/extensions.dart';

class ExperimentService {
  static const int INTERNALISATION_RECALL_BREAK = 6;
  static const int MIN_TIME_HOURS = 16;
  static const int NUM_CONDITIONS = 3;
  static const int DASYS_INTERVAL_LDT = 3;
  static const int DASYS_INTERVAL_USABILITY = 3;

  DataService _dataService;
  NotificationService _notificationService;

  ExperimentService(this._dataService, this._notificationService);

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

  bool shouldScheduleRecallTaskToday(DateTime timeOfInternalisation) {
    var date =
        DateTime.now().add(Duration(hours: INTERNALISATION_RECALL_BREAK));
    return date.isToday();
  }

  DateTime getScheduleTimeForRecallTask(DateTime timeOfInternalisation) {
    var date = timeOfInternalisation
        .add(Duration(hours: INTERNALISATION_RECALL_BREAK));

    // If the reminder would be before 4pm, we schedule it to be at least at four
    var diff = MIN_TIME_HOURS - date.hour;

    if (diff > 0) {
      date = DateTime(
          date.year, date.month, date.day, date.hour + diff, date.minute);
    }

    return date;
  }

  void scheduleRecallTaskNotificationIfAppropriate(
      DateTime timeOfInternalisation) {
    if (timeOfInternalisation.isToday()) {
      var date = getScheduleTimeForRecallTask(timeOfInternalisation);
      this._notificationService.scheduleRecallTaskReminder(date);
    }
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

    var lastRecall = await _dataService.getLastRecallTask();

    if (lastRecall != null) {
      if (lastRecall.completionDate.isToday()) {
        return false;
      }
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
      var daysAgo = first.completionDate.daysAgo();
      conditionValue = daysAgo % NUM_CONDITIONS;
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

  Future<List<dynamic>> getLdtTask() async {
    var allTasks = await this._dataService.getLexicalDecisionTaskList();
  }
}
