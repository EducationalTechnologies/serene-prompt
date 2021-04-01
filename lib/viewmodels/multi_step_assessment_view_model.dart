import 'package:flutter/foundation.dart';
import 'package:serene/models/assessment.dart';
import 'package:serene/shared/enums.dart';
import 'package:serene/viewmodels/base_view_model.dart';

abstract class MultiStepAssessmentViewModel extends BaseViewModel {
  int step = 0;
  Type currentPageType;
  Assessment lastAssessment = Assessment();

  bool canMoveBack(int currentPage);
  bool canMoveNext(int currentPage);
  int getNextPage(int currentPage);

  Map<String, String> currentAssessmentResults = {};
  Map<String, Map<String, String>> allAssessmentResults = {};

  setAssessmentResult(String assessmentType, String itemId, String value) {
    currentAssessmentResults[itemId] = value;

    if (!allAssessmentResults.containsKey(assessmentType)) {
      allAssessmentResults[assessmentType] = {itemId: value};
    }
    allAssessmentResults[assessmentType][itemId] = value;

    notifyListeners();
  }

  Future<Assessment> getAssessment(AssessmentTypes assessmentType);
}
