class Internalisation {
  DateTime startDate;
  DateTime completionDate = DateTime.now();
  String implementationIntention;
  String condition;
  String input;

  Internalisation(
      {this.startDate,
      this.completionDate,
      this.implementationIntention = "",
      this.condition = "",
      this.input = ""});

  Internalisation.fromDocument(dynamic document) {
    this.completionDate = DateTime.parse(document["completionDate"]);
    this.startDate = DateTime.parse(document["startDate"]);
    this.implementationIntention = document["implementationIntention"];
    this.condition = document["condition"];
    this.input = document["input"];
  }

  Map<String, dynamic> toMap() {
    return {
      "startDate": this.startDate?.toIso8601String(),
      "completionDate": this.completionDate?.toIso8601String(),
      "implementationIntention": this.implementationIntention,
      "condition": this.condition,
      "input": this.input
    };
  }
}
