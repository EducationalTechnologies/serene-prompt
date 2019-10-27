import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:serene/models/assessment.dart';
import 'package:serene/models/goal.dart';
import 'package:serene/models/tag.dart';
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
  static const String COLLECTION_TAGS = "tags";

  getGoals(String userId) async {
    var goals = await _databaseReference
        .collection(COLLECTION_GOALS)
        .where("userId", isEqualTo: userId)
        .getDocuments();

    return goals;
  }

  getOpenGoals(String userId) async {
    var goals = await getGoals(userId);

    var mappedGoals =
        goals.documents.where((g) => g["progress"] < 100).map((g) {
      return Goal.fromMap(g);
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
    try {
      var result = await _firebaseAuth.createUserWithEmailAndPassword(
          email: userId, password: password);

      var userData =
          UserData(userId: result.user.uid, email: result.user.email);

      await insertUserData(userData);

      return userData;
    } catch (e) {
      print("Error trying to register the user: $e");
      return null;
    }
  }

  insertUserData(UserData userData) async {
    var resultDocuments = await _databaseReference
        .collection(COLLECTION_USERS)
        .document(userData.email)
        .setData(userData.toMap());

    return resultDocuments;
  }

  Future<UserData> getUserData(String email) async {
    var resultDocuments = await _databaseReference
        .collection(COLLECTION_USERS)
        .where("email", isEqualTo: email)
        .getDocuments();

// TODO: Continue here
    return UserData.fromJson(resultDocuments.documents[0].data);
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
    } catch (e) {
      print("Error trying to sign in the user: $e");
      return null;
    }
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

  addTag(TagModel tag, String email) async {
    await _databaseReference
        .collection(COLLECTION_USERS)
        .document(email)
        .collection("tags")
        .add(tag.toMap());
  }

  getTags(String email) async {
    var tags = await _databaseReference
        .collection(COLLECTION_USERS)
        .document(email)
        .collection(COLLECTION_TAGS)
        .getDocuments();

    var mappedTags = tags.documents.map((t) {
      return TagModel.fromMap(t);
    }).toList();
    return mappedTags;
  }

  test() async {
    await _databaseReference
        .collection(COLLECTION_USERS)
        .document("daniel")
        .setData({"hans": "cool"});
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
