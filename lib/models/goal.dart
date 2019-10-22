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
      this.difficulty = GoalDifficulty.medium,
      this.creationDate,
      this.completionDate,
      this.tags = const ["A Tag"],
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
      "tags": this.tags
    };
  }
}
