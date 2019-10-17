import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:serene/models/assessment.dart';
import 'package:serene/models/goal.dart';
import 'package:serene/models/user_data.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;

  final Firestore _databaseReference = Firestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  FirebaseService._internal() {
    Firestore.instance
        .settings(
      persistenceEnabled: true,
    )
        .then((val) {
      print("Set Firebase Instance Settings");
    });
  }

  static const String COLLECTION_GOALS = "goals";
  static const String COLLECTION_GOALS_DELETED = "deletedGoals";
  static const String COLLECTION_USERS = "users";
  static const String COLLECTION_ASSESSMENTS = "assessments";

  getGoals() async {
    var goals =
        await _databaseReference.collection(COLLECTION_GOALS).getDocuments();

    return goals;
  }

  Goal goalFromMap(map) {
    DateTime deadline;
    if (map["deadline"] != "") {
      deadline = DateTime.parse(map["deadline"]);
    }
    return Goal(
        deadline: deadline,
        goalText: map["goalText"],
        progress: map["progress"],
        userId: map["userId"],
        progressIndicator: map["progressIndicator"],
        documentId: map.documentID,
        difficulty: map["difficulty"]);
  }

  getOpenGoals(String userId) async {
    var goals = await _databaseReference
        .collection(COLLECTION_GOALS)
        .where("userId", isEqualTo: userId)
        .getDocuments();

    var mappedGoals =
        goals.documents.where((g) => g["progress"] < 100).map((g) {
      return goalFromMap(g);
    }).toList();
    return mappedGoals;
  }

  Future<bool> isNameAvailable(String userId) async {
    try {
      var availableMethods =
          await _firebaseAuth.fetchSignInMethodsForEmail(email: userId);
      return availableMethods.length == 0;
    } catch (e) {
      print("Error trying to get the email availabiltiyeeee: $e");
      return false;
    }
  }

  Future<UserData> registerUser(String userId, String password) async {
    var result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: userId, password: password);
    return UserData(userId: result.user.uid, email: result.user.email);
  }

  Future<UserData> signInUser(String userId, String password) async {
    var result = await _firebaseAuth.signInWithEmailAndPassword(
        email: userId, password: password);
    return UserData(userId: result.user.uid, email: result.user.email);
  }

  addGoal(Goal goal) async {
    await _databaseReference
        .collection(COLLECTION_GOALS)
        .add(goal.toMap())
        .then((val) {
      return true;
    }).catchError((error) {
      print("Error trying to submit a new goal: $error");
    });
  }

  deleteGoal(Goal goal) async {
    goal.completionDate = DateTime.now();
    await _databaseReference
        .collection(COLLECTION_GOALS_DELETED)
        .add(goal.toMap());
    await _databaseReference
        .collection(COLLECTION_GOALS)
        .document(goal.documentId)
        .delete()
        .catchError((e) {
      print(e);
    });
  }

  updateGoal(Goal goal) async {
    await _databaseReference
        .collection(COLLECTION_GOALS)
        .document(goal.documentId)
        .updateData(goal.toMap());
  }

  saveFcmToken(String userId, String token) async {
    var tokens = _databaseReference
        .collection(COLLECTION_USERS)
        .document(userId)
        .collection('tokens')
        .document(token);

    await tokens.setData({'token': token});
  }

  saveAssessment(AssessmentModel assessment) async {
    await _databaseReference
        .collection(COLLECTION_ASSESSMENTS)
        .add(assessment.toMap());
  }
}
