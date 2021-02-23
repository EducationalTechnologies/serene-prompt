import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:serene/models/assessment.dart';
import 'package:serene/models/internalisation.dart';
import 'package:serene/models/ldt_data.dart';
import 'package:serene/models/recall_task.dart';
import 'package:serene/services/data_service.dart';
import 'package:serene/services/logging_service.dart';
import 'package:serene/services/navigation_service.dart';
import 'package:serene/services/notification_service.dart';
import 'package:serene/services/reward_service.dart';
import 'package:serene/shared/enums.dart';
import 'package:serene/shared/extensions.dart';
import 'package:serene/shared/route_names.dart';

class ExperimentService {
  static const int INTERNALISATION_RECALL_BREAK = 6;
  static const TimeOfDay EARLIEST_RECALL = TimeOfDay(hour: 16, minute: 0);
  static const int NUM_CONDITIONS = 3;
  static const int DAYS_INTERVAL_LDT = 3;
  static const int DAYS_INTERVAL_USABILITY = 3;
  static const int STUDY_DURATION = 27;
  static const Duration WAITING_TIMER_DURATION = Duration(seconds: 15);

  final DataService _dataService;
  final NotificationService _notificationService;
  final LoggingService _loggingService;
  final RewardService _rewardService;
  final NavigationService _navigationService;

  ExperimentService(this._dataService, this._notificationService,
      this._loggingService, this._rewardService, this._navigationService);

  Future<bool> initialize() async {
    // TODO: Check the current inernalisation condition here and, if necessary, recalculate it
    return await Future.delayed(Duration.zero).then((res) => true);
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
      for (var w in data["targets"]) ldt.targets.add(w);
      for (var prm in data["primes"]) ldt.primes.add(prm);
    }

    //initialize the trial data now so that less objects have to be created during the trial
    ldt.trials = [];

    for (var word in ldt.targets) {
      var ldtTrialWord = LdtTrial(condition: "", target: word);
      ldt.trials.add(ldtTrialWord);
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
    // TODO: Also check if the LDT was alread done!

    if (await lastThreeConditionsWereTheSame()) {
      DateTime lastLdtDate = await _dataService.getDateOfLastLDT();

      if (lastLdtDate == null) {
        return true;
      }

      var lastInternalisation = await _dataService.getLastInternalisation();

      if (lastLdtDate.isAfter(lastInternalisation.completionDate)) {
        return false;
      }
    }
    return false;
  }

  // TODO: Implement
  Future<bool> isTimeForUsabilityTask() async {
    return await Future.delayed(Duration.zero).then((value) {
      return false;
    });
  }

  Future<InternalisationCondition> getTodaysInternalisationCondition() async {
    var ud = await this._dataService.getUserData();

    return InternalisationCondition.values[ud.internalisationCondition];
  }

  Future<List<dynamic>> getLdtTask() async {
    var allTasks = await this._dataService.getLexicalDecisionTaskListII();
  }

  Future<int> getNextInternalisationCondition(int current) async {
    // var max = await _dataService.
    var next = current;
    if (await lastThreeConditionsWereTheSame()) {
      next = (next + 1) % 3;
    }
    return next;
  }

  Future<void> updateInternalisationConditionGroup() async {
    var userData = await _dataService.getUserData();
    var newCondition = await getNextInternalisationCondition(
        userData.internalisationCondition);
    if (newCondition != userData.internalisationCondition) {
      await _dataService.updateInternalisationConditionGroup(newCondition);
    }
  }

  Future<void> submitInternalisation(Internalisation internalisation) async {
    await this._dataService.saveInternalisation(internalisation);

    _notificationService.deleteScheduledInternalisationReminder();

    this.scheduleRecallTaskNotificationIfAppropriate(DateTime.now());

    this.updateInternalisationConditionGroup();

    _notificationService.scheduleInternalisationReminder(new Time(6, 30, 0));

    _navigationService.navigateTo(RouteNames.NO_TASKS);
  }

  Future<bool> isFinalTask() async {
    var completed = await _dataService.getNumberOfCompletedInternalisations();
    return completed == STUDY_DURATION;
  }

  Future<void> submitRecallTask(RecallTask recallTask) async {
    _dataService.saveRecallTask(recallTask);

    if (await lastThreeConditionsWereTheSame()) {
      this._rewardService.onRecallTaskThird();
      _navigationService.navigateTo(RouteNames.AMBULATORY_ASSESSMENT_USABILITY);
    } else {
      this._rewardService.onRecallTaskRegular();
      _navigationService.navigateTo(RouteNames.NO_TASKS);
    }

    if (await isFinalTask()) {
      this._rewardService.onFinalTask();
    }
  }

  Future<void> submitAssessment(
      AssessmentModel assessment, AssessmentType type) async {
    await this._dataService.saveAssessment(assessment);

    var nextRoute = RouteNames.NO_TASKS;

    if (type == AssessmentType.usability) {
      nextRoute = RouteNames.LDT;
    } else if (type == AssessmentType.preImplementationIntention) {
      nextRoute = RouteNames.INTERNALISATION;
    }

    _navigationService.navigateTo(nextRoute);
  }

  Future<void> submitLDT(LdtData ldtData) async {
    await _dataService.saveLdtData(ldtData);
    _navigationService.navigateTo(RouteNames.NO_TASKS);
    return;
  }
}
