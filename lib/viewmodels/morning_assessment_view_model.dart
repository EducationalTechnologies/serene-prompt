import 'dart:core';
import 'package:flutter/foundation.dart';
import 'package:serene/models/assessment.dart';
import 'package:serene/models/assessment_result.dart';
import 'package:serene/services/data_service.dart';
import 'package:serene/services/experiment_service.dart';
import 'package:serene/shared/enums.dart';
import 'package:serene/shared/route_names.dart';
import 'package:serene/viewmodels/multi_step_assessment_view_model.dart';

enum MorningAssessmentPages {
  learningIntention,
  noLearningIntentionReason,
  affect,
  success,
  dailyObstacle
}

class MorningAssessmentViewModel extends MultiStepAssessmentViewModel {
  static const int STEP_LEARNING_INTENTION = 0;
  static const int STEP_REASON_NOT_LEARNING = 1;
  static const int STEP_SUCCESS = 2;
  static const int STEP_AFFECT = 3;
  static const int STEP_DAILY_LEARNING_OBSTACLE = 4;
  static const int STEP_FINISH = 5;

  final DataService _dataService;
  final ExperimentService _experimentService;

  MorningAssessmentViewModel(this._dataService, this._experimentService);

  DailyLearningIntention dailyLearningChoice;

  String _notLearningReason = "";

  String get notLearningReason => _notLearningReason;

  int nextPage;
  MorningAssessmentPages currentPage = MorningAssessmentPages.learningIntention;

  set notLearningReason(String notLearningReason) {
    _notLearningReason = notLearningReason;
    notifyListeners();
  }

  // set willLearnToday(bool willLearnToday) {
  //   _willLearnToday = willLearnToday;
  //   notifyListeners();
  // }

  onNotLearningReasonChanged(String notLearningReason) {
    this.setAssessmentResult(
        "dailyLearningIntention_2", "0", notLearningReason);
  }

  onLearningObstacleChanged(String obstacle) {
    this.setAssessmentResult("dailyObstacle_1", "0", obstacle);
  }

  submit() {
    // TODO: SAVE THE ASSESSMENT
    var date = DateTime.now();
    var type = "morningAA";
    Map<String, String> results = {};
    for (var result in allAssessmentResults.values) {
      results.addAll(result);
    }
    var oneBigAssessment = AssessmentResult(results, type, date);

    _dataService.saveAssessment(oneBigAssessment);
    _experimentService.nextScreen(RouteNames.AMBULATORY_ASSESSMENT_MORNING);
  }

  @override
  bool canMoveBack(int currentStep) {
    return false;
  }

  @override
  void setAssessmentResult(String assessmentType, String itemId, String value) {
    super.setAssessmentResult(assessmentType, itemId, value);
  }

  @override
  bool canMoveNext(int currentPage) {
    if (step == STEP_FINISH) return false;

    return true;
  }

  @override
  int getNextPage(int currentPage) {
    // TODO: implement getNextPage
    var nextPage = step + 1;

    if (currentPage == STEP_LEARNING_INTENTION) {
      if (currentAssessmentResults.containsKey("dailyLearningIntention_1")) {
        var choice = currentAssessmentResults["dailyLearningIntention_1"];
        if (choice == "1" || choice == "3") {
          nextPage = STEP_SUCCESS;
        }
        if (choice == "2") {
          nextPage = STEP_REASON_NOT_LEARNING;
        }
        if (choice == "4") {
          nextPage = STEP_AFFECT;
        }
      }
    }
    if (currentPage == STEP_REASON_NOT_LEARNING) {
      nextPage = STEP_SUCCESS;
    }
    if (currentPage == STEP_SUCCESS) {
      if (currentAssessmentResults.containsKey("success_3")) {
        var choice = currentAssessmentResults["success_3"];
        if (choice != "1") {
          nextPage = STEP_DAILY_LEARNING_OBSTACLE;
        } else {
          nextPage = STEP_FINISH;
        }
      }
    }

    if (currentPage == STEP_DAILY_LEARNING_OBSTACLE) {
      nextPage = STEP_FINISH;
    }
    return nextPage;
  }

  @override
  Future<Assessment> getAssessment(AssessmentTypes assessmentType) async {
    String name = describeEnum(assessmentType);
    Assessment assessment = await _dataService.getAssessment(name);
    lastAssessment = assessment;
    currentAssessmentResults = {};
    return assessment;
  }
}
