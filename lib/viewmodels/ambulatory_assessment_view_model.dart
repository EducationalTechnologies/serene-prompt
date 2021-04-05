import 'package:flutter/foundation.dart';
import 'package:serene/models/assessment.dart';
import 'package:serene/models/assessment_result.dart';
import 'package:serene/services/data_service.dart';
import 'package:serene/services/experiment_service.dart';
import 'package:serene/shared/enums.dart';
import 'package:serene/viewmodels/base_view_model.dart';

class AmbulatoryAssessmentViewModel extends BaseViewModel {
  final AssessmentTypes _assessmentType;
  DataService _dataService;
  final ExperimentService _experimentService;
  Assessment _currentAssessment;
  Assessment get currentAssessment => _currentAssessment;
  String title;
  String preText = "";
  Map<String, String> results = {};

  AmbulatoryAssessmentViewModel(
      this._assessmentType, this._dataService, this._experimentService);

  Future<Assessment> getAssessment() async {
    String name = describeEnum(_assessmentType);
    Assessment assessment = await _dataService.getAssessment(name);
    this._currentAssessment = assessment;
    return assessment;
  }

  getResultForIndex(int index) {
    var key = this._currentAssessment.items[index].id;
    if (results.containsKey(key)) return int.parse(results[key]);
    return null;
  }

  setResult(String id, String value) {
    results[id] = value;
    notifyListeners();
  }

  canSubmit() {
    bool canSubmit = true;
    for (var assessmentItem in currentAssessment.items) {
      if (!results.containsKey(assessmentItem.id)) canSubmit = false;
    }
    return canSubmit;
  }

  submit() async {
    if (state == ViewState.busy) return;
    setState(ViewState.busy);
    var assessmentModel =
        AssessmentResult(results, _assessmentType.toString(), DateTime.now());

    await this
        ._experimentService
        .submitAssessment(assessmentModel, _assessmentType);
  }
}
