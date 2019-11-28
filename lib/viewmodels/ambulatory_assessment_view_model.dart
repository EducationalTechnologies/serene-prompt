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
  List<AssessmentItemModel> _currentAssessment = [];
  get currentAssessment => _currentAssessment;
  String title;

  Map<String, String> results;

  getPreLearningList() {
    var itemCount = 5;
    List<AssessmentItemModel> _preGoal = [
      AssessmentItemModel(
          "Wie verpflichtet fühlst du dich, deine Ziele heute zu erreichen?",
          itemCount,
          null,
          "preLearning1"),
      AssessmentItemModel(
          "Wie schwierig wird es heute, deine Ziele zu erreichen?",
          itemCount,
          null,
          "preLearning2"),
      AssessmentItemModel(
          "Wie sehr freust du dich auf diese Aufgaben?",
          5,
          {1: "1: Gar nicht", 2: "2", 3: "3", 4: "4", 5: "5: Sehr"},
          "preLearning3"),
    ];
    return _preGoal;
  }

  getAfterLearningQuestionnaire(
      String whereYouString, String stillManageString) {
    List<AssessmentItemModel> _afterLearning = [
      AssessmentItemModel(
          "$whereYouString", 2, {1: "Ja", 2: "Nein"}, "postLearning1"),
      AssessmentItemModel(
          "$stillManageString", 2, {1: "Ja", 2: "Nein"}, "postLearning2"),
      AssessmentItemModel(
          "Wie zufrieden bist du mit deinem Lerntag?",
          5,
          {1: "1: Gar nicht", 2: "2", 3: "3", 4: "4", 5: "5: Sehr"},
          "postLearning3"),
    ];
    return _afterLearning;
  }

  _getSrlQuestionnaire() {
    var itemCount = 5;
    List<AssessmentItemModel> _preGoal = [
      AssessmentItemModel(
          "Ich habe feste Ziele im Leben", itemCount, null, "srl[SQ001]"),
      AssessmentItemModel(
          "Ich kann überprüfen, ob ich meine Ziele erreicht habe",
          itemCount,
          null,
          "srl[SQ002]"),
      AssessmentItemModel(
          "Ich wähle meine Ziele so, dass sie eine Herausforderung für mich sind",
          itemCount,
          null,
          "srl[SQ003]"),
      AssessmentItemModel(
          "Ich versuche, meine eigene Leistung von Mal zu Mal zu steigern",
          itemCount,
          null,
          "srl[SQ004]"),
      AssessmentItemModel(
          "Ich setze mir feste Zeitpunkte, zu denen ich meine Ziele erreichen will",
          itemCount,
          null,
          "srl[SQ005]"),
      AssessmentItemModel(
          "Wenn ich viel zu lernen habe, mache ich mir einen Zeitplan, was ich wann lerne",
          itemCount,
          null,
          "srl[SQ006]"),
      AssessmentItemModel("Ich lerne immer zu gleich bleibenden Zeiten",
          itemCount, null, "srl[SQ007]"),
      AssessmentItemModel(
          "Alle wichtigen Termine und Aufgaben schreibe ich mir auf",
          itemCount,
          null,
          "srl[SQ008]"),
      AssessmentItemModel(
          "Ich denke an frühere Erfolge zurück, um mein Selbstbewusstsein zu stärken",
          itemCount,
          null,
          "srl[SQ009]"),
      AssessmentItemModel(
          "Um mich zu motivieren, rufe ich mir vor Augen, wie schön es sein wird, wenn ich ein Ziel erreicht haben werde",
          itemCount,
          null,
          "srl[SQ010]"),
      AssessmentItemModel(
          "Ich suche mir Erfolgserlebnisse, um mich für schwierige Aufgaben zu motivieren",
          itemCount,
          null,
          "srl[SQ011]"),
      AssessmentItemModel(
          "Wenn mein Durchhaltevermögen nachlässt, weiß ich meist genau, wie ich meine Lust an der Sache verstärken kann",
          itemCount,
          null,
          "srl[SQ012]"),
      AssessmentItemModel(
          "Ich kann es schaffen, einer anfangs unangenehmen Tätigkeit zunehmend angenehme Seiten abzugewinnen",
          itemCount,
          null,
          "srl[SQ013]"),
      AssessmentItemModel(
          "Ich kann meine Stimmung so verändern, dass mir dann alles leichter von der Hand geht",
          itemCount,
          null,
          "srl[SQ014]"),
      AssessmentItemModel(
          "Ich kann mich beim Lernen gut in die Stimmung hineinbringen, die ich im Moment am besten gebrauchen kann",
          itemCount,
          null,
          "srl[SQ015]"),
      AssessmentItemModel(
          "Ich versuche, Beziehungen zu den Inhalten verwandter Fächer bzw. Lehrveranstaltungen herzustellen",
          itemCount,
          null,
          "srl[SQ016]"),
      AssessmentItemModel(
          "Zu neuen Konzepten stelle ich mir praktische Anwendungen vor",
          itemCount,
          null,
          "srl[SQ017]"),
      AssessmentItemModel(
          "Ich versuche in Gedanken, das Gelernte mit dem zu verbinden, was ich schon darüber weiß",
          itemCount,
          null,
          "srl[SQ018]"),
      AssessmentItemModel(
          "Ich beginne erst mit dem Lernen, wenn ich mir die notwendigen Einzelschritte klargemacht habe",
          itemCount,
          null,
          "srl[SQ019]"),
      AssessmentItemModel("Ich denke regelmäßig über mein Lernen nach",
          itemCount, null, "srl[SQ020]"),
      AssessmentItemModel(
          "Ich mache mir Aufzeichnungen über mein Lernverhalten",
          itemCount,
          null,
          "srl[SQ021]"),
      AssessmentItemModel(
          "Ich notiere mir Strategien, die ich beim Lernen ausprobieren möchte",
          itemCount,
          null,
          "srl[SQ022]"),
      AssessmentItemModel(
          "Nach einer Lernwoche überlege ich, was ich alles gelernt habe",
          itemCount,
          null,
          "srl[SQ023]"),
      AssessmentItemModel(
          "Am Ende des Tages frage ich mich, ob ich zufrieden bin mit meiner Leistung",
          itemCount,
          null,
          "srl[SQ024]"),
      AssessmentItemModel(
          "Wenn ich ein Thema gelernt habe, überlege ich, was ich beim Lernen für das nächste Thema anders machen möchte",
          itemCount,
          null,
          "srl[SQ025]"),
      AssessmentItemModel(
          "Am Ende einer Woche denke ich darüber nach, welche Themen ich gekonnt habe und welche nicht",
          itemCount,
          null,
          "srl[SQ026]"),
    ];
    return _preGoal;
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
      title = "";
      this._currentAssessment = getPreLearningList();
    } else if (this._type == AssessmentType.postLearning) {
      title = "";
      this._dataService.getLastGoalShield().then((shield) {
        var stillManageString =
            getDidYouStillManageInsertForHindrance(shield.hindrance);
        var whereYouString = getWhereYouInsertForHindrance(shield.hindrance);
        this._currentAssessment =
            getAfterLearningQuestionnaire(whereYouString, stillManageString);
        initializeResults();
        notifyListeners();
      });
    } else if (this._type == AssessmentType.postTest) {
      title = "";
      this._currentAssessment = getPostTest();
    } else if (this._type == AssessmentType.srl) {
      title = "";
      this._currentAssessment = _getSrlQuestionnaire();
    }

    initializeResults();
  }

  initializeResults() {
    results = {};
    for (var a in _currentAssessment) {
      results[a.id] = null;
    }
  }

  getWhereYouInsertForHindrance(String hindrance) {
    // TODO: Replace hard coded stuff
    if (hindrance == "Überforderung")
      return "Warst du überfordert, als du zuletzt gelernt hast?";
    if (hindrance == "Ablenkung")
      return "Hast du dich von deinem Lernen ablenken lassen?";
    if (hindrance == "Lustlosigkeit")
      return "Hast du Lustlosigkeit gegenüber dem Lernen verspürt?";
    if (hindrance == "Körperliche Verfassung")
      return "Hat dich deine körperliche Verfassung beim Lernen beeinträchtigt?";

    return "HINDRANCE NOT FOUND";
  }

  getDidYouStillManageInsertForHindrance(String hindrance) {
    // TODO: Replace hard coded stuff
    if (hindrance == "Überforderung")
      return "Hast du es dann geschafft, dir zu sagen, dass du es trotzdem schaffen kannst?";
    if (hindrance == "Ablenkung")
      return "Hast du es dann geschafft, dich dann trotzdem auf deine Aufgabe zu konzentrieren?";
    if (hindrance == "Lustlosigkeit")
      return "Hast du es dann geschafft, dir zu sagen, dass du es aus einem guten Grund tust?";
    if (hindrance == "Körperliche Verfassung")
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
    var assessmentModel = AssessmentModel(
        _userService.getUsername(), results, _type, DateTime.now());

    await this._dataService.saveAssessment(assessmentModel);
  }
}
