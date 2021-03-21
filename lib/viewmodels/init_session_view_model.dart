import 'package:flutter/foundation.dart';
import 'package:serene/models/assessment.dart';
import 'package:serene/models/obstacle.dart';
import 'package:serene/models/outcome.dart';
import 'package:serene/screens/initialsession/cabuu_link_screen.dart';
import 'package:serene/screens/initialsession/initial_ldt_screen.dart';
import 'package:serene/screens/initialsession/obstacle_selection_screen.dart';
import 'package:serene/screens/initialsession/obstacle_sorting_screen.dart';
import 'package:serene/screens/initialsession/outcome_selection_screen.dart';
import 'package:serene/screens/initialsession/outcome_sorting_screen.dart';
import 'package:serene/screens/initialsession/video_screen.dart';
import 'package:serene/screens/initialsession/welcome_screen.dart';
import 'package:serene/services/data_service.dart';
import 'package:serene/services/experiment_service.dart';
import 'package:serene/shared/app_asset_paths.dart';
import 'package:serene/shared/enums.dart';
import 'package:serene/viewmodels/base_view_model.dart';
import 'package:serene/viewmodels/lexical_decision_task_view_model.dart';

class InitSessionViewModel extends BaseViewModel {
  final ExperimentService _experimentService;
  final DataService _dataService;
  LexicalDecisionTaskViewModel ldtvm;

  Type currentPageType;

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

  bool videoOneCompleted = false;
  bool videoTwoCompleted = false;
  bool videoThreeCompleted = false;
  AssessmentTypes lastAssessment = AssessmentTypes.cabuuLearn;
  String numberOfDaysLearningGoal;
  String overcomeObstacleText;
  Map<AssessmentTypes, Map<String, String>> assessmentResults = {};

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

  InitSessionViewModel(this._dataService, this._experimentService) {
    assessmentResults[AssessmentTypes.cabuuLearn] = {};
    assessmentResults[AssessmentTypes.regulation] = {};
    assessmentResults[AssessmentTypes.learningGoals1] = {};
    assessmentResults[AssessmentTypes.srl] = {};
    assessmentResults[AssessmentTypes.learningGoals2] = {};
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

  Future<Assessment> getAssessment(AssessmentTypes assessmentName) async {
    String name = describeEnum(assessmentName);
    Assessment assessment = await _dataService.getAssessment(name);
    if (assessmentName == AssessmentTypes.learningGoals1 ||
        assessmentName == AssessmentTypes.learningGoals2) {
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

  bool canMoveNext() {
    // TODO: Use actual logic
    if (currentPageType == WelcomeScreen) {
      return true;
    }
    if (currentPageType == VideoScreen) {
      return true;
    }
    if (currentPageType == InitialLdtScreen) {
      if (ldtvm != null) {
        return ldtvm.done;
      } else {
        return false;
      }
    }
    if (currentPageType == OutcomeSelectionScreen) {
      return selectedOutcomes.length > 0;
    }
    if (currentPageType == ObstacleSelectionScreen) {
      return selectedObstacles.length > 0;
    }

    if (currentPageType == CabuuLinkScreen) {
      return consented && cabuuLinkUserName.isNotEmpty;
    }

    return true;
  }

  bool canMoveBack() {
    return false;
    // return (step == 1 || step == 2 || step == 4 || step == 5);
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
          iconPath: AppAssetPaths.ICON_PROBLEMSOLVING);
      selectedObstacles.add(custom);
    } else {
      var custom = selectedObstacles.firstWhere((o) => o.name == key);
      custom.description = text;
    }

    // notifyListeners();
  }

  editCustomOutcome(String key, String text) {
    var contains = selectedOutcomes.where((o) => o.name == key);
    if (contains.isEmpty) {
      var custom = Outcome(
          name: key,
          description: text,
          iconPath: AppAssetPaths.ICON_PROBLEMSOLVING);
      selectedOutcomes.add(custom);
    } else {
      var custom = selectedOutcomes.firstWhere((o) => o.name == key);
      custom.description = text;
    }
  }

  getNextPage() {
    print("Step is $step");

    // if (step == 1 && selectedOutcomes.length <= 1) {
    //   return step + 2;
    // }
    // if (step == 4 && selectedObstacles.length <= 1) {
    //   return step + 2;
    // }
    if (currentPageType == ObstacleSortingScreen) {
      _dataService.saveObstacles(obstacles);
    }
    if (currentPageType == OutcomeSortingScreen) {
      _dataService.saveOutcomes(outcomes);
    }
    _dataService.saveInitialSessionStepCompleted(step);
    return step + 1;
  }

  setAssessmentResult(
      AssessmentTypes assessmentType, String itemId, String value) {
    // TODO: SET ASSESSMENT RESULT
    // results[id] = value;
    assessmentResults[assessmentType][itemId] = value;

    notifyListeners();
  }

  submit() async {}

  Future<bool> initTrial(String trialName) async {
    ldtvm = new LexicalDecisionTaskViewModel(trialName, _experimentService);
    await ldtvm.init();
    return true;
  }

  String getTrialMessage() {
    var results = ldtvm.ldt.trials;

    for (var i = 0; i < results.length; i++) {
      var result = results[i];
      if (result.selection == -1) {
        return "Da warst du leider nicht immer schnell genug. Denk daran, dass du die richtige Taste so schnell wie möglich drücken sollst! Wir üben das noch einmal.";
      }
      if (result.selection != ldtvm.ldt.correctValues[i]) {
        return "Da hast leider nicht immer richtig gedrückt. Denk daran, dass du bei einem echten Wort die Taste 'ja' drücken sollst und bei einem unechten Wort die Taste 'nein' Wir üben das noch einmal.";
      }
    }

    return "Gut gemacht! Zur Sicherheit üben wir das noch einmal.";
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

  setCurrentPageType(Type current) {
    currentPageType = current;
    print(current);
  }
}
