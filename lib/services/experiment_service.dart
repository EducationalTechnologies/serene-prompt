import 'dart:math';

import 'package:flutter/material.dart';
import 'package:serene/models/ldt_data.dart';
import 'package:serene/services/data_service.dart';
import 'package:serene/services/notification_service.dart';
import 'package:serene/shared/enums.dart';
import 'package:serene/shared/extensions.dart';

class ExperimentService {
  static const int INTERNALISATION_RECALL_BREAK = 6;
  static const TimeOfDay EARLIEST_RECALL = TimeOfDay(hour: 16, minute: 0);
  static const int NUM_CONDITIONS = 3;
  static const int DAYS_INTERVAL_LDT = 3;
  static const int DAYS_INTERVAL_USABILITY = 3;

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
    var allTasks = await this._dataService.getLexicalDecisionTaskListII();
  }
}
