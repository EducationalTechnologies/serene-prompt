import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:csv/csv_settings_autodetection.dart';
import 'package:flutter/services.dart';
import 'package:prompt/locator.dart';
import 'package:prompt/models/assessment.dart';
import 'package:prompt/models/assessment_result.dart';
import 'package:prompt/models/assessment_item.dart';
import 'package:prompt/models/internalisation.dart';
import 'package:prompt/models/ldt_data.dart';
import 'package:prompt/models/obstacle.dart';
import 'package:prompt/models/outcome.dart';
import 'package:prompt/models/recall_task.dart';
import 'package:prompt/models/user_data.dart';
import 'package:prompt/services/firebase_service.dart';
import 'package:prompt/services/local_database_service.dart';
import 'package:prompt/services/settings_service.dart';
import 'package:prompt/services/user_service.dart';
import 'package:csv/csv.dart';
import 'package:prompt/shared/enums.dart';
import 'package:prompt/shared/experiment_constants.dart';

enum CachedValues { goals, internalisations }

class DataService {
  List<dynamic> _ldtTaskListCache = [];
  List<Internalisation> _planCache = [];
  final UserService _userService;
  final FirebaseService _databaseService;
  final LocalDatabaseService _localDatabaseService;
  int score;

  UserData _userDataCache;
  RecallTask _lastRecallTask;

  DataService(
      this._databaseService, this._userService, this._localDatabaseService);

  Future<bool> checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }

    return true;
  }

  clearCache() {
    this._planCache.clear();
    this._ldtTaskListCache.clear();
  }

  getUsername() {
    return _userService.getUsername();
  }

  saveAssessment(AssessmentResult assessment) async {
    await _databaseService.saveAssessment(
        assessment, _userService.getUsername());
  }

  Future<AssessmentResult> getLastSubmittedAssessment(
      String assessmentType) async {
    return await _databaseService.getLastSubmittedAssessment(
        assessmentType, _userService.getUsername());
  }

  _getLdtTrialByName(String trial) async {
    var csvSettingsDetector =
        new FirstOccurrenceSettingsDetector(eols: ['\r\n', '\n']);
    String data = await rootBundle.loadString("assets/ldt/$trial.csv");

    var values = CsvToListConverter(csvSettingsDetector: csvSettingsDetector)
        .convert(data, fieldDelimiter: ",");
    // var rowList = CsvToLis
    print(values);
    return values;
  }

  Future<LdtData> getLdtData(String trialName) async {
    var trialData = await _getLdtTrialByName(trialName);

    var ldt = LdtData();

    //initialize the trial data now so that less objects have to be created during the trial
    ldt.trials = [];

    for (var primeTarget in trialData) {
      ldt.primes.add(primeTarget[0]);
      ldt.targets.add(primeTarget[1]);
      ldt.correctValues.add(primeTarget[2]);

      var ldtTrialWord = LdtTrial(
          condition: primeTarget[2].toString(), target: primeTarget[1]);
      ldt.trials.add(ldtTrialWord);
    }

    return ldt;
  }

  saveSelectedOutcomes(List<Outcome> outcomes) async {
    return await _databaseService.saveOutcomes(
        outcomes, _userService.getUsername());
  }

  saveSelectedObstacles(List<Obstacle> obstacles) async {
    return await _databaseService.saveObstacles(
        obstacles, _userService.getUsername());
  }

  Future<int> getNumberOfCompletedInternalisations() async {
    return await _databaseService
        .getNumberOfInternalisations(_userService.getUsername());
  }

  Future<Internalisation> getCurrentInternalisation(int number) async {
    if (_planCache.length == 0) {
      for (var plan in PLANS) {
        var internalisation =
            Internalisation(plan: plan["plan"], planId: plan["planId"]);
        _planCache.add(internalisation);
      }
    }
    var plan = _planCache[number];
    return plan;
  }

  saveInternalisation(Internalisation internalisation) async {
    return await _databaseService.saveInternalisation(
        internalisation, _userService.getUsername());
  }

  saveRecallTask(RecallTask recallTask) async {
    _lastRecallTask = recallTask;
    return await _databaseService.saveRecallTask(
        recallTask, _userService.getUsername());
  }

  Future<RecallTask> getLastRecallTask() async {
    if (_lastRecallTask == null) {
      _lastRecallTask =
          await _databaseService.getLastRecallTask(_userService.getUsername());
    }
    return _lastRecallTask;
  }

  Future<Internalisation> getFirstInternalisation() async {
    return await _databaseService
        .getFirstInternalisation(_userService.getUsername());
  }

  Future<Internalisation> getLastInternalisation() async {
    return await _databaseService
        .getLastInternalisation(_userService.getUsername());
  }

  Future<List<Internalisation>> getLastInternalisations(int number) async {
    return await _databaseService.getLastInternalisations(
        _userService.getUsername(), number);
  }

  Future<UserData> getUserData() async {
    var username = _userService.getUsername();
    if (username == null) return null;
    if (username.isEmpty) return null;
    if (_userDataCache == null) {
      _userDataCache = await _databaseService.getUserData(username);
    }
    return _userDataCache;
  }

  saveObstacles(List<Obstacle> obstacles) async {
    await _databaseService.saveObstacles(obstacles, _userService.getUsername());
  }

  saveOutcomes(List<Outcome> outcomes) async {
    await _databaseService.saveOutcomes(outcomes, _userService.getUsername());
  }

  saveConsent(bool consented) async {
    await _databaseService.saveConsent(_userService.getUsername(), consented);
  }

  saveLdtData(LdtData ldtData) async {
    await _databaseService.saveLdt(_userService.getUsername(), ldtData);
  }

  saveEmojiInternalisation(Internalisation internalisation) async {
    await _databaseService.saveEmojiInternalisation(
        _userService.getUsername(), internalisation);
  }

  Future<int> getScore() async {
    if (_userService.getUsername() == null) return 0;
    if (_userService.getUsername().isEmpty) return 0;

    return getUserData().then((userData) {
      if (userData == null)
        return 0;
      else
        return userData.score;
    });
  }

  saveScore(int score) async {
    var ud = await getUserData();
    ud.score = score;
    await _databaseService.saveScore(_userService.getUsername(), score);
  }

  Future<int> getDaysActive() async {
    var userData = await getUserData();
    if (userData == null) return 0;
    return userData.daysActive;
  }

  saveDaysActive(int daysActive) async {
    var ud = await getUserData();
    ud.daysActive = daysActive;
    await _databaseService.saveDaysAcive(
        _userService.getUsername(), daysActive);
  }

  logData(dynamic data) async {
    data["userid"] = _userService.getUsername();
    await _databaseService.logEvent(_userService.getUsername(), data);
  }

  updateInternalisationConditionGroup(int group) async {
    await _databaseService.updateInternalisationConditionGroup(
        _userService.getUsername(), group);
    var ud = await getUserData();
    ud.group = group;
  }

  Future<DateTime> getDateOfLastLDT() async {
    return await _databaseService
        .getLastLdtTaskDate(_userService.getUsername());
  }

  getAssessment(String name) async {
    String data =
        await rootBundle.loadString("assets/assessments/assessment_$name.json");
    var json = jsonDecode(data);

    var ass = Assessment();
    ass.id = json["id"];
    ass.title = json["title"];
    ass.items = [];
    for (var question in json["questions"]) {
      ass.items.add(AssessmentItemModel(question["questionText"],
          Map<String, String>.from(question["labels"]), question["id"]));
    }

    return ass;
  }

  getInitSessionSteps() async {
    return locator.get<SettingsService>().getInitSessionStep();
  }

  Future<void> saveInitialSessionValue(String key, dynamic value) async {
    await _databaseService.saveInitialSessionValue(
        _userService.getUsername(), key, value);
  }

  void saveInitialSessionStepCompleted(int step) async {
    await _databaseService.saveInitSessionStepCompleted(
        _userService.getUsername(), step);
  }

  Future<int> getCompletedInitialSessionStep() async {
    var step =
        await _databaseService.getMaxInitSession(_userService.getUsername());
    if (step == null) return 0;
    return step;
  }

  Future<void> setBackgroundImage(String imagePath) async {
    await _localDatabaseService.upsertSetting(
        SettingsKeys.backGroundImage, imagePath);
  }

  Future<String> getBackgroundImagePath() async {
    return await _localDatabaseService
        .getSettingsValue(SettingsKeys.backGroundImage);
  }

  Future<int> getStreakDays() async {
    var userData = await getUserData();
    return userData.streakDays;
  }

  Future<void> setStreakDays(int value) async {
    var ud = await getUserData();
    ud.streakDays = value;
    return await _databaseService.setStreakDays(
        _userService.getUsername(), value);
  }
}
