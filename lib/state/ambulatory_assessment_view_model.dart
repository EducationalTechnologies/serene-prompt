import 'package:flutter/widgets.dart';
import 'package:serene/models/assessment.dart';
import 'package:serene/models/assessment_item.dart';
import 'package:serene/services/data_service.dart';
import 'package:serene/services/user_service.dart';
import 'package:serene/shared/enums.dart';

class AmbulatoryAssessmentViewModel with ChangeNotifier {
  String _type;

  UserService _userService;
  DataService _dataService;
  List<AssessmentItemModel> _currentAssessment;
  get currentAssessment => _currentAssessment;

  Map<String, String> results;

  getPreLearningList() {
    var itemCount = 5;
    List<AssessmentItemModel> _preGoal = [
      AssessmentItemModel(
          "Wie verpflichtet fühlst du dich, dieses Ziel heute zu erreichen?",
          itemCount,
          null,
          "preLearning1"),
      AssessmentItemModel(
          "Wie schwierig wird es heute, dieses Ziel zu erreichen?",
          itemCount,
          null,
          "preLearning2"),
      AssessmentItemModel("Wie sehr freust du dich auf diese Aufgabe?",
          itemCount, null, "preLearning3"),
    ];
    return _preGoal;
  }

  getAfterLearningList() {
    List<AssessmentItemModel> _afterLearning = [
      AssessmentItemModel("Warst du heute während des Lernens überfordert?", 2,
          {1: "Ja", 2: "Nein"}, "postLearning1"),
      AssessmentItemModel(
          "Hast du es dann geschafft, dir zu sagen, dass du es trotzdem schaffen kannst?",
          2,
          {1: "Ja", 2: "Nein"},
          "postLearning2"),
      AssessmentItemModel("Wie zufrieden bist du mit dem heutigen Lerntag?", 5,
          {1: "1: Gar nicht", 2: "", 3: "", 4: "", 5: "Sehr"}, "postLearning3"),
    ];
    return _afterLearning;
  }

  getPostTest() {
    final labels = {
      1: "Nie",
      2: "Selten",
      3: "Gelegentlich",
      4: "Oft",
      5: "Sehr oft"
    };
    List<AssessmentItemModel> _postTest = [
      AssessmentItemModel(
          "Ich habe mir Mühe gegeben, meinen Plan für den Tag zu verinnerlichen",
          5,
          labels,
          "postTest1"),
      AssessmentItemModel(
          "Ich habe gedacht: 'So ein Plan bringt doch gar nichts!'",
          5,
          labels,
          "postTest2"),
      AssessmentItemModel(
          "Ich habe während des Lernens immer wieder bewusst an meinen Plan gedacht.",
          5,
          labels,
          "postTest3"),
      AssessmentItemModel(
          "Der Plan hat mir geholfen, meine Lernziele besser zu erreichen",
          5,
          labels,
          "postTest4")
    ];
    return _postTest;
  }

  AmbulatoryAssessmentViewModel(
      this._type, this._userService, this._dataService) {
    if (this._type == AssessmentType.preLearning) {
      this._currentAssessment = getPreLearningList();
    } else if (this._type == AssessmentType.postLearning) {
      this._currentAssessment = getAfterLearningList();
    } else if (this._type == AssessmentType.postTest) {
      this._currentAssessment = getPostTest();
    }

    results = {};
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
    var assessmentModel = AssessmentModel(
        _userService.getUsername(), results, _type, DateTime.now());

    await this._dataService.saveAssessment(assessmentModel);
  }
}
