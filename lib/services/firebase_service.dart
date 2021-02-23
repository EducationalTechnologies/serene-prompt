import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:serene/locator.dart';
import 'package:serene/models/assessment.dart';
import 'package:serene/models/goal.dart';
import 'package:serene/models/goal_shield.dart';
import 'package:serene/models/internalisation.dart';
import 'package:serene/models/ldt_data.dart';
import 'package:serene/models/obstacle.dart';
import 'package:serene/models/outcome.dart';
import 'package:serene/models/recall_task.dart';
import 'package:serene/models/user_data.dart';
import 'package:flutter/services.dart';
import 'package:serene/services/logging_service.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;

  String lastError = "";

  final FirebaseFirestore _databaseReference = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  FirebaseService._internal() {
    FirebaseFirestore.instance.settings = Settings(persistenceEnabled: true);
  }

  static const String COLLECTION_GOALS = "goals";
  static const String COLLECTION_GOALS_DELETED = "deletedGoals";
  static const String COLLECTION_GOALS_OPEN = "openGoals";
  static const String COLLECTION_USERS = "users";
  static const String COLLECTION_ASSESSMENTS = "assessments";
  static const String COLLECTION_TAGS = "tags";
  static const String COLLECTION_SHIELDS = "shields";
  static const String COLLECTION_OUTCOMES = "outcomes";
  static const String COLLECTION_OBSTACLES = "obstacles";
  static const String COLLECTION_INTERNALISATION = "internalisation";
  static const String COLLECTION_RECALLTASKS = "recallTasks";
  static const String COLLECTION_EMOJI_INTERNALISATION =
      "emojiInternalisations";
  static const String COLLECTION_SCORES = "scores";
  static const String COLLECTION_LOGS = "logs";
  static const String COLLECTION_LDT = "ldt";

  void handleError(Object e) {
    locator.get<LoggingService>().logEvent("Firestore error: ${e.toString()}");
  }

  void handleTimeout(String function) {
    locator.get<LoggingService>().logEvent("Firetore Timeout: $function");
  }

  Future<List<DocumentSnapshot>> getGoals(String email) async {
    var goals = await _databaseReference
        .collection(COLLECTION_GOALS)
        .doc(email)
        .collection(COLLECTION_GOALS_OPEN)
        .get();

    return goals.docs;
  }

  /// Adds a goal to the database and returns its id
  Future<String> createGoal(Goal goal, String email) async {
    return await _databaseReference
        .collection(COLLECTION_GOALS)
        .doc(email)
        .collection(COLLECTION_GOALS_OPEN)
        .doc(goal.id)
        .set(goal.toMap())
        .then((val) {
      return null;
    }).catchError((error) {
      print("Error trying to submit a new goal: $error");
      return null;
    });
  }

  Future<List<DocumentSnapshot>> retrieveAllGoals(String email) async {
    try {
      var goals = await _databaseReference
          .collection(COLLECTION_GOALS)
          .doc(email)
          .collection(COLLECTION_GOALS_OPEN)
          .get();

      return goals.docs;
    } on PlatformException catch (e) {
      print("Error trying to retrieve goals: $e");
      lastError = e.code;
      return [];
    }
  }

  retrieveOpenGoals(String userId) async {
    var goals = await retrieveAllGoals(userId);
    List<Goal> mappedGoals = [];

    if (goals != null) {
      if (goals.length > 0) {
        mappedGoals = goals.where((goal) {
          if (goal["progress"] != null) {
            return goal["progress"] < 100;
          }
          return false;
        }).map((openGoal) {
          return Goal.fromDocument(openGoal);
        }).toList();
      }
    }

    return mappedGoals;
  }

  updateGoal(Goal goal, String email) async {
    await _databaseReference
        .collection(COLLECTION_GOALS)
        .doc(email)
        .collection(COLLECTION_GOALS_OPEN)
        .doc(goal.id)
        .update(goal.toMap());
  }

  /// Deletes a goal and at the same time adds it to the list of deleted goals
  deleteGoal(Goal goal, String email) async {
    goal.completionDate = DateTime.now();
    await _databaseReference
        .collection(COLLECTION_GOALS)
        .doc(email)
        .collection(COLLECTION_GOALS_DELETED)
        .doc(goal.id)
        .set(goal.toMap());
    await _databaseReference
        .collection(COLLECTION_GOALS)
        .doc(email)
        .collection(COLLECTION_GOALS_OPEN)
        .doc(goal.id)
        .delete()
        .catchError((e) {
      print(e);
    });
  }

  Future<bool> isNameAvailable(String userId) async {
    try {
      var availableMethods =
          await _firebaseAuth.fetchSignInMethodsForEmail(userId);
      return (availableMethods.length == 0);
    } on PlatformException catch (e) {
      print("Error trying to get the email availabiltiy: $e");
      lastError = e.code;
      return false;
    }
  }

  Future<UserData> registerUser(
      String userId, String password, int internalisationCondition) async {
    try {
      var result = await _firebaseAuth.createUserWithEmailAndPassword(
          email: userId, password: password);

      var userData = UserData(
          userId: result.user.uid,
          email: result.user.email,
          registrationDate: DateTime.now(),
          internalisationCondition: internalisationCondition);

      await insertUserData(userData);

      return userData;
    } on PlatformException catch (e) {
      print("Error trying to register the user: $e");
      lastError = e.code;
      return null;
    }
  }

  insertUserData(UserData userData) async {
    var resultDocuments = await _databaseReference
        .collection(COLLECTION_USERS)
        .doc(userData.email)
        .set(userData.toMap());

    return resultDocuments;
  }

  Future<UserData> getUserData(String email) async {
    var resultDocuments = await _databaseReference
        .collection(COLLECTION_USERS)
        .where("email", isEqualTo: email)
        .get();

    return UserData.fromJson(resultDocuments.docs[0].data());
  }

  Future<UserData> signInUser(String userId, String password) async {
    try {
      var result = await _firebaseAuth.signInWithEmailAndPassword(
          email: userId, password: password);

      var userData = await getUserData(result.user.email);

      if (userData == null) {
        userData = UserData(userId: result.user.uid, email: result.user.email);
        await insertUserData(userData);
      }
      return userData;
    } on PlatformException catch (e) {
      print("Error trying to sign in the user: $e");
      lastError = e.code;
      return null;
    } on FirebaseAuthException catch (e) {
      print("Error trying to sign in the user: $e");
      lastError = e.code;
      return null;
    }
  }

  saveFcmToken(String userId, String token) async {
    var tokens = _databaseReference
        .collection(COLLECTION_USERS)
        .doc(userId)
        .collection('tokens')
        .doc(token);

    await tokens.set({'token': token});
  }

  saveAssessment(AssessmentModel assessment, String email) async {
    await _databaseReference
        .collection(COLLECTION_ASSESSMENTS)
        .doc(email)
        .collection(assessment.assessmentType)
        .add(assessment.toMap());
  }

  Future<AssessmentModel> getLastSubmittedAssessment(
      String assessmentType, String email) async {
    try {
      var doc = await _databaseReference
          .collection(COLLECTION_ASSESSMENTS)
          .doc(email)
          .collection(assessmentType)
          .orderBy("submissionDate", descending: true)
          .limit(1)
          .get();

      if (doc.docs.length == 0) return null;
      return AssessmentModel.fromDocument(doc.docs[0]);
    } catch (e) {
      print("Error trying to get the last submitted assessment: $e");
      return null;
    }
  }

  saveShielding(GoalShield shield, String email) async {
    var key = DateTime.now().toIso8601String();
    try {
      await _databaseReference
          .collection(COLLECTION_SHIELDS)
          .doc(email)
          .collection(COLLECTION_SHIELDS)
          .doc(key)
          .set(shield.toMap());
    } catch (e) {
      print("Error trying to save the goal shielding: $e");
      return null;
    }
  }

  saveOutcomes(List<Outcome> outcomes, String email) async {
    var dynamicList = outcomes.map((outcome) => outcome.toMap()).toList();

    await _databaseReference
        .collection(COLLECTION_OUTCOMES)
        .doc(email)
        .set({"outcomes": dynamicList});
  }

  saveObstacles(List<Obstacle> obstacles, String email) async {
    var dynamicList = obstacles.map((obstacle) => obstacle.toMap()).toList();

    await _databaseReference
        .collection(COLLECTION_OBSTACLES)
        .doc(email)
        .set({"obstacles": dynamicList});
  }

  Future<GoalShield> getLastSubmittedGoalShield(String email) async {
    var doc = await _databaseReference
        .collection(COLLECTION_SHIELDS)
        .doc(email)
        .collection(COLLECTION_SHIELDS)
        .orderBy("submissionDate", descending: true)
        .limit(1)
        .get();

    if (doc.docs.length == 0) return null;
    return GoalShield.fromDocument(doc.docs[0]);
  }

  saveInternalisation(Internalisation internalisation, String email) async {
    var map = internalisation.toMap();
    map["user"] = email;

    return await _databaseReference
        .collection(COLLECTION_INTERNALISATION)
        .add(map);
  }

  Future<DateTime> getLastLdtTaskDate(String userid) async {
    var doc = await _databaseReference
        .collection(COLLECTION_LDT)
        .where("user", isEqualTo: userid)
        .orderBy("completionDate", descending: true)
        .limit(1)
        .get()
        .timeout(Duration(seconds: 10), onTimeout: () {
      handleTimeout("LDT Task");
      return null;
    }).catchError((handleError));

    if (doc == null) return null;
    if (doc.docs.length == 0) return null;
    var last = doc.docs[0];

    return DateTime.parse(last["completionDate"]);
  }

  Future<List<Internalisation>> getLastInternalisations(
      String userid, int number) async {
    var doc = await _databaseReference
        .collection(COLLECTION_INTERNALISATION)
        .where("user", isEqualTo: userid)
        .orderBy("completionDate", descending: true)
        .limit(number)
        .get()
        .timeout(Duration(seconds: 10), onTimeout: () {
      handleTimeout("Last Internalisation");
      return null;
    }).catchError((handleError));

    if (doc == null) return null;

    List<Internalisation> internalisations = [];
    for (var doc in doc.docs) {
      internalisations.add(Internalisation.fromDocument(doc));
    }

    return internalisations;
  }

  Future<Internalisation> getLastInternalisation(String email) async {
    var docs = await getLastInternalisations(email, 1);

    if (docs == null) return null;
    if (docs.length == 0) return null;
    return (docs[0]);
  }

  Future<Internalisation> getFirstInternalisation(String email) async {
    var doc = await _databaseReference
        .collection(COLLECTION_INTERNALISATION)
        .where("user", isEqualTo: email)
        .orderBy("completionDate", descending: false)
        .limit(1)
        .get();

    if (doc.docs.length == 0) return null;
    return Internalisation.fromDocument(doc.docs[0]);
  }

  saveRecallTask(RecallTask recallTask, String email) async {
    var map = recallTask.toMap();
    map["user"] = email;

    return await _databaseReference.collection(COLLECTION_RECALLTASKS).add(map);
  }

  Future<RecallTask> getLastRecallTask(String email) async {
    var doc = await _databaseReference
        .collection(COLLECTION_RECALLTASKS)
        .where("user", isEqualTo: email)
        .orderBy("completionDate", descending: true)
        .limit(1)
        .get();

    if (doc.docs.length == 0) return null;
    return RecallTask.fromDocument(doc.docs[0]);
  }

  Future<int> getNumberOfInternalisations(String email) async {
    var count = await _databaseReference
        .collection(COLLECTION_INTERNALISATION)
        .where("user", isEqualTo: email)
        .get();

    return count.docs.length;
  }

  saveConsent(String userid, bool consentValue) async {
    return await _databaseReference
        .collection(COLLECTION_USERS)
        .doc(userid)
        .set({"consented": consentValue}, SetOptions(merge: true));
  }

  saveEmojiInternalisation(
      String userEmail, Internalisation internalisation) async {
    return await _databaseReference
        .collection(COLLECTION_EMOJI_INTERNALISATION)
        .add(internalisation.toMap());
  }

  Future<void> saveScore(String userid, int score) async {
    return await _databaseReference
        .collection(COLLECTION_SCORES)
        .doc(userid)
        .set({"score": score});
  }

  Future<void> updateInternalisationConditionGroup(
      String userid, int group) async {
    return await _databaseReference
        .collection(COLLECTION_USERS)
        .doc(userid)
        .set({"internalisationCondition": group}, SetOptions(merge: true));
  }

  Future<int> getScore(String userid) async {
    var scores = await _databaseReference
        .collection(COLLECTION_SCORES)
        .doc(userid)
        .get();

    if (!scores.exists) return 0;
    var score = scores.data()["score"];
    if (score == null) return 0;
    return score;
  }

  Future<void> saveLdt(String userid, LdtData ldtData) async {
    var ldtMap = ldtData.toMap();
    ldtMap["user"] = userid;
    return await _databaseReference.collection(COLLECTION_LDT).add(ldtMap);
  }

  logEvent(String userid, dynamic data) async {
    return await _databaseReference.collection(COLLECTION_LOGS).add(data);
  }
}
