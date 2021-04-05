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

  static const int STEP_DIDLEARNTODAY = 0;
  static const int STEP_WHYNOTLEARN = 1;
  static const int STEP_EVENINGASSESSMENT = 2;
  static const int STEP_FINISH = 3;

  EveningAssessmentViewModel(this._dataService, this._experimentService);

  void whyNotLearnReason(String reason) {
    this.setAssessmentResult("didLearnToday_2", "0", reason);
  }

  @override
  bool canMoveBack(Key currentStep) {
    return false;
  }

  @override
  bool canMoveNext(Key currentStep) {
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

    if (currentPageKey == ValueKey(STEP_DIDLEARNTODAY)) {
      if (currentAssessmentResults.containsKey("didLearnToday_1")) {
        var choice = currentAssessmentResults["didLearnToday_1"];
        if (choice == "2") {
          nextPage = STEP_WHYNOTLEARN;
        } else {
          nextPage = STEP_EVENINGASSESSMENT;
        }
      }
    }
    if (currentPageKey == ValueKey(STEP_WHYNOTLEARN)) {
      nextPage = STEP_EVENINGASSESSMENT;
    }
    if (currentPageKey == ValueKey(STEP_EVENINGASSESSMENT)) {
      nextPage = STEP_FINISH;
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
