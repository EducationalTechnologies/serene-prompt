import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:serene/models/assessment.dart';
import 'package:serene/models/goal.dart';
import 'package:serene/models/goal_shield.dart';
import 'package:serene/models/tag.dart';
import 'package:serene/models/user_data.dart';
import 'package:flutter/services.dart';

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
      String userId, String password, int group) async {
    try {
      var result = await _firebaseAuth.createUserWithEmailAndPassword(
          email: userId, password: password);

      var userData = UserData(
          userId: result.user.uid, email: result.user.email, group: group);

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
        userData = UserData(
            userId: result.user.uid, email: result.user.email, tags: null);
        await insertUserData(userData);
      }
      return userData;
    } on PlatformException catch (e) {
      print("Error trying to sign in the user: $e");
      lastError = e.code;
      return null;
    }
  }

  createTag(TagModel tag, String email) async {
    var tagDoc = await _databaseReference
        .collection(COLLECTION_USERS)
        .doc(email)
        .collection("tags")
        .add(tag.toMap());

    return tagDoc.id;
  }

  getTags(String email) async {
    var tags = await _databaseReference
        .collection(COLLECTION_USERS)
        .doc(email)
        .collection(COLLECTION_TAGS)
        .get();

    List<TagModel> mappedTags = tags.docs.map((t) {
      return TagModel.fromDocument(t);
    }).toList();
    return mappedTags;
  }

  updateTag(TagModel tag, String email) async {
    await _databaseReference
        .collection(COLLECTION_USERS)
        .doc(email)
        .collection("tags")
        .doc(tag.id)
        .set(tag.toMap());
  }

  test() async {
    await _databaseReference
        .collection(COLLECTION_USERS)
        .doc("daniel")
        .set({"hans": "cool"});
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
}
