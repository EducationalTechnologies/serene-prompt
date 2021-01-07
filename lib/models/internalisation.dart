class Internalisation {
  DateTime startDate;
  DateTime completionDate;
  String id;
  String implementationIntention;
  String condition;

  Internalisation(
      {this.startDate,
      this.completionDate,
      this.id,
      this.implementationIntention,
      this.condition});

  Internalisation.fromDocument(dynamic document) {
    this.id = document.documentID;
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
      "condition": this.condition
    };
  }
}
