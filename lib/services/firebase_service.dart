import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:serene/models/assessment.dart';
import 'package:serene/models/goal.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  Firestore databaseReference;
  FirebaseService._internal() {
    databaseReference = Firestore.instance;
  }

  static const String COLLECTION_GOALS = "goals";
  static const String COLLECTION_GOALS_DELETED = "deletedGoals";
  static const String COLLECTION_USERS = "users";
  static const String COLLECTION_ASSESSMENTS = "assessments";

  getGoals() async {
    var goals =
        await databaseReference.collection(COLLECTION_GOALS).getDocuments();

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
    var goals = await databaseReference
        .collection(COLLECTION_GOALS)
        .where("userId", isEqualTo: userId)
        .getDocuments();

    var mappedGoals =
        goals.documents.where((g) => g["progress"] < 100).map((g) {
      return goalFromMap(g);
    }).toList();
    return mappedGoals;
  }

  addGoal(Goal goal) async {
    await databaseReference.collection(COLLECTION_GOALS).add(goal.toMap());
  }

  deleteGoal(Goal goal) async {
    goal.completionDate = DateTime.now();
    await databaseReference
        .collection(COLLECTION_GOALS_DELETED)
        .add(goal.toMap());
    await databaseReference
        .collection(COLLECTION_GOALS)
        .document(goal.documentId)
        .delete()
        .catchError((e) {
      print(e);
    });
  }

  updateGoal(Goal goal) async {
    await databaseReference
        .collection(COLLECTION_GOALS)
        .document(goal.documentId)
        .updateData(goal.toMap());
  }

  saveFcmToken(String userId, String token) async {
    var tokens = databaseReference
        .collection(COLLECTION_USERS)
        .document(userId)
        .collection('tokens')
        .document(token);

    await tokens.setData({'token': token});
  }

  saveAssessment(AssessmentModel assessment) async {
    await databaseReference
        .collection(COLLECTION_ASSESSMENTS)
        .add(assessment.toMap());
  }
}
