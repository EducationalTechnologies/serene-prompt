class Goal {
  int id;
  String goal;
  DateTime deadline;
  int progress;

  Goal({this.id, this.goal, this.deadline, this.progress});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "goal": goal,
      "deadline": deadline?.toIso8601String() ?? "",
      "progress": progress
    };
  }
}
