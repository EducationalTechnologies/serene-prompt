import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:prompt/models/assessment.dart';
import 'package:prompt/models/assessment_result.dart';
import 'package:prompt/models/obstacle.dart';
import 'package:prompt/models/outcome.dart';
import 'package:prompt/services/data_service.dart';
import 'package:prompt/services/experiment_service.dart';
import 'package:prompt/services/reward_service.dart';
import 'package:prompt/shared/app_asset_paths.dart';
import 'package:prompt/shared/enums.dart';
import 'package:prompt/shared/route_names.dart';
import 'package:prompt/viewmodels/lexical_decision_task_view_model.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:prompt/viewmodels/multi_step_assessment_view_model.dart';

enum STEP {
  welcomeScreen,
  videoWelcome,
  cabuuLink,
  questionsItLiteracy,
  questionsCabuuLearn,
  rewardFirst,
  videoLearning,
  initialDailyLearningGoal,
  questionsLearningGoals1,
  questionsRegulation,
  outcomeExplanationScreen,
  outcomeSelectionScreen,
  outcomeEnterScreen,
  outcomeSortingScreen,
  outcomeDisplayScreen,
  obstacleExplanationScreen,
  obstacleSelectionScreen,
  obstacleEnterScreen,
  obstacleSortingScreen,
  obstacleDisplayScreen,
  questionsLearningGoals2,
  videoLdtInstruction,
  ldt00,
  ldt01,
  rewardSecond,
  questionsSrl,
  videoFinish,
}

class InitSessionViewModel extends MultiStepAssessmentViewModel {
  final ExperimentService _experimentService;
  final DataService _dataService;
  final RewardService _rewardService;

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

  bool _videoWelcomeCompleted = false;
  void videoWelcomeCompleted() {
    _videoWelcomeCompleted = true;
    notifyListeners();
  }

  bool _videoLearningInstructionsCompleted = false;
  void videoLearningInstructionsCompleted() {
    _videoLearningInstructionsCompleted = true;
    notifyListeners();
  }

  bool _videoLdtCompleted = false;
  void videoLdtCompleted() {
    _videoLdtCompleted = true;
    notifyListeners();
  }

  bool _videoFinishCompleted = false;
  void videoFinishCompleted() {
    _videoFinishCompleted = true;
    notifyListeners();
  }

  Assessment lastAssessment = Assessment();
  Map<String, String> currentAssessmentResults = {};
  String numberOfDaysLearningGoal = "";
  String _overcomeObstacleText = "";

  String get overcomeObstacleText => _overcomeObstacleText;

  set overcomeObstacleText(String overcomeObstacleText) {
    _overcomeObstacleText = overcomeObstacleText;
    notifyListeners();
  }

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
      this._dataService, this._experimentService, this._rewardService);

  int getPreviouslyCompletedStep() {
    return 0;
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
    if (currentPageKey == ValueKey(STEP.videoWelcome)) {
      return _videoWelcomeCompleted;
    }
    if (currentPageKey == ValueKey(STEP.videoLdtInstruction)) {
      return _videoLdtCompleted;
    }
    if (currentPageKey == ValueKey(STEP.videoLearning)) {
      return _videoLearningInstructionsCompleted;
    }
    if (currentPageKey == ValueKey(STEP.videoFinish)) {
      return _videoFinishCompleted;
    }
    if (currentPageKey == ValueKey(STEP.ldt00) ||
        currentPageKey == ValueKey(STEP.ldt01)) {
      if (ldtvm != null) {
        return ldtvm.done;
      } else {
        return false;
      }
    }

    if (currentPageKey == ValueKey(STEP.questionsCabuuLearn) ||
        currentPageKey == ValueKey(STEP.questionsRegulation) ||
        currentPageKey == ValueKey(STEP.questionsLearningGoals1) ||
        currentPageKey == ValueKey(STEP.questionsSrl) ||
        currentPageKey == ValueKey(STEP.questionsItLiteracy) ||
        currentPageKey == ValueKey(STEP.questionsLearningGoals2)) {
      print("Last assessment: ${lastAssessment.id}");
      return isAssessmentFilledOut(lastAssessment);
    }

    if (currentPageKey == ValueKey(STEP.outcomeSelectionScreen)) {
      return selectedOutcomes.length > 0;
    }
    if (currentPageKey == ValueKey(STEP.obstacleSelectionScreen)) {
      return selectedObstacles.length > 0;
    }
    if (currentPageKey == ValueKey(STEP.cabuuLink)) {
      var isEmail = EmailValidator.validate(cabuuLinkEmail);
      return consented &&
          (cabuuLinkUserName.isNotEmpty || cabuuLinkEmail.isNotEmpty) &&
          isEmail;
    }
    if (currentPageKey == ValueKey(STEP.initialDailyLearningGoal)) {
      return numberOfDaysLearningGoal.isNotEmpty;
    }
    if (currentPageKey == ValueKey(STEP.obstacleDisplayScreen)) {
      return overcomeObstacleText.isNotEmpty;
    }

    return true;
  }

  @override
  bool canMoveBack(Key currentStep) {
    return false;
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

  getNextPage(ValueKey currentPageKey) {
    print("Step is $step");

    nextButtonText = "Weiter";

    if (currentPageKey == ValueKey(STEP.obstacleSortingScreen)) {
      _dataService.saveObstacles(selectedObstacles);
    }
    if (currentPageKey == ValueKey(STEP.outcomeSortingScreen)) {
      _dataService.saveOutcomes(selectedOutcomes);
    }
    if (currentPageKey == ValueKey(STEP.questionsCabuuLearn) ||
        currentPageKey == ValueKey(STEP.questionsItLiteracy) ||
        currentPageKey == ValueKey(STEP.questionsRegulation) ||
        currentPageKey == ValueKey(STEP.questionsLearningGoals1) ||
        currentPageKey == ValueKey(STEP.questionsSrl) ||
        currentPageKey == ValueKey(STEP.questionsLearningGoals2)) {
      var result = AssessmentResult(
          currentAssessmentResults, lastAssessment.id, DateTime.now());
      _dataService.saveAssessment(result);
    }

    if (currentPageKey == ValueKey(STEP.initialDailyLearningGoal)) {
      var result = AssessmentResult(
          {"initialDailyLearningGoal": numberOfDaysLearningGoal},
          "initialDailyLearningGoal",
          DateTime.now());
      _dataService.saveAssessment(result);
    }

    if (currentPageKey == ValueKey(STEP.obstacleDisplayScreen)) {
      var result = AssessmentResult(
          {"overcomeObstaclePlan": overcomeObstacleText},
          "initialOvercomeObstaclePlan",
          DateTime.now());
      _dataService.saveAssessment(result);
    }

    if (currentPageKey == ValueKey(STEP.ldt00) ||
        currentPageKey == ValueKey(STEP.ldt01)) {
      _dataService.saveLdtData(ldtvm.ldt);
      ldtvm = null;
    }
    // Give rewards after the two long LDTs
    if (currentPageKey == ValueKey(STEP.questionsLearningGoals1) ||
        currentPageKey == ValueKey(STEP.ldt01)) {
      _rewardService.onLdtInitialLongLdtFinished();
    }

    if (currentPageKey == ValueKey(STEP.cabuuLink)) {
      var hashedUsername =
          md5.convert(utf8.encode(_cabuuLinkUserName)).toString();
      _dataService.saveInitialSessionValue("cabuuUsername", hashedUsername);
      var hashedEmail = md5.convert(utf8.encode(_cabuuLinkEmail)).toString();
      _dataService.saveInitialSessionValue("cabuuMail", hashedEmail);
    }

    // the pages AFTER which the button should be changed to START
    if (currentPageKey == ValueKey(STEP.questionsLearningGoals2) ||
        currentPageKey == ValueKey(STEP.videoLdtInstruction)) {
      nextButtonText = "Start";
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

    var msgSlow =
        "Da warst du leider nicht immer schnell genug. Denk daran, dass du die richtige Taste so schnell wie möglich drücken sollst! Wir üben das noch einmal.";
    var msgIncorrect =
        "Du hast leider nicht immer richtig gedrückt. Denk daran, dass du bei einem echten Wort die Taste 'ja' drücken sollst und bei einem unechten Wort die Taste 'nein' Wir üben das noch einmal.";

    if (keyValue == STEP.ldt00) {
      for (var i = 0; i < results.length; i++) {
        var result = results[i];
        if (result.selection == -1) {
          return msgSlow;
        }
        if (result.selection != ldtvm.ldt.correctValues[i]) {
          return msgIncorrect;
        }
      }
      return "Gut gemacht! Zur Sicherheit üben wir das noch einmal.";
    }
    if (keyValue == STEP.ldt01) {
      return "Gut gemacht!";
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
