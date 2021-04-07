class RecallTask {
  DateTime startDate = DateTime.now();
  DateTime completionDate = DateTime.now();
  String recall;
  String plan;
  String condition;
  int planId = 0;

  RecallTask(
      {this.startDate,
      this.completionDate,
      this.recall,
      this.plan,
      this.condition,
      this.planId});

  RecallTask.fromDocument(dynamic document) {
    this.recall = document["recall"];
    this.completionDate = DateTime.parse(document["completionDate"]);
    this.startDate = DateTime.parse(document["startDate"]);
    this.plan = document["plan"];
    this.condition = document["condition"];
    this.planId = document["planId"];
  }

  Map<String, dynamic> toMap() {
    return {
      "startDate": this.startDate.toIso8601String(),
      "completionDate": this.completionDate.toIso8601String(),
      "plan": this.plan,
      "planId": this.planId,
      "condition": this.condition,
      "recall": this.recall
    };
  }
}
