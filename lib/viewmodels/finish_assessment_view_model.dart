import 'package:flutter/foundation.dart';
import 'package:prompt/models/assessment.dart';
import 'package:prompt/models/assessment_result.dart';
import 'package:prompt/services/data_service.dart';
import 'package:prompt/services/experiment_service.dart';
import 'package:prompt/shared/enums.dart';
import 'package:prompt/shared/route_names.dart';
import 'package:prompt/viewmodels/multi_step_assessment_view_model.dart';

enum STEPS {
  instruction,
  visibilitySelection,
  visibilityCouldRead,
  questionsAttitude,
  questionsMotivation,
  questionsFreePositive,
  questionsFreeNegative
}

class FinishAssessmentViewModel extends MultiStepAssessmentViewModel {
  final DataService _dataService;
  final ExperimentService _experimentService;

  FinishAssessmentViewModel(this._dataService, this._experimentService);

  // String _textPositive = "";
  setTextPositive(String text) {
    // _textPositive = text;
    this.setAssessmentResult("finalFree_positive", "finalFree_positive", text);
    notifyListeners();
  }

  // String _textNegative = "";
  setTextNegative(String text) {
    // _textNegative = text;
    this.setAssessmentResult("finalFree_negative", "finalFree_negative", text);
    notifyListeners();
  }

  @override
  bool canMoveBack(Key currentPageKey) {
    if (currentPageKey == ValueKey(STEPS.instruction)) {
      return false;
    }
    if (currentPageKey == ValueKey(STEPS.visibilitySelection) ||
        currentPageKey == ValueKey(STEPS.visibilityCouldRead) ||
        currentPageKey == ValueKey(STEPS.questionsAttitude) ||
        currentPageKey == ValueKey(STEPS.questionsMotivation)) {
      return false;
    }
    return false;
  }

  @override
  bool canMoveNext(Key currentPageKey) {
    if (currentPageKey == ValueKey(STEPS.visibilitySelection) ||
        currentPageKey == ValueKey(STEPS.visibilityCouldRead) ||
        currentPageKey == ValueKey(STEPS.questionsAttitude) ||
        currentPageKey == ValueKey(STEPS.questionsMotivation)) {
      return isAssessmentFilledOut(lastAssessment);
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
    return step + 1;
  }

  @override
  void submit() {
    var date = DateTime.now();
    var type = "finalQuestions";
    Map<String, String> results = {};
    for (var result in allAssessmentResults.values) {
      results.addAll(result);
    }
    var oneBigAssessment = AssessmentResult(results, type, date);
    oneBigAssessment.startDate = this.startDate;

    _dataService.saveAssessment(oneBigAssessment);
    _experimentService.onFinalTaskCompleted();
    _experimentService.nextScreen(RouteNames.AMBULATORY_ASSESSMENT_FINISH);
  }
}
