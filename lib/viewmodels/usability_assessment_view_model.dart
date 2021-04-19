import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:prompt/models/assessment_result.dart';
import 'package:prompt/services/data_service.dart';
import 'package:prompt/services/experiment_service.dart';
import 'package:prompt/shared/enums.dart';
import 'package:prompt/models/assessment.dart';
import 'package:prompt/shared/route_names.dart';
import 'package:prompt/viewmodels/multi_step_assessment_view_model.dart';

enum STEPS { introduction, questions, ldtInstruction }

class UsabilityAssessmentViewModel extends MultiStepAssessmentViewModel {
  final DataService _dataService;
  final ExperimentService _experimentService;

  UsabilityAssessmentViewModel(this._dataService, this._experimentService);

  @override
  bool canMoveBack(Key currentPageKey) {
    return false;
  }

  @override
  bool canMoveNext(ValueKey currentPageKey) {
    var step = currentPageKey.value as STEPS;

    switch (step) {
      case STEPS.introduction:
        return true;
        break;
      case STEPS.questions:
        return isAssessmentFilledOut(lastAssessment);
        break;
      case STEPS.ldtInstruction:
        return true;
        break;
    }
    return true;
  }

  String getIntroductionText(String condition) {
    var text =
        "In den letzten 3 Tagen hast du dir die Pläne eingeprägt, indem du sie ";
    if (condition == InternalisationCondition.emoji.toString()) {
      text += "mit Emojis dargestellt hast";
    }
    if (condition == InternalisationCondition.waiting.toString()) {
      text += "dir dreimal durchgelesen hast";
    }
    if (condition == InternalisationCondition.scrambleWithHint.toString()) {
      text += "aus den einzelnen Wörtern zusammengesetzt hast";
    }
    return text;
  }

  Assessment replacePlaceholder(Assessment assessment, String condition) {
    String replacementValue = "";
    if (condition == InternalisationCondition.emoji.toString()) {
      replacementValue += "den Plan aus Emojis darstellen";
    }
    if (condition == InternalisationCondition.waiting.toString()) {
      replacementValue += "den Plan dreimal lesen";
    }
    if (condition == InternalisationCondition.scrambleWithHint.toString()) {
      replacementValue += "den Plan aus Wörtern selbst zusammenbauen";
    }
    for (var item in assessment.items) {
      item.title = item.title.replaceAll("[X]", replacementValue);
    }
    return assessment;
  }

  @override
  Future<Assessment> getAssessment(AssessmentTypes assessmentType) async {
    var last = await _dataService.getLastInternalisation();
    var condition = last.condition;
    String name = describeEnum(assessmentType);
    Assessment assessment = await _dataService.getAssessment(name);
    assessment = replacePlaceholder(assessment, condition);
    assessment.title = getIntroductionText(condition);
    return assessment;
  }

  @override
  int getNextPage(Key currentPageKey) {
    return step + 1;
  }

  @override
  void submit() {
    var date = DateTime.now();
    var type = "usability";
    Map<String, String> results = {};
    for (var result in allAssessmentResults.values) {
      results.addAll(result);
    }
    var oneBigAssessment = AssessmentResult(results, type, date);

    _dataService.saveAssessment(oneBigAssessment);
    _experimentService.nextScreen(RouteNames.AMBULATORY_ASSESSMENT_USABILITY);
  }
}
