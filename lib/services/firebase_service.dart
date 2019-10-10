import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:serene/models/goal.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  Firestore databaseReference;
  FirebaseService._internal() {
    databaseReference = Firestore.instance;
  }

  static final String COLLECTION_GOALS = "goals";

  getGoals() async {
    var goals =
        await databaseReference.collection(COLLECTION_GOALS).getDocuments();

    return goals;
  }

  getOpenGoals() async {
    var openGoals = await databaseReference
        .collection(COLLECTION_GOALS)
        .where("progress", isLessThan: 100)
        .getDocuments();

    openGoals.documents.forEach((g) => print(g.data));

    return List.generate(openGoals.documents.length, (i) {
      DateTime deadline;
      if (openGoals.documents[i]["deadline"] != "") {
        deadline = DateTime.parse(openGoals.documents[i]["deadline"]);
      }

      return Goal(
          deadline: deadline,
          goalText: openGoals.documents[i]["goalText"].toString());
    });
  }

  addGoal(Goal goal) async {
    await databaseReference.collection(COLLECTION_GOALS).add(goal.toMap());
  }

  updateGoal(Goal goal) async {
    // await databaseReference.collection(COLLECTION_GOALS).document(goal.id);
  }
}
