import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prompt/locator.dart';
import 'package:prompt/models/assessment_result.dart';
import 'package:prompt/models/internalisation.dart';
import 'package:prompt/models/ldt_data.dart';
import 'package:prompt/models/obstacle.dart';
import 'package:prompt/models/outcome.dart';
import 'package:prompt/models/recall_task.dart';
import 'package:prompt/models/user_data.dart';
import 'package:flutter/services.dart';
import 'package:prompt/services/logging_service.dart';
import 'package:prompt/services/user_service.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;

  String lastError = "";

  final FirebaseFirestore _databaseReference = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  FirebaseService._internal() {
    FirebaseFirestore.instance.settings =
        Settings(persistenceEnabled: true, cacheSizeBytes: 5000000);
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
  static const String COLLECTION_INITSESSION = "initSession";

  static const Duration timeoutDuration = Duration(seconds: 30);

  void handleError(Object e, {String data = ""}) {
    locator
        .get<LoggingService>()
        .logError("Firestore error: ${e.toString()}", data: data);
  }

  void handleTimeout(String function) {
    locator.get<LoggingService>().logError("Firestore Timeout: $function");
  }

  Stream<User> getCurrentUser() {
    return FirebaseAuth.instance.userChanges();
    // return _firebaseAuth.currentUser;
    //
    // return FirebaseAuth.instance.authStateChanges().listen((User user) {
    //   return user;
    //   if (user == null) {
    //     return null;
    //     print('User is currently signed out!');
    //   } else {
    //     print('User is signed in!');
    //   }
    // });
  }

  Future<bool> isNameAvailable(String userId) async {
    try {
      var availableMethods = await _firebaseAuth
          .fetchSignInMethodsForEmail(userId)
          .onError((error, stackTrace) {
        handleError(error);
        return [];
      });
      if (availableMethods == null) return false;
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

      var userData = UserService.getDefaultUserData(result.user.email,
          uid: result.user.uid);
      await insertUserData(userData);

      return userData;
    } on PlatformException catch (e) {
      print("Error trying to register the user: $e");
      lastError = e.code;
      return null;
    }
  }

  insertUserData(UserData userData) async {
    return _databaseReference
        .collection(COLLECTION_USERS)
        .doc(userData.email)
        .set(userData.toMap())
        .then((value) => value)
        .catchError((error) {
      handleError(error.toString(), data: "Trying to inser UserData");
    });
  }

  saveScrambleCorrections(dynamic corrections) async {
    _databaseReference.collection("scrambleCorrections").add(corrections);
  }

  Future<UserData> getUserData(String email) async {
    return _databaseReference
        .collection(COLLECTION_USERS)
        .where("email", isEqualTo: email)
        .get()
        .then((documents) {
      if (documents.size == 0) return null;
      if (documents.docs.isEmpty) return null;
      return UserData.fromJson(documents.docs[0].data());
    }).catchError((error) {
      handleError(error, data: "Trying to obtain user data");
    });
  }

  Future<User> signInUser(String userId, String password) async {
    return _firebaseAuth
        .signInWithEmailAndPassword(email: userId, password: password)
        .then((value) => value.user)
        .onError((error, stackTrace) {
      handleError(error.toString(), data: "Error signing in user");
      lastError = error.code;
      return null;
    });
  }

  saveAssessment(AssessmentResult assessment, String userid) async {
    var assessmentMap = assessment.toMap();
    assessmentMap["user"] = userid;
    _databaseReference
        .collection(COLLECTION_ASSESSMENTS)
        .add(assessmentMap)
        .then((res) => res)
        .catchError(handleError);
  }

  saveOutcomes(List<Outcome> outcomes, String email) async {
    var dynamicList = outcomes.map((outcome) => outcome.toMap()).toList();

    _databaseReference
        .collection(COLLECTION_OUTCOMES)
        .doc(email)
        .set({"outcomes": dynamicList});
  }

  saveObstacles(List<Obstacle> obstacles, String email) async {
    var dynamicList = obstacles.map((obstacle) => obstacle.toMap()).toList();

    _databaseReference
        .collection(COLLECTION_OBSTACLES)
        .doc(email)
        .set({"obstacles": dynamicList});
  }

  saveInternalisation(Internalisation internalisation, String email) async {
    var map = internalisation.toMap();
    map["user"] = email;

    _databaseReference.collection(COLLECTION_INTERNALISATION).add(map);
  }

  Future<DateTime> getLastLdtTaskDate(String userid) async {
    return _databaseReference
        .collection(COLLECTION_LDT)
        .where("user", isEqualTo: userid)
        .orderBy("completionDate", descending: true)
        .limit(1)
        .get()
        .then((doc) {
      if (doc == null) return null;
      if (doc.docs.length == 0) return null;
      var last = doc.docs[0];
      var lastDateString = last["completionDate"];
      var lastDate = DateTime.parse(lastDateString);
      return lastDate;
    }).timeout(timeoutDuration, onTimeout: () {
      handleTimeout("LDT Task");
      return null;
    }).catchError((handleError));
  }

  Future<List<Internalisation>> getLastInternalisations(
      String userid, int number) async {
    return _databaseReference
        .collection(COLLECTION_INTERNALISATION)
        .where("user", isEqualTo: userid)
        .orderBy("completionDate", descending: true)
        .limit(number)
        .get()
        .then((doc) {
      if (doc == null) return null;
      List<Internalisation> internalisations = [];
      for (var doc in doc.docs) {
        internalisations.add(Internalisation.fromDocument(doc));
      }
      return internalisations;
    }).timeout(timeoutDuration, onTimeout: () {
      handleTimeout("Trying to retrieve last $number Internalisations");
      return null;
    }).catchError((handleError));
  }

  Future saveRecallTask(RecallTask recallTask, String email) async {
    var map = recallTask.toMap();
    map["user"] = email;

    return _databaseReference
        .collection(COLLECTION_RECALLTASKS)
        .add(map)
        .then((value) => value)
        .catchError(handleError);
  }

  Future<RecallTask> getLastRecallTask(String email) async {
    return _databaseReference
        .collection(COLLECTION_RECALLTASKS)
        .where("user", isEqualTo: email)
        .orderBy("completionDate", descending: true)
        .limit(1)
        .get()
        .then((doc) {
      if (doc.docs.length == 0) return null;
      return RecallTask.fromDocument(doc.docs[0]);
    });
  }

  Future<int> getNumberOfInternalisations(String email) async {
    return _databaseReference
        .collection(COLLECTION_INTERNALISATION)
        .where("user", isEqualTo: email)
        .get()
        .then((value) => value.docs.length)
        .catchError(handleError);
  }

  saveConsent(String userid, bool consentValue) async {
    return _databaseReference
        .collection(COLLECTION_USERS)
        .doc(userid)
        .set({"consented": consentValue}, SetOptions(merge: true));
  }

  saveEmojiInternalisation(
      String userEmail, Internalisation internalisation) async {
    return _databaseReference
        .collection(COLLECTION_EMOJI_INTERNALISATION)
        .add(internalisation.toMap());
  }

  Future<void> saveScore(String userid, int score) async {
    return _databaseReference
        .collection(COLLECTION_USERS)
        .doc(userid)
        .set({"score": score}, SetOptions(merge: true));
  }

  Future<void> saveLdt(String userid, LdtData ldtData) async {
    var ldtMap = ldtData.toMap();
    ldtMap["user"] = userid;
    _databaseReference.collection(COLLECTION_LDT).add(ldtMap);
  }

  logEvent(String userid, dynamic data) async {
    _databaseReference.collection(COLLECTION_LOGS).add(data);
  }

  Future<void> saveInitSessionStepCompleted(String userid, int step) async {
    _databaseReference
        .collection(COLLECTION_USERS)
        .doc(userid)
        .set({"initSessionStep": step}, SetOptions(merge: true));
  }

  Future<void> saveInitialSessionValue(
      String username, String key, dynamic value) async {
    _databaseReference
        .collection(COLLECTION_INITSESSION)
        .doc(username)
        .set({key: value}, SetOptions(merge: true));
  }

  Future<void> setStreakDays(String username, int value) async {
    _databaseReference
        .collection(COLLECTION_USERS)
        .doc(username)
        .set({"streakDays": value}, SetOptions(merge: true))
        .then((value) => true)
        .catchError(handleError);
  }

  Future saveDaysAcive(String username, int daysActive) async {
    _databaseReference
        .collection(COLLECTION_USERS)
        .doc(username)
        .set({"daysActive": daysActive}, SetOptions(merge: true))
        .then((value) => true)
        .catchError(handleError);
  }

  Future setRegistrationDate(String username, String dateString) async {
    _databaseReference
        .collection(COLLECTION_USERS)
        .doc(username)
        .set({"registrationDate": dateString}, SetOptions(merge: true))
        .then((value) => true)
        .catchError(handleError);
  }

  Future<dynamic> getLastAssessment(
      String assessmentName, String username) async {
    return _databaseReference
        .collection(COLLECTION_ASSESSMENTS)
        .where("user", isEqualTo: username)
        .where("assessmentType", isEqualTo: assessmentName)
        .limit(1)
        .get()
        .then((val) {
      if (val.docs.isEmpty)
        return null;
      else
        return val.docs[0];
    });
  }
}
