import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:csv/csv_settings_autodetection.dart';
import 'package:flutter/material.dart';
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
import 'package:prompt/services/experiment_service.dart';
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
  List<Internalisation> _lastInternalisationsCache = [];
  final UserService _userService;
  final FirebaseService _databaseService;
  final LocalDatabaseService _localDatabaseService;
  int score;

  UserData _userDataCache;
  RecallTask _lastRecallTask;
  DateTime _lastLdtDate;

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

  saveScrambleCorrections(List<String> corrections, int planId) async {
    var correction = {
      "corrections": corrections,
      "completionDate": DateTime.now().toIso8601String(),
      "user": _userService.getUsername(),
      "planId": planId
    };
    await _databaseService.saveScrambleCorrections(correction);
  }

  Future<int> getNumberOfCompletedInternalisations() async {
    var all = await getLastInternalisations(ExperimentService.STUDY_DURATION);
    if (all == null) return 0;
    return all.length;
  }

  Future<Internalisation> getCurrentInternalisation(int number) async {
    var plan = PLANS[number];
    var internalisation =
        Internalisation(plan: plan["plan"], planId: plan["planId"]);
    return internalisation;
  }

  saveInternalisation(Internalisation internalisation) async {
    // Insert the last one at the beginning since it is ordered from newest to oldest
    _lastInternalisationsCache.insert(0, internalisation);
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

  Future<List<Internalisation>> cacheAllInternalisations() async {
    return await getLastInternalisations(27);
  }

  Future<Internalisation> getLastInternalisation() async {
    // Since the app needs up to three last internalisations later on, we cache them here
    var all = await getLastInternalisations(27);
    if (all.length > 0) return all[0];
    return null;
  }

  Future<List<Internalisation>> getLastInternalisations(int number) async {
    if (_lastInternalisationsCache == null ||
        _lastInternalisationsCache.isEmpty) {
      _lastInternalisationsCache = await _databaseService
          .getLastInternalisations(_userService.getUsername(), number);
    }
    if (_lastInternalisationsCache == null) return [];

    var start = 0;
    var end = min(_lastInternalisationsCache.length, number);
    return _lastInternalisationsCache.sublist(start, end);
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
    _lastLdtDate = ldtData.completionDate;
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
    if (_userService.isSignedIn()) {
      await _databaseService.logEvent(_userService.getUsername(), data);
    }
  }

  Future<DateTime> getDateOfLastLDT() async {
    if (_lastLdtDate == null) {
      _lastLdtDate =
          await _databaseService.getLastLdtTaskDate(_userService.getUsername());
    }
    return _lastLdtDate;
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
    var userData = await getUserData();
    if (userData == null) return 0;
    return userData.initSessionStep;
  }

  Future<void> setBackgroundImage(String imagePath) async {
    await _localDatabaseService.upsertSetting(
        SettingsKeys.backGroundImage, imagePath);
  }

  Future<String> getBackgroundImagePath() async {
    return await _localDatabaseService
        .getSettingsValue(SettingsKeys.backGroundImage);
  }

  Future saveBackgroundGradientColors(List<Color> colors) async {
    var colorString = colors
        .map((e) => e.toString().split('(0x')[1].split(')')[0])
        .toList()
        .join(",");
    _localDatabaseService.upsertSetting(
        SettingsKeys.backgroundColors, colorString);
  }

  Future<bool> finalAssessmentCompleted() async {
    return await _databaseService.getLastAssessment(
            "finalQuestions", _userService.getUsername()) !=
        null;
  }

  Future<List<Color>> getBackgroundGradientColors() async {
    var colorString = await _localDatabaseService
        .getSettingsValue(SettingsKeys.backgroundColors);
    if (colorString != null) {
      List<String> colorStringList = colorString.split(",");
      var list =
          colorStringList.map((e) => Color(int.parse(e, radix: 16))).toList();

      return list;
    } else {
      return [Color(0xffffffff), Color(0xffffffff)];
    }
  }

  Future<int> getStreakDays() async {
    var userData = await getUserData();
    if (userData == null) return 0;
    return userData.streakDays;
  }

  Future<void> setStreakDays(int value) async {
    var ud = await getUserData();
    ud.streakDays = value;
    return await _databaseService.setStreakDays(
        _userService.getUsername(), value);
  }

  setRegistrationDate(DateTime dateTime) async {
    var ud = await getUserData();
    ud.registrationDate = dateTime;
    return await _databaseService.setRegistrationDate(
        _userService.getUsername(), dateTime.toIso8601String());
  }
}
