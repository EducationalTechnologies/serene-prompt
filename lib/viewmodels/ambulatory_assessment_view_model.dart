import 'package:serene/models/assessment.dart';
import 'package:serene/models/assessment_item.dart';
import 'package:serene/services/experiment_service.dart';
import 'package:serene/services/user_service.dart';
import 'package:serene/shared/enums.dart';
import 'package:serene/viewmodels/base_view_model.dart';

class AmbulatoryAssessmentViewModel extends BaseViewModel {
  final Assessments _assessmentType;

  UserService _userService;
  final ExperimentService _experimentService;
  List<AssessmentItemModel> _currentAssessment = [];
  get currentAssessment => _currentAssessment;
  String title;
  String preText = "";
  Map<String, String> results = {};

  AmbulatoryAssessmentViewModel(
      this._assessmentType, this._userService, this._experimentService) {
    if (this._assessmentType == Assessments.preImplementationIntention) {
      title = "";
      this._currentAssessment = getPreLearningList();
    } else if (this._assessmentType == Assessments.usability) {
      title = "";
      this._currentAssessment = _getUsabilityQuestionnaire();
    }
  }

  getPreLearningList() {
    List<AssessmentItemModel> _preGoal = [
      AssessmentItemModel(
          "Wie verpflichtet fühlst du dich, deine Ziele heute zu erreichen?",
          {"1": "Gar nicht", "2": "2", "3": "3", "4": "4", "5": "Sehr"},
          "preLearning1"),
      AssessmentItemModel(
          "Wie schwierig wird es heute, deine Ziele zu erreichen?",
          {"1": "Gar nicht", "2": "2", "3": "3", "4": "4", "5": "Sehr"},
          "preLearning2"),
      AssessmentItemModel(
          "Wie sehr freust du dich auf diese Aufgaben?",
          {"1": "Gar nicht", "2": "2", "3": "3", "4": "4", "5": "Sehr"},
          "preLearning3"),
    ];
    return _preGoal;
  }

  _getUsabilityQuestionnaire() {
    List<AssessmentItemModel> _usability = [
      AssessmentItemModel(
          "Wie viel **Spaß** hat es dir gemacht, dir die Pläne so einzuprägen?",
          {
            "1": "Sehr viel Spaß",
            "2": "Eher Spaß",
            "3": "Weder noch",
            "4": "Eher keinen Spaß",
            "5": "Gar keinen Spaß"
          },
          "usabilityFun"),
      AssessmentItemModel(
          "Wie **schwierig** fandest du es, dir die Pläne so einzuprägen?",
          {
            "1": "Sehr schwierig",
            "2": "Eher schwierig",
            "3": "Weder noch",
            "4": "Eher einfach",
            "5": "Sehr einfach"
          },
          "usabilityFun"),
    ];
    return _usability;
  }

  getResultForIndex(int index) {
    var key = this._currentAssessment[index].id;
    if (results.containsKey(key)) return int.parse(results[key]);
    return null;
  }

  setResult(String id, String value) {
    results[id] = value;
    notifyListeners();
  }

  canSubmit() {
    bool canSubmit = true;
    for (var assessmentItem in currentAssessment) {
      if (!results.containsKey(assessmentItem.id)) canSubmit = false;
    }
    return canSubmit;
  }

  submit() async {
    if (state == ViewState.busy) return;
    setState(ViewState.busy);
    var assessmentModel = AssessmentModel(_userService.getUsername(), results,
        _assessmentType.toString(), DateTime.now());

    await this
        ._experimentService
        .submitAssessment(assessmentModel, _assessmentType);
  }
}
