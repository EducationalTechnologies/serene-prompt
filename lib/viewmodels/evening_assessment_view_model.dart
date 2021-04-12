import 'package:flutter/foundation.dart';
import 'package:serene/models/assessment_result.dart';
import 'package:serene/services/data_service.dart';
import 'package:serene/services/experiment_service.dart';
import 'package:serene/shared/enums.dart';
import 'package:serene/models/assessment.dart';
import 'package:serene/shared/route_names.dart';
import 'package:serene/viewmodels/multi_step_assessment_view_model.dart';

class EveningAssessmentViewModel extends MultiStepAssessmentViewModel {
  final DataService _dataService;
  final ExperimentService _experimentService;

  final int stepDidLearnToday = 0;
  final int stepWhyNotLearn = 1;
  final int stepEveningAssessment = 2;
  final int stepAffect = 3;
  final int stepFinish = 4;

  String reasonNotLearnToday = "";

  EveningAssessmentViewModel(this._dataService, this._experimentService);

  void whyNotLearnReason(String reason) {
    reasonNotLearnToday = reason;
    this.setAssessmentResult("didLearnToday_2", "didLearnToday_2", reason);
  }

  @override
  bool canMoveBack(Key currentStep) {
    return false;
  }

  @override
  bool canMoveNext(Key currentStep) {
    if (currentStep == ValueKey(stepDidLearnToday) ||
        currentStep == ValueKey(stepAffect) ||
        currentStep == ValueKey(stepEveningAssessment)) {
      return isAssessmentFilledOut(lastAssessment);
    }
    if (currentStep == ValueKey(stepWhyNotLearn)) {
      return reasonNotLearnToday.isNotEmpty;
    }
    return true;
  }

  @override
  Future<Assessment> getAssessment(AssessmentTypes assessmentType) async {
    String name = describeEnum(assessmentType);
    Assessment assessment = await _dataService.getAssessment(name);
    lastAssessment = assessment;
    currentAssessmentResults = {};
    return assessment;
  }

  @override
  int getNextPage(Key currentPageKey) {
    var nextPage = step + 1;

    if (currentPageKey == ValueKey(stepDidLearnToday)) {
      if (currentAssessmentResults.containsKey("didLearnToday_1")) {
        var choice = currentAssessmentResults["didLearnToday_1"];
        if (choice == "2") {
          nextPage = stepWhyNotLearn;
        } else {
          nextPage = stepEveningAssessment;
        }
      }
    }
    if (currentPageKey == ValueKey(stepWhyNotLearn)) {
      nextPage = stepAffect;
    }
    if (currentPageKey == ValueKey(stepEveningAssessment)) {
      nextPage = stepFinish;
    }
    if (currentPageKey == ValueKey(stepAffect)) {
      nextPage = stepFinish;
    }

    return nextPage;
  }

  @override
  void submit() {
    var date = DateTime.now();
    var type = "eveningQuestions";
    Map<String, String> results = {};
    for (var result in allAssessmentResults.values) {
      results.addAll(result);
    }
    var oneBigAssessment = AssessmentResult(results, type, date);

    _dataService.saveAssessment(oneBigAssessment);
    _experimentService.nextScreen(RouteNames.AMBULATORY_ASSESSMENT_EVENING);
  }
}
