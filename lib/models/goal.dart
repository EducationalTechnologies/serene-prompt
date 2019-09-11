class Goal {
  int id;
  String goalText;
  DateTime deadline;
  int progress;
  bool usesProgress;

  Goal(
      {this.id,
      this.goalText = "",
      this.deadline,
      this.progress = 0,
      this.usesProgress = false});

  Map<String, dynamic> toMap() {
    return {
      "id": this.id,
      "goalText": this.goalText,
      "deadline": this.deadline?.toIso8601String() ?? "",
      "progress": this.progress,
      "usesProgress": this.usesProgress ? 1 : 0
    };
  }
}
