import 'package:implementation_intentions/shared/enums.dart';

class Goal {
  int id;
  String goalText;
  DateTime deadline;
  int progress;
  String progressIndicator;

  Goal(
      {this.id,
      this.goalText = "",
      this.deadline,
      this.progress = 0,
      this.progressIndicator = GoalProgressIndicator.checkbox});

  Map<String, dynamic> toMap() {
    return {
      "id": this.id,
      "goalText": this.goalText,
      "deadline": this.deadline?.toIso8601String() ?? "",
      "progress": this.progress,
      "progressIndicator": this.progressIndicator
    };
  }
}
