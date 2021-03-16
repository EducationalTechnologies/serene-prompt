class RecallTask {
  DateTime startDate = DateTime.now();
  DateTime completionDate = DateTime.now();
  String recalledSentence;
  String implementationIntention;
  String condition;

  RecallTask(
      {this.startDate,
      this.completionDate,
      this.recalledSentence,
      this.implementationIntention,
      this.condition});

  RecallTask.fromDocument(dynamic document) {
    this.recalledSentence = document["recalledSentence"];
    this.completionDate = DateTime.parse(document["completionDate"]);
    this.startDate = DateTime.parse(document["startDate"]);
    this.implementationIntention = document["implementationIntention"];
    this.condition = document["condition"];
  }

  Map<String, dynamic> toMap() {
    return {
      "startDate": this.startDate.toIso8601String(),
      "completionDate": this.completionDate.toIso8601String(),
      "implementationIntention": this.implementationIntention,
      "condition": this.condition,
      "recalledSentence": this.recalledSentence
    };
  }
}
