import 'package:flutter/material.dart';
import 'package:serene/models/assessment.dart';
import 'package:serene/shared/enums.dart';
import 'package:serene/viewmodels/base_view_model.dart';

abstract class MultiStepAssessmentViewModel extends BaseViewModel {
  int step = 0;
  Assessment lastAssessment = Assessment();

  bool canMoveBack(Key currentPageKey);
  bool canMoveNext(Key currentPageKey);
  int getNextPage(Key currentPageKey);
  void submit();

  Map<String, String> currentAssessmentResults = {};
  Map<String, Map<String, String>> allAssessmentResults = {};

  isAssessmentFilledOut(Assessment assessment) {
    if (assessment.id.isEmpty) return false;
    bool canSubmit = true;
    for (var assessmentItem in assessment.items) {
      if (!currentAssessmentResults.containsKey(assessmentItem.id))
        canSubmit = false;
    }
    return canSubmit;
  }

  setAssessmentResult(String assessmentType, String itemId, String value) {
    currentAssessmentResults[itemId] = value;

    if (!allAssessmentResults.containsKey(assessmentType)) {
      allAssessmentResults[assessmentType] = {itemId: value};
    }
    allAssessmentResults[assessmentType][itemId] = value;

    notifyListeners();
  }

  Future<Assessment> getAssessment(AssessmentTypes assessmentType);

  clearCurrent() {
    lastAssessment = Assessment();
    currentAssessmentResults = {};
  }

  onAssessmentLoaded(Assessment assessment) {
    lastAssessment = assessment;
    currentAssessmentResults = {};
  }
}
