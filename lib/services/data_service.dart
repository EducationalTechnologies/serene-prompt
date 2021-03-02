import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:csv/csv_settings_autodetection.dart';
import 'package:flutter/services.dart';
import 'package:serene/models/assessment.dart';
import 'package:serene/models/assessment_item.dart';
import 'package:serene/models/goal.dart';
import 'package:serene/models/goal_shield.dart';
import 'package:serene/models/internalisation.dart';
import 'package:serene/models/ldt_data.dart';
import 'package:serene/models/obstacle.dart';
import 'package:serene/models/outcome.dart';
import 'package:serene/models/recall_task.dart';
import 'package:serene/models/user_data.dart';
import 'package:serene/services/firebase_service.dart';
import 'package:serene/services/local_database_service.dart';
import 'package:serene/services/user_service.dart';
import 'package:serene/shared/materialized_path.dart';
import 'package:csv/csv.dart';

enum CachedValues { goals, internalisations }

class DataService {
  List<Goal> _goalsCache = [];
  List<Goal> _openGoalsCache = [];
  List<dynamic> _ldtTaskListCache = [];
  List<dynamic> _ldtListStrings = [];
  List<GoalShield> _goalShields;
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

  get goals {
    return UnmodifiableListView(_goalsCache);
  }

  get openGoals {
    return UnmodifiableListView(_openGoalsCache);
  }

  Goal getGoalById(String id) {
    try {
      return _openGoalsCache.firstWhere((g) => g.id == id, orElse: null);
    } catch (error) {
      return null;
    }
  }

  clearCache() {
    this._openGoalsCache.clear();
    this._goalsCache.clear();
    this._planCache.clear();
    this._ldtTaskListCache.clear();
  }

  createGoal(Goal goal) async {
    if (goal.id.isEmpty) {
      throw new Exception("Goal does not have an ID");
    }

    _openGoalsCache.add(goal);
    await _databaseService.createGoal(goal, _userService.getUserEmail());
    if (goal.parentId.isNotEmpty) {
      var parentPath = getGoalById(goal.parentId).path;
      goal.path = MaterializedPath.addToPath(parentPath, goal.path);
    }
  }

  postToServer(Goal goal) async {
    print("Posting Goal to Server");

    var body = json.encode({
      "goal": goal.goalText,
      "start": goal.deadline?.toIso8601String(),
      "end": goal.deadline?.toIso8601String()
    });

    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);

    var url = "https://10.0.2.2:5001/api/LearningSession";

    try {
      var request = await client.postUrl(Uri.parse(url));
      request.headers.set("content-type", "application/json");
      request.add(utf8.encode(body));

      var response = await request.close();

      var reply = await response.transform(utf8.decoder).join();
      print(reply);
    } catch (e) {
      print("error in POST");
      print(e);
    }
  }

  getGoals() async {
    _goalsCache = await LocalDatabaseService.db.getGoals();
    return _goalsCache;
  }

  Future<List<Goal>> getOpenGoals() async {
    if (_openGoalsCache.length == 0) {
      var mail = _userService.getUserEmail();
      _openGoalsCache = await _databaseService.retrieveOpenGoals(mail);
    }
    return _openGoalsCache;
  }

  updateGoal(Goal goal) async {
    var goalIndex = _openGoalsCache.indexOf(goal);
    if (goalIndex >= 0) {
      if (goal.progress >= 100) {
        _openGoalsCache.removeAt(goalIndex);
      }
    }
    await _databaseService.updateGoal(goal, _userService.getUserEmail());
  }

  deleteGoal(Goal goal) async {
    var goalIndex = _openGoalsCache.indexOf(goal);
    if (goalIndex >= 0) {
      _openGoalsCache.removeAt(goalIndex);
    }
    await _databaseService.deleteGoal(goal, _userService.getUserEmail());
  }

  saveAssessment(AssessmentModel assessment) async {
    await _databaseService.saveAssessment(
        assessment, _userService.getUserEmail());
  }

  Future<AssessmentModel> getLastSubmittedAssessment(
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
    }

    //initialize the trial data now so that less objects have to be created during the trial
    ldt.trials = [];

    for (var word in ldt.targets) {
      var ldtTrialWord = LdtTrial(condition: "", target: word);
      ldt.trials.add(ldtTrialWord);
    }

    return ldt;
  }

  saveShielding(GoalShield shield) async {
    shield.submissionDate = DateTime.now();
    return await _databaseService.saveShielding(
        shield, _userService.getUserEmail());
  }

  Future<GoalShield> getLastGoalShield() async {
    return await _databaseService
        .getLastSubmittedGoalShield(_userService.getUserEmail());
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
    var title = json["title"];
    var id = json["id"];
    var questions = [];
    for (var question in json["questions"]) {
      questions.add(AssessmentItemModel(
          question["questionText"], question["labels"], question["id"]));
    }
  }
}
