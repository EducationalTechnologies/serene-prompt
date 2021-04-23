import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:prompt/models/assessment_result.dart';
import 'package:prompt/models/internalisation.dart';
import 'package:prompt/models/ldt_data.dart';
import 'package:prompt/models/recall_task.dart';
import 'package:prompt/services/data_service.dart';
import 'package:prompt/services/logging_service.dart';
import 'package:prompt/services/navigation_service.dart';
import 'package:prompt/services/notification_service.dart';
import 'package:prompt/services/reward_service.dart';
import 'package:prompt/shared/enums.dart';
import 'package:prompt/shared/experiment_constants.dart';
import 'package:prompt/shared/extensions.dart';
import 'package:prompt/shared/route_names.dart';

class ExperimentService {
  static const int INTERNALISATION_RECALL_BREAK = 6;
  static const TimeOfDay EARLIEST_RECALL = TimeOfDay(hour: 16, minute: 0);
  static const int NUM_CONDITIONS = 3;
  static const int DAYS_INTERVAL_LDT = 3;
  static const int DAYS_INTERVAL_USABILITY = 3;
  static const int STUDY_DURATION = 27;
  static const Duration WAITING_TIMER_DURATION = Duration(seconds: 15);
  static const int NUM_GROUPS = 6;
  // ignore: non_constant_identifier_names
  static final DateTime FINAL_DATE = DateTime(2021, 6, 21);

  final DataService _dataService;
  final NotificationService _notificationService;
  final LoggingService _loggingService;
  final RewardService _rewardService;
  final NavigationService _navigationService;

  ExperimentService(this._dataService, this._notificationService,
      this._loggingService, this._rewardService, this._navigationService);

  Future<bool> initialize() async {
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
    return timeOfInternalisation
        .add(Duration(hours: INTERNALISATION_RECALL_BREAK));
  }

  void scheduleRecallTaskNotificationIfAppropriate(
      DateTime timeOfInternalisation) {
    if (shouldScheduleRecallTaskToday(timeOfInternalisation)) {
      var date = getScheduleTimeForRecallTask(timeOfInternalisation);
      this._notificationService.scheduleRecallTaskReminder(date);
    }
  }

  isTimeForFinalTask() async {
    bool timeForFinalTask = false;

    var isAfterFinalDay = DateTime.now().isAfter(FINAL_DATE);

    if (isAfterFinalDay) {
      timeForFinalTask = true;
    } else {
      var allInternalisationsCompleted =
          await getNumberOfCompletedInternalisations() >= STUDY_DURATION;
      // If all internalisations are complete, we still have to check if the LDT was performed after this
      if (allInternalisationsCompleted) {
        var lastLdtDate = await _dataService.getDateOfLastLDT();
        var lastInternalisationDate =
            (await _dataService.getLastInternalisation()).completionDate;

        timeForFinalTask = allInternalisationsCompleted &&
            lastLdtDate.isAfter(lastInternalisationDate);
      }
    }

    // if we have checked the pre-conditions, we also have to check if the final task has already been completed
    if (timeForFinalTask) {
      if (await _dataService.finalAssessmentCompleted()) {
        timeForFinalTask = false;
      }
    }

    return timeForFinalTask;
  }

  getLdtData(String trialName) async {
    return _dataService.getLdtData(trialName);
  }

  Future<int> getCurrentTrialIndex() async {
    Internalisation last = await this._dataService.getLastInternalisation();

    return PLAN_LDT_MAPPING[last.planId];
  }

  Future<bool> isTimeForInternalisationTask() async {
    _loggingService.logEvent("Trying to retrieve the last internalisation");
    var ud = await _dataService.getUserData();
    if (ud.registrationDate.isToday()) return false;

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

    var numberOf = await getNumberOfCompletedInternalisations();
    if (numberOf == STUDY_DURATION) {
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
      if (lastRecall.completionDate
          .isAfter(lastInternalisation.completionDate)) {
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
    if (!await lastThreeConditionsWereTheSame()) return false;

    var lastInternalisation = await _dataService.getLastInternalisation();

    // LDT and Internalisation have to be at least 6 hours
    var now = DateTime.now();
    var difference = now.difference(lastInternalisation.completionDate);
    if (difference.inHours < INTERNALISATION_RECALL_BREAK) {
      return false;
    }

    DateTime lastLdtDate = await _dataService.getDateOfLastLDT();

    if (lastLdtDate == null) {
      return true;
    }

    if (lastLdtDate.isAfter(lastInternalisation.completionDate)) {
      return false;
    }

    return true;
  }

  Future<bool> hasCompletedFinalAssessment() async {}

  Future<int> getNumberOfCompletedInternalisations() async {
    return await _dataService.getNumberOfCompletedInternalisations();
  }

  Future<Internalisation> getTodaysPlan(
      int completedInternalisations, int group) async {
    int planNumber =
        PLAN_CONDITION_MAPPING[group][completedInternalisations]["planId"];
    return await this._dataService.getCurrentInternalisation(planNumber);
  }

  Future<InternalisationCondition> getTodaysInternalisationCondition(
      int day, int group) async {
    return PLAN_CONDITION_MAPPING[group][day]["condition"];
  }

  Future<void> submitInternalisation(Internalisation internalisation) async {
    await this._dataService.saveInternalisation(internalisation);

    _notificationService.deleteScheduledInternalisationReminder();

    this.scheduleRecallTaskNotificationIfAppropriate(DateTime.now());

    _notificationService.scheduleInternalisationReminder(new Time(6, 30, 0));
  }

  Future<bool> _shouldIncrementStreakDay() async {
    var lastRecall = await _dataService.getLastRecallTask();
    if (lastRecall == null) {
      var userData = await _dataService.getUserData();
      return userData.registrationDate.isYesterday();
    }

    return lastRecall.completionDate.isYesterday();
  }

  Future<void> submitRecallTask(RecallTask recallTask) async {
    if (await _shouldIncrementStreakDay()) {
      _rewardService.addStreakDays(1);
    }
    _rewardService.addDaysActive(1);
    _rewardService.onRecallTask();

    // The last internalisation has info that has to be added to the recall task
    var lastInternalisation = await _dataService.getLastInternalisation();

    if (lastInternalisation != null) {
      recallTask.plan = lastInternalisation.plan;
      recallTask.planId = lastInternalisation.planId;
    }

    await _dataService.saveRecallTask(recallTask);
  }

  Future<void> submitAssessment(
      AssessmentResult assessment, AssessmentTypes type) async {
    this._dataService.saveAssessment(assessment);

    var nextRoute = RouteNames.NO_TASKS;
    dynamic args;

    if (type == AssessmentTypes.usability) {
      var index = await getCurrentTrialIndex();
      args = index.toString();
      nextRoute = RouteNames.LDT;
    } else if (type == AssessmentTypes.affect) {
      nextRoute = RouteNames.INTERNALISATION;
    }

    _navigationService.navigateTo(nextRoute, arguments: args);
  }

  Future<void> submitLDT(LdtData ldtData) async {
    await _dataService.saveLdtData(ldtData);
  }

  Future<void> nextScreen(String currentScreen) async {
    if (currentScreen == RouteNames.LDT) {
      return await _navigationService.navigateTo(RouteNames.NO_TASKS_AFTER_LDT);
    }
    if (currentScreen == RouteNames.AMBULATORY_ASSESSMENT_MORNING) {
      return await _navigationService.navigateTo(RouteNames.INTERNALISATION);
    }
    if (currentScreen == RouteNames.AMBULATORY_ASSESSMENT_EVENING) {
      if (await isTimeForLexicalDecisionTask()) {
        _navigationService
            .navigateTo(RouteNames.AMBULATORY_ASSESSMENT_USABILITY);
      } else {
        _navigationService.navigateTo(RouteNames.NO_TASKS_AFTER_RECALL);
      }

      if (await isTimeForFinalTask()) {
        this._rewardService.onFinalTask();
        _navigationService.navigateTo(RouteNames.NO_TASKS_AFTER_RECALL);
      }
    }
    if (currentScreen == RouteNames.INIT_START) {
      return await _navigationService
          .navigateTo(RouteNames.NO_TASKS_AFTER_INITIALIZATION);
    }
    if (currentScreen == RouteNames.INTERNALISATION) {
      _navigationService.navigateTo(RouteNames.NO_TASKS);
    }
    if (currentScreen == RouteNames.RECALL_TASK) {
      return await _navigationService
          .navigateTo(RouteNames.AMBULATORY_ASSESSMENT_EVENING);
    }
    if (currentScreen == RouteNames.AMBULATORY_ASSESSMENT_USABILITY) {
      int trialIndex = await getCurrentTrialIndex();
      _navigationService.navigateTo(RouteNames.LDT,
          arguments: trialIndex.toString());
    }
    if (currentScreen == RouteNames.AMBULATORY_ASSESSMENT_FINISH) {
      _navigationService.navigateTo(RouteNames.NO_TASKS_AFTER_FINAL);
    }
  }
}
