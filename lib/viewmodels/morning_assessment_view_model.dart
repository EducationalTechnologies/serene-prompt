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
  final int stepLearningIntention = 0;
  final int stepReasonNotLearning = 1;
  final int stepSuccess = 2;
  final int stepAffect = 3;
  final int stepDailyObstacle = 4;
  final int stepFinish = 5;

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
    _notLearningReason = notLearningReason;
    this.setAssessmentResult("dailyLearningIntention_2",
        "dailyLearningIntention_2", notLearningReason);
  }

  onLearningObstacleChanged(String obstacle) {
    this.setAssessmentResult("dailyObstacle_1", "dailyObstacle_1", obstacle);
  }

  submit() {
    var date = DateTime.now();
    var type = "morningQuestions";
    Map<String, String> results = {};
    for (var result in allAssessmentResults.values) {
      results.addAll(result);
    }
    var oneBigAssessment = AssessmentResult(results, type, date);

    _dataService.saveAssessment(oneBigAssessment);
    _experimentService.nextScreen(RouteNames.AMBULATORY_ASSESSMENT_MORNING);
  }

  @override
  bool canMoveBack(Key currentStep) {
    return false;
  }

  @override
  void setAssessmentResult(String assessmentType, String itemId, String value) {
    super.setAssessmentResult(assessmentType, itemId, value);
  }

  @override
  bool canMoveNext(Key currentPage) {
    var vk = currentPage as ValueKey;
    if (currentPage == ValueKey(stepLearningIntention) ||
        currentPage == ValueKey(stepSuccess) ||
        currentPage == ValueKey(stepAffect) ||
        currentPage == ValueKey(stepDailyObstacle)) {
      return isAssessmentFilledOut(lastAssessment);
    }

    if (vk.value == stepLearningIntention) {
      return isAssessmentFilledOut(lastAssessment);
    }

    if (vk.value == stepReasonNotLearning) {
      return _notLearningReason.isNotEmpty;
    }
    return false;
  }

  @override
  int getNextPage(Key currentPage) {
    var nextPage = step + 1;

    if (currentPage == ValueKey(stepLearningIntention)) {
      if (currentAssessmentResults.containsKey("dailyLearningIntention_1")) {
        var choice = currentAssessmentResults["dailyLearningIntention_1"];
        if (choice == "1" || choice == "3") {
          nextPage = stepSuccess;
        }
        if (choice == "2") {
          nextPage = stepReasonNotLearning;
        }
        if (choice == "4") {
          nextPage = stepAffect;
        }
      }
    }
    if (currentPage == ValueKey(stepReasonNotLearning)) {
      nextPage = stepAffect;
    }
    if (currentPage == ValueKey(stepSuccess)) {
      if (currentAssessmentResults.containsKey("success_3")) {
        var choice = currentAssessmentResults["success_3"];
        if (choice != "1") {
          nextPage = stepDailyObstacle;
        } else {
          nextPage = stepFinish;
        }
      }
    }
    if (currentPage == ValueKey(stepAffect)) {
      nextPage = stepFinish;
    }

    if (currentPage == ValueKey(stepDailyObstacle)) {
      nextPage = stepFinish;
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
