class Internalisation {
  DateTime startDate = DateTime.now();
  DateTime completionDate = DateTime.now();
  String plan = "";
  String condition = "";
  String input = "";
  int planId = 0;

  Internalisation(
      {this.startDate,
      this.completionDate,
      this.plan = "",
      this.condition = "",
      this.input = "",
      this.planId = 0});

  Internalisation.fromDocument(dynamic document) {
    this.completionDate = DateTime.parse(document["completionDate"]);
    this.startDate = DateTime.parse(document["startDate"]);
    this.plan = document["plan"];
    this.condition = document["condition"];
    this.input = document["input"];
  }

  Map<String, dynamic> toMap() {
    return {
      "startDate": this.startDate?.toIso8601String(),
      "completionDate": this.completionDate?.toIso8601String(),
      "plan": this.plan,
      "condition": this.condition,
      "input": this.input
    };
  }
}
