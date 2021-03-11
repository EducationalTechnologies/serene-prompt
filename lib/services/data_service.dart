import 'dart:async';
import 'dart:convert';
import 'package:csv/csv_settings_autodetection.dart';
import 'package:flutter/services.dart';
import 'package:serene/models/assessment.dart';
import 'package:serene/models/assessment_result.dart';
import 'package:serene/models/assessment_item.dart';
import 'package:serene/models/internalisation.dart';
import 'package:serene/models/ldt_data.dart';
import 'package:serene/models/obstacle.dart';
import 'package:serene/models/outcome.dart';
import 'package:serene/models/recall_task.dart';
import 'package:serene/models/user_data.dart';
import 'package:serene/services/firebase_service.dart';
import 'package:serene/services/user_service.dart';
import 'package:csv/csv.dart';

enum CachedValues { goals, internalisations }

class DataService {
  List<dynamic> _ldtTaskListCache = [];
  List<dynamic> _ldtListStrings = [];
  List<String> _planCache = [];
  UserService _userService;
  FirebaseService _databaseService;
  int score;

  Map<CachedValues, bool> _dirtyFlags = {
    CachedValues.goals: true,
    CachedValues.internalisations: true
  };

  UserData _userDataCache;

  DataService(this._databaseService, this._userService);

  getCachedValue(CachedValues value) {
    switch (value) {
      case CachedValues.goals:
        // TODO: Handle this case.
        break;
      case CachedValues.internalisations:
        // TODO: Handle this case.
        break;
    }
  }

  clearCache() {
    this._planCache.clear();
    this._ldtTaskListCache.clear();
  }

  saveAssessment(AssessmentResult assessment) async {
    await _databaseService.saveAssessment(
        assessment, _userService.getUserEmail());
  }

  Future<AssessmentResult> getLastSubmittedAssessment(
      String assessmentType) async {
    return await _databaseService.getLastSubmittedAssessment(
        assessmentType, _userService.getUserEmail());
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
    for (var primeTarget in trialData) {
      ldt.primes.add(primeTarget[0]);
      ldt.targets.add(primeTarget[1]);
      ldt.correctValues.add(primeTarget[2]);
    }

    //initialize the trial data now so that less objects have to be created during the trial
    ldt.trials = [];

    for (var word in ldt.targets) {
      var ldtTrialWord = LdtTrial(condition: "", target: word);
      ldt.trials.add(ldtTrialWord);
    }

    return ldt;
  }

  saveSelectedOutcomes(List<Outcome> outcomes) async {
    return await _databaseService.saveOutcomes(
        outcomes, _userService.getUserEmail());
  }

  saveSelectedObstacles(List<Obstacle> obstacles) async {
    return await _databaseService.saveObstacles(
        obstacles, _userService.getUserEmail());
  }

  Future<int> getNumberOfCompletedInternalisations() async {
    return await _databaseService
        .getNumberOfInternalisations(_userService.getUserEmail());
  }

  getCurrentImplementationIntention() async {
    if (_planCache.length == 0) {
      String data = await rootBundle.loadString("assets/config/ldt_ii.json");
      for (var plan in jsonDecode(data)) {
        _planCache.add(plan["implementationIntention"]);
      }
    }
    var index =
        await getNumberOfCompletedInternalisations() % (_planCache.length - 1);
    var plan = _planCache[index];
    return plan;
  }

  saveInternalisation(Internalisation internalisation) async {
    return await _databaseService.saveInternalisation(
        internalisation, _userService.getUserEmail());
  }

  saveRecallTask(RecallTask recallTask) async {
    return await _databaseService.saveRecallTask(
        recallTask, _userService.getUserEmail());
  }

  Future<Internalisation> getFirstInternalisation() async {
    return await _databaseService
        .getFirstInternalisation(_userService.getUserEmail());
  }

  Future<Internalisation> getLastInternalisation() async {
    return await _databaseService
        .getLastInternalisation(_userService.getUserEmail());
  }

  Future<List<Internalisation>> getLastInternalisations(int number) async {
    return await _databaseService.getLastInternalisations(
        _userService.getUserEmail(), number);
  }

  Future<RecallTask> getLastRecallTask() async {
    return await _databaseService
        .getLastRecallTask(_userService.getUserEmail());
  }

  Future<UserData> getUserData() async {
    if (_userDataCache == null) {
      _userDataCache =
          await _databaseService.getUserData(_userService.getUserEmail());
    }
    return _userDataCache;
  }

  saveObstacles(List<Obstacle> obstacles) async {
    await _databaseService.saveObstacles(
        obstacles, _userService.getUserEmail());
  }

  saveOutcomes(List<Outcome> outcomes) async {
    await _databaseService.saveOutcomes(outcomes, _userService.getUserEmail());
  }

  saveConsent(bool consented) async {
    await _databaseService.saveConsent(_userService.getUserEmail(), consented);
  }

  saveLdtData(LdtData ldtData) async {
    await _databaseService.saveLdt(_userService.getUserEmail(), ldtData);
  }

  saveEmojiInternalisation(Internalisation internalisation) async {
    await _databaseService.saveEmojiInternalisation(
        _userService.getUserEmail(), internalisation);
  }

  Future<int> getScore() async {
    return await _databaseService.getScore(_userService.getUserEmail());
  }

  saveScore(int score) async {
    await _databaseService.saveScore(_userService.getUserEmail(), score);
  }

  logData(dynamic data) async {
    data["user"] = _userService.getUserEmail();
    await _databaseService.logEvent(_userService.getUserEmail(), data);
  }

  updateInternalisationConditionGroup(int group) async {
    await _databaseService.updateInternalisationConditionGroup(
        _userService.getUserEmail(), group);
    _userDataCache.internalisationCondition = group;
  }

  Future<DateTime> getDateOfLastLDT() async {
    return await _databaseService
        .getLastLdtTaskDate(_userService.getUserEmail());
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
}
