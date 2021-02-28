import 'package:serene/models/assessment.dart';
import 'package:serene/models/assessment_item.dart';
import 'package:serene/services/experiment_service.dart';
import 'package:serene/services/user_service.dart';
import 'package:serene/shared/enums.dart';
import 'package:serene/viewmodels/base_view_model.dart';

class AmbulatoryAssessmentViewModel extends BaseViewModel {
  final AssessmentType _assessmentType;

  UserService _userService;
  final ExperimentService _experimentService;
  List<AssessmentItemModel> _currentAssessment = [];
  get currentAssessment => _currentAssessment;
  String title;
  String preText = "";
  Map<String, String> results = {};

  AmbulatoryAssessmentViewModel(
      this._assessmentType, this._userService, this._experimentService) {
    if (this._assessmentType == AssessmentType.preImplementationIntention) {
      title = "";
      this._currentAssessment = getPreLearningList();
    } else if (this._assessmentType == AssessmentType.postTest) {
      title = "";
      this._currentAssessment = getPostTest();
    } else if (this._assessmentType == AssessmentType.usability) {
      title = "";
      this._currentAssessment = _getUsabilityQuestionnaire();
    } else if (this._assessmentType == AssessmentType.dailyQuestion) {
      title = "Tägliche Lernabfrage";
      _currentAssessment = _getDailyQuestionList();
    }
  }

  getPreLearningList() {
    List<AssessmentItemModel> _preGoal = [
      AssessmentItemModel(
          "Wie verpflichtet fühlst du dich, deine Ziele heute zu erreichen?",
          {1: "1: Gar nicht", 2: "2", 3: "3", 4: "4", 5: "5: Sehr"},
          "preLearning1"),
      AssessmentItemModel(
          "Wie schwierig wird es heute, deine Ziele zu erreichen?",
          {1: "1: Gar nicht", 2: "2", 3: "3", 4: "4", 5: "5: Sehr"},
          "preLearning2"),
      AssessmentItemModel(
          "Wie sehr freust du dich auf diese Aufgaben?",
          {1: "1: Gar nicht", 2: "2", 3: "3", 4: "4", 5: "5: Sehr"},
          "preLearning3"),
    ];
    return _preGoal;
  }

  _getDailyQuestionList() {
    List<AssessmentItemModel> _dailyQuestion = [
      AssessmentItemModel("Hast du heute vor zu lernen?", {1: "Ja", 2: "Nein"},
          "dailyQuestion1")
    ];
    return _dailyQuestion;
  }

  getAfterLearningQuestionnaire(
      String whereYouString, String stillManageString) {
    List<AssessmentItemModel> _afterLearning = [
      AssessmentItemModel(
          "$whereYouString", {1: "Ja", 2: "Nein"}, "postLearning1"),
      AssessmentItemModel(
          "$stillManageString", {1: "Ja", 2: "Nein"}, "postLearning2"),
      AssessmentItemModel(
          "Wie zufrieden bist du mit deinem Lerntag?",
          {1: "1: Gar nicht", 2: "2", 3: "3", 4: "4", 5: "5: Sehr"},
          "postLearning3"),
    ];
    return _afterLearning;
  }

  _getUsabilityQuestionnaire() {
    List<AssessmentItemModel> _usability = [
      AssessmentItemModel(
          "Wie viel **Spaß** hat es dir gemacht, dir die Pläne so einzuprägen?",
          {
            1: "Sehr viel Spaß",
            2: "Eher Spaß",
            3: "Weder noch",
            4: "Eher keinen Spaß",
            5: "Gar keinen Spaß"
          },
          "usabilityFun"),
      AssessmentItemModel(
          "Wie **schwierig** fandest du es, dir die Pläne so einzuprägen?",
          {
            1: "Sehr schwierig",
            2: "Eher schwierig",
            3: "Weder noch",
            4: "Eher einfach",
            5: "Sehr einfach"
          },
          "usabilityFun"),
    ];
    return _usability;
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
          labels,
          "postTest1"),
      AssessmentItemModel(
          "Ich habe gedacht: 'So ein Plan bringt doch gar nichts!'",
          labels,
          "postTest2"),
      AssessmentItemModel(
          "Ich habe während des Lernens immer wieder bewusst an meinen Plan gedacht.",
          labels,
          "postTest3"),
      AssessmentItemModel(
          "Der Plan hat mir geholfen, meine Lernziele besser zu erreichen",
          labels,
          "postTest4")
    ];
    return _postTest;
  }

  getResultForIndex(int index) {
    var key = this._currentAssessment[index].id;
    if (results.containsKey(key)) return int.parse(results[key]);
    return null;
  }

  getWhereYouInsertForHindrance(String hindrance) {
    if (hindrance == Hindrances.OVERWHELMED)
      return "Warst du überfordert, als du zuletzt gelernt hast?";
    if (hindrance == Hindrances.DISTRACTED)
      return "Hast du dich von deinem Lernen ablenken lassen?";
    if (hindrance == Hindrances.LISTLESSNESS)
      return "Hast du Lustlosigkeit gegenüber dem Lernen verspürt?";
    if (hindrance == Hindrances.PHYSICAL_CONDITION)
      return "Hat dich deine körperliche Verfassung beim Lernen beeinträchtigt?";

    return "HINDRANCE NOT FOUND";
  }

  getDidYouStillManageInsertForHindrance(String hindrance) {
    if (hindrance == Hindrances.OVERWHELMED)
      return "Hast du es dann geschafft, dir zu sagen, dass du es trotzdem schaffen kannst?";
    if (hindrance == Hindrances.DISTRACTED)
      return "Hast du es dann geschafft, dich dann trotzdem auf deine Aufgabe zu konzentrieren?";
    if (hindrance == Hindrances.LISTLESSNESS)
      return "Hast du es dann geschafft, dir zu sagen, dass du es aus einem guten Grund tust?";
    if (hindrance == Hindrances.PHYSICAL_CONDITION)
      return "Hast du es dann geschafft, dich dazu zu bringen, es trotzdem zu probieren?";

    return "HINDRANCE NOT FOUND";
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
