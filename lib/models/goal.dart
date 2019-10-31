import 'package:serene/shared/enums.dart';

class Goal {
  int id;
  String goalText;
  DateTime deadline;
  int progress;
  String progressIndicator;
  String difficulty;
  String userId;
  String documentId;
  String parentId;
  String path;
  DateTime creationDate;
  DateTime completionDate;
  List<String> tags;

  Goal(
      {this.id,
      this.goalText = "",
      this.deadline,
      this.progress = 0,
      this.documentId = "",
      this.userId = "",
      this.parentId = "",
      this.path = "",
      this.difficulty = GoalDifficulty.medium,
      this.creationDate,
      this.completionDate,
      this.tags = const [],
      this.progressIndicator = GoalProgressIndicator.checkbox});

  Map<String, dynamic> toMap() {
    return {
      "id": this.id,
      "goalText": this.goalText,
      "deadline": this.deadline?.toIso8601String() ?? "",
      "creationDate": this.creationDate?.toIso8601String() ?? "",
      "completionDate": this.completionDate?.toIso8601String() ?? "",
      "progress": this.progress,
      "progressIndicator": this.progressIndicator,
      "difficulty": this.difficulty,
      "userId": this.userId,
      "documentId": this.documentId,
      "tags": this.tags,
      "parentId": this.parentId,
      "path": this.path
    };
  }

  Goal.fromDocument(dynamic map) {
    DateTime deadline;
    if (map["deadline"] != "") {
      deadline = DateTime.parse(map["deadline"]);
    }
    DateTime creationDate;
    if (map["creationDate"] != "") {
      creationDate = DateTime.parse(map["creationDate"]);
    }
    this.deadline = deadline;
    this.creationDate = creationDate;
    this.goalText = map["goalText"];
    this.progress = map["progress"];
    this.userId = map["userId"];
    this.progressIndicator = map["progressIndicator"];
    this.documentId = map.documentID;
    this.difficulty = map["difficulty"];
    this.parentId = map["parentId"];
    this.path = map["path"];
  }
}
