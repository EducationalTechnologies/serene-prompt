import 'dart:math';
import 'package:flutter/material.dart';
import 'package:serene/models/internalisation.dart';
import 'package:serene/models/ldt_data.dart';
import 'package:serene/services/data_service.dart';
import 'package:serene/services/logging_service.dart';
import 'package:serene/services/notification_service.dart';
import 'package:serene/services/reward_service.dart';
import 'package:serene/shared/enums.dart';
import 'package:serene/shared/extensions.dart';

class ExperimentService {
  static const int INTERNALISATION_RECALL_BREAK = 6;
  static const TimeOfDay EARLIEST_RECALL = TimeOfDay(hour: 16, minute: 0);
  static const int NUM_CONDITIONS = 3;
  static const int DAYS_INTERVAL_LDT = 3;
  static const int DAYS_INTERVAL_USABILITY = 3;
  static const Duration WAITING_TIMER_DURATION = Duration(seconds: 15);

  DataService _dataService;
  NotificationService _notificationService;
  LoggingService _loggingService;
  RewardService _rewardService;

  ExperimentService(this._dataService, this._notificationService,
      this._loggingService, this._rewardService);

  Future<bool> initialize() async {
    // TODO: Check the current inernalisation condition here and, if necessary, recalculate it
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
    // We add the "break time" on top of the internalisation time
    var date = timeOfInternalisation
        .add(Duration(hours: INTERNALISATION_RECALL_BREAK));

    // Only schedule a notification if the resulting time would be today
    return date.isToday();
  }

  DateTime getScheduleTimeForRecallTask(DateTime timeOfInternalisation) {
    // We check if the scheduled time would be before 4pm, as this is the earliest
    // time where we want to schedule a notification
    var targetTime = timeOfInternalisation.hour + INTERNALISATION_RECALL_BREAK;
    var diff = EARLIEST_RECALL.hour - targetTime;
    var offset = max(0, diff);

    return timeOfInternalisation
        .add(Duration(hours: INTERNALISATION_RECALL_BREAK + offset));
  }

  void scheduleRecallTaskNotificationIfAppropriate(
      DateTime timeOfInternalisation) {
    if (shouldScheduleRecallTaskToday(timeOfInternalisation)) {
      var date = getScheduleTimeForRecallTask(timeOfInternalisation);
      this._notificationService.scheduleRecallTaskReminder(date);
    }
  }

  List<int> getTrialIndices(DateTime dateOfFirstInternalization) {
    var daysSinceFirstDate =
        DateTime.now().weekDaysAgo(dateOfFirstInternalization);

    List<int> indices = [];

    // Division WITH remainder to get the start offset
    var startIndex = daysSinceFirstDate ~/ DAYS_INTERVAL_LDT;
    for (var i = 0; i < DAYS_INTERVAL_LDT; i++) {
      indices.add(startIndex + i);
    }
    return indices;
  }

  Future<LdtData> getLdtData() async {
    var ldtListAll = await this._dataService.getLexicalDecisionTaskListII();
    var ldtList = [];
    var first = await this._dataService.getFirstInternalisation();

    var trialIndices = getTrialIndices(first.completionDate);
    for (var index in trialIndices) {
      // If the index is higher than there are elements in the LDT list, we start
      // again at the front of the list.
      if (index > ldtListAll.length - 1) {
        index = (ldtListAll.length - 1) % index;
      }
      ldtList.add(ldtListAll[index]);
    }

    var ldt = LdtData();
    for (var data in ldtList) {
      for (var w in data["words"]) ldt.words.add(w);
      for (var nw in data["nonwords"]) ldt.nonWords.add(nw);
      for (var prm in data["primes"]) ldt.primes.add(prm);
    }

    //initialize the trial data now so that less objects have to be created during the trial
    ldt.trials = [];

    for (var word in ldt.words) {
      var ldtTrialWord = LdtTrial(condition: "word", target: word);
      ldt.trials.add(ldtTrialWord);
    }

    for (var nonword in ldt.nonWords) {
      var ldtTrialNonWord = LdtTrial(condition: "nonword", target: nonword);
      ldt.trials.add(ldtTrialNonWord);
    }

    return ldt;
  }

  Future<bool> isTimeForInternalisationTask() async {
    _loggingService.logEvent("Trying to retrieve the last internalisation");
    var lastInternalisation = await _dataService.getLastInternalisation();
    // If there is no previous internalisation, we definitely need the first one
    if (lastInternalisation == null) {
      _loggingService.logEvent("Last Internalisation was NULL");
      return true;
    }

    _loggingService.logEvent("Checking if last internalisation was today");
    if (lastInternalisation.completionDate.isToday()) {
      return false;
    }

    _loggingService.logEvent("Should return true");
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

  Future<bool> lastThreeConditionsWereTheSame() async {
    var lastThree = await _dataService.getLastInternalisations(3);
    if (lastThree.length < 3) return false;
    return lastThree
        .every((element) => element.condition == lastThree[0].condition);
  }

  Future<bool> isTimeForLexicalDecisionTask() async {
    return await lastThreeConditionsWereTheSame();
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

  Future<List<dynamic>> getLdtTask() async {
    var allTasks = await this._dataService.getLexicalDecisionTaskListII();
  }

  Future<int> getNextInternalisationCondition(int current) async {
    // var max = await _dataService.
    return await lastThreeConditionsWereTheSame() ? current + 1 : current;
  }

  Future<void> updateInternalisationConditionGroup() async {
    // TODO
  }

  // Future<void> saveNewI

  Future<void> submitInternalisation(Internalisation internalisation) async {
    this._dataService.saveInternalisation(internalisation);

    this._rewardService.addPoints(1);

    this.scheduleRecallTaskNotificationIfAppropriate(DateTime.now());

    this.updateInternalisationConditionGroup();

    return;
  }
}
