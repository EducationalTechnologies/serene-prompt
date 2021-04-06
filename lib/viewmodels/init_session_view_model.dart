import 'package:flutter/foundation.dart';
import 'package:serene/models/assessment.dart';
import 'package:serene/models/assessment_result.dart';
import 'package:serene/models/obstacle.dart';
import 'package:serene/models/outcome.dart';
import 'package:serene/services/data_service.dart';
import 'package:serene/services/experiment_service.dart';
import 'package:serene/services/settings_service.dart';
import 'package:serene/shared/app_asset_paths.dart';
import 'package:serene/shared/enums.dart';
import 'package:serene/shared/route_names.dart';
import 'package:serene/viewmodels/lexical_decision_task_view_model.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

import 'package:serene/viewmodels/multi_step_assessment_view_model.dart';

class InitSessionViewModel extends MultiStepAssessmentViewModel {
  final int stepWelcomeScreen = 0;
  final int stepVideo1 = 1;
  final int stepCabuuLink = 2;
  final int stepQuestionsCabuuLearn = 3;
  final int stepQuestionsRegulation = 4;
  final int stepInitialDailyLearningGoal = 14;
  final int stepQuestionsLearningGoals1 = 5;
  final int stepVideo2 = 6;
  final int stepLdt00 = 7;
  final int stepLdt01 = 8;
  final int stepLdt02 = 9;
  final int stepLdt03 = 10;
  final int stepLdt04 = 11;
  final int stepLdt05 = 12;
  final int stepVideo3 = 13;
  final int stepOutcomeExplanationScreen = 15;
  final int stepOutcomeSelectionScreen = 16;
  final int stepOutcomeEnterScreen = 17;
  final int stepOutcomeSortingScreen = 18;
  final int stepOutcomeDisplayScreen = 19;
  final int stepObstacleExplanationScreen = 20;
  final int stepObstacleSelectionScreen = 21;
  final int stepObstacleEnterScreen = 22;
  final int stepObstacleSortingScreen = 23;
  final int stepObstacleDisplayScreen = 24;
  final int stepQuestionsSrl = 25;
  final int stepQuestionsLearningGoals2 = 26;
  final int stepVideo4 = 27;
  final int stepFinish = 28;

  final ExperimentService _experimentService;
  final DataService _dataService;
  final SettingsService _settingsService;

  LexicalDecisionTaskViewModel ldtvm;

  int step = 0;
  bool _consented = false;

  bool get consented => _consented;

  set consented(bool consented) {
    _consented = consented;
    notifyListeners();
  }

  String _cabuuLinkUserName = "";
  String get cabuuLinkUserName => _cabuuLinkUserName;
  set cabuuLinkUserName(String cabuuLinkUserName) {
    _cabuuLinkUserName = cabuuLinkUserName;
    notifyListeners();
  }

  String _cabuuLinkEmail = "";
  String get cabuuLinkEmail => _cabuuLinkEmail;
  set cabuuLinkEmail(String cabuuLinkEmail) {
    _cabuuLinkEmail = cabuuLinkEmail;
    notifyListeners();
  }

  bool videoOneCompleted = false;
  bool videoTwoCompleted = false;
  bool videoThreeCompleted = false;
  Assessment lastAssessment = Assessment();
  Map<String, String> currentAssessmentResults = {};
  String numberOfDaysLearningGoal = "";
  String overcomeObstacleText;
  // Map<AssessmentTypes, Map<String, String>> assessmentResults = {};

  List<Obstacle> selectedObstacles = <Obstacle>[];
  List<Outcome> selectedOutcomes = <Outcome>[];

  var obstacles = <Obstacle>[
    Obstacle(
        name: "Überforderung",
        description: "Das Vokabellernen fällt mir sehr schwer.",
        iconPath: AppAssetPaths.ICON_MATH),
    Obstacle(
        name: "Konzentration",
        description: "Ich kann mich nicht auf das Vokabellernen konzentrieren.",
        iconPath: AppAssetPaths.ICON_BRAIN),
    Obstacle(
        name: "Lustlosigkeit",
        description: "Ich habe keine Lust, Vokabeln zu lernen.",
        iconPath: AppAssetPaths.ICON_COMPUTER),
    Obstacle(
        name: "Ablenkungen",
        description: "Ich habe keine Zeit, Vokabeln zu lernen.",
        iconPath: AppAssetPaths.ICON_EDUCATION),
    Obstacle(
        name: "Vergessen",
        description: "Ich vergesse, dass ich Vokabeln lernen sollte.",
        iconPath: AppAssetPaths.ICON_ANATOMY),
    Obstacle(
        name: "Multitasking",
        description: "Ich mache beim Lernen andere Sachen (z.B. Fernsehen).",
        iconPath: AppAssetPaths.ICON_TEACHER),
  ];

  var outcomes = <Outcome>[
    Outcome(
        name: "Stolz anderer",
        description:
            "Dann sind andere Personen (z.B. meine Eltern) stolz auf mich.",
        iconPath: AppAssetPaths.ICON_MATH),
    Outcome(
        name: "Mein Stolz",
        description: "Dann bin ich selbst stolz auf mich.",
        iconPath: AppAssetPaths.ICON_MEHAPPY),
    Outcome(
        name: "Kommunikation",
        description:
            "Dann kann ich mich besser mit anderen Menschen verständigen.",
        iconPath: AppAssetPaths.ICON_USER),
    Outcome(
        name: "Lieder",
        description: "Dann kann ich meine Lieblingslieder besser verstehen.",
        iconPath: AppAssetPaths.ICON_MUSICNOTE),
    Outcome(
        name: "Videospiele",
        description: "Dann kann ich meine Videospiele besser verstehen.",
        iconPath: AppAssetPaths.ICON_GAMEPAD),
    Outcome(
        name: "Job",
        description:
            "Dann kriege ich einen besseren Job, wenn ich mit der Schule fertig bin.",
        iconPath: AppAssetPaths.ICON_TEAMWORK),
  ];

  InitSessionViewModel(
      this._dataService, this._experimentService, this._settingsService);

  int getPreviouslyCompletedStep() {
    // Add one to the value because we are retrieving the completed step and we want to navigate to the one after that
    var nextStep = _settingsService.getInitSessionStep() + 1;

    if (step == stepFinish) {
      // TODO: SKIP TUTORIAL COMPLETELY
      submit();
    }
    return nextStep;
  }

  outcomeSelected(Outcome outcome) {
    if (selectedOutcomes.contains(outcome)) {
      selectedOutcomes.remove(outcome);
    } else {
      selectedOutcomes.add(outcome);
    }

    notifyListeners();
  }

  insertLearningGoalIntoAssessment(Assessment assessment, replacementValue) {
    if (replacementValue == null) return;
    for (var item in assessment.items) {
      item.title = item.title.replaceAll("X", replacementValue);
    }
  }

  Future<Assessment> getAssessment(AssessmentTypes assessmentType) async {
    String name = describeEnum(assessmentType);
    Assessment assessment = await _dataService.getAssessment(name);
    if (assessmentType == AssessmentTypes.learningGoals1 ||
        assessmentType == AssessmentTypes.learningGoals2) {
      insertLearningGoalIntoAssessment(assessment, numberOfDaysLearningGoal);
    }
    return assessment;
  }

  obstacleSelected(Obstacle obstacle) {
    if (selectedObstacles.contains(obstacle)) {
      selectedObstacles.remove(obstacle);
    } else {
      selectedObstacles.add(obstacle);
    }

    notifyListeners();
  }

  @override
  bool canMoveNext(Key currentPageKey) {
    if (currentPageKey == ValueKey(stepVideo1) ||
        currentPageKey == ValueKey(stepVideo2) ||
        currentPageKey == ValueKey(stepVideo3) ||
        currentPageKey == ValueKey(stepVideo4)) {
      return true;
    }
    if (currentPageKey == ValueKey(stepLdt00) ||
        currentPageKey == ValueKey(stepLdt01) ||
        currentPageKey == ValueKey(stepLdt02) ||
        currentPageKey == ValueKey(stepLdt03) ||
        currentPageKey == ValueKey(stepLdt04) ||
        currentPageKey == ValueKey(stepLdt05)) {
      if (ldtvm != null) {
        return ldtvm.done;
      } else {
        return false;
      }
    }

    if (currentPageKey == ValueKey(stepQuestionsCabuuLearn) ||
        currentPageKey == ValueKey(stepQuestionsRegulation) ||
        currentPageKey == ValueKey(stepQuestionsLearningGoals1) ||
        currentPageKey == ValueKey(stepQuestionsSrl) ||
        currentPageKey == ValueKey(stepQuestionsLearningGoals2)) {
      print("Last assessment: ${lastAssessment.id}");
      return isAssessmentFilledOut(lastAssessment);
    }

    if (currentPageKey == ValueKey(stepOutcomeSelectionScreen)) {
      return selectedOutcomes.length > 0;
    }
    if (currentPageKey == ValueKey(stepObstacleSelectionScreen)) {
      return selectedObstacles.length > 0;
    }
    if (currentPageKey == ValueKey(stepCabuuLink)) {
      return consented &&
          (cabuuLinkUserName.isNotEmpty || cabuuLinkEmail.isNotEmpty);
    }
    if (currentPageKey == ValueKey(stepInitialDailyLearningGoal)) {
      return numberOfDaysLearningGoal.isNotEmpty;
    }

    return true;
  }

  @override
  bool canMoveBack(Key currentStep) {
    return true;
  }

  saveSelected() async {
    await _dataService.saveSelectedOutcomes(selectedOutcomes);
    await _dataService.saveSelectedObstacles(selectedObstacles);
  }

  editCustomObstacle(String key, String text) {
    var contains = selectedObstacles.where((o) => o.name == key);
    if (contains.isEmpty) {
      var custom = Obstacle(
          name: key,
          description: text,
          isSelected: true,
          iconPath: AppAssetPaths.ICON_PROBLEMSOLVING);
      selectedObstacles.add(custom);
    } else {
      var custom = selectedObstacles.firstWhere((o) => o.name == key);
      custom.description = text;
    }

    notifyListeners();
  }

  editCustomOutcome(String key, String text) {
    var contains = selectedOutcomes.where((o) => o.name == key);
    if (contains.isEmpty) {
      var custom = Outcome(
          name: key,
          description: text,
          isSelected: true,
          iconPath: AppAssetPaths.ICON_MEHAPPY);
      selectedOutcomes.add(custom);
    } else {
      var custom = selectedOutcomes.firstWhere((o) => o.name == key);
      custom.description = text;
    }
  }

  getNextPage(Key currentPageKey) {
    print("Step is $step");

    if (currentPageKey == ValueKey(stepObstacleSortingScreen)) {
      _dataService.saveObstacles(selectedObstacles);
    }
    if (currentPageKey == ValueKey(stepOutcomeSortingScreen)) {
      _dataService.saveOutcomes(selectedOutcomes);
    }
    if (currentPageKey == ValueKey(stepQuestionsCabuuLearn) ||
        currentPageKey == ValueKey(stepQuestionsRegulation) ||
        currentPageKey == ValueKey(stepQuestionsLearningGoals1) ||
        currentPageKey == ValueKey(stepQuestionsSrl) ||
        currentPageKey == ValueKey(stepQuestionsLearningGoals2)) {
      var result = AssessmentResult(
          currentAssessmentResults, lastAssessment.id, DateTime.now());
      _dataService.saveAssessment(result);
    }

    if (currentPageKey == ValueKey(stepInitialDailyLearningGoal)) {
      _dataService.saveInitialSessionValue(
          "dailyLearningGoal", numberOfDaysLearningGoal);
    }

    if (currentPageKey == ValueKey(stepLdt00) ||
        currentPageKey == ValueKey(stepLdt01) ||
        currentPageKey == ValueKey(stepLdt02) ||
        currentPageKey == ValueKey(stepLdt03) ||
        currentPageKey == ValueKey(stepLdt04) ||
        currentPageKey == ValueKey(stepLdt05)) {
      _dataService.saveLdtData(ldtvm.ldt);
      ldtvm = null;
    }

    if (currentPageKey == ValueKey(stepCabuuLink)) {
      var hashedUsername =
          md5.convert(utf8.encode(_cabuuLinkUserName)).toString();
      _dataService.saveInitialSessionValue("cabuuUsername", hashedUsername);
      var hashedEmail = md5.convert(utf8.encode(_cabuuLinkEmail)).toString();
      _dataService.saveInitialSessionValue("cabuuMail", hashedEmail);
    }

    _dataService.saveInitialSessionStepCompleted(step);
    return step + 1;
  }

  setAssessmentResult(String assessmentType, String itemId, String value) {
    currentAssessmentResults[itemId] = value;

    notifyListeners();
  }

  submit() async {
    _experimentService.nextScreen(RouteNames.INIT_START);
  }

  Future<bool> initTrial(String trialName) async {
    ldtvm = new LexicalDecisionTaskViewModel(trialName, _experimentService);
    await ldtvm.init();
    notifyListeners();
    return true;
  }

  String getTrialMessage(ValueKey ldtKey) {
    var keyValue = ldtKey.value;
    var results = ldtvm.ldt.trials;

    var msgGood = "Gut gemacht! Zur Sicherheit üben wir das noch einmal.";
    var msgSlow =
        "Da warst du leider nicht immer schnell genug. Denk daran, dass du die richtige Taste so schnell wie möglich drücken sollst! Wir üben das noch einmal.";
    var msgIncorrect =
        "Du hast leider nicht immer richtig gedrückt. Denk daran, dass du bei einem echten Wort die Taste 'ja' drücken sollst und bei einem unechten Wort die Taste 'nein' Wir üben das noch einmal.";

    var slow = false;
    var incorrect = false;
    var msg = "";
    if (keyValue == stepLdt00 || keyValue == stepLdt01) {
      for (var i = 0; i < results.length; i++) {
        var result = results[i];
        if (result.selection == -1) {
          return msgSlow;
        }
        if (result.selection != ldtvm.ldt.correctValues[i]) {
          return msgIncorrect;
        }
      }
    }

    if (keyValue == stepLdt02) {
      return "Sehr gut gemacht! Das war der erste richtige Durchlauf. Es kommen noch drei weitere.";
    }
    if (keyValue == stepLdt03) {
      return "Super! Noch zwei mal.";
    }
    if (keyValue == stepLdt04) {
      return "Hervorragend! Einmal musst du die Wortaufgabe noch machen.";
    }
    if (keyValue == stepLdt05) {
      return "Fantastisch! Das war jetzt erstmal die letzte Wortaufgabe für ein paar Tage. Wenn in ein paar Tagen dann die nächste kommt, wird die auch viel kürzer sein.";
    }
    return "";
  }

  onVideoCompleted(String url) {}

  setConsentedValue(bool value) {
    consented = value;
    notifyListeners();
  }

  setNumberOfDaysLearningGoal(String value) {
    numberOfDaysLearningGoal = value;
    notifyListeners();
  }
}
