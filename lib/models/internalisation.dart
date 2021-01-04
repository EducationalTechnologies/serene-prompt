class Internalisation {
  DateTime startDate;
  DateTime completionDate;
  String id;
  String implementationIntention;
  // TODO: More properties? Maybe errors?
  Internalisation() {}

  Internalisation.fromDocument(dynamic document) {
    this.id = document.documentID;
    this.completionDate = DateTime.parse(document["completionDate"]);
    this.startDate = DateTime.parse(document["startDate"]);
    this.implementationIntention = document["implementationIntention"];
  }

  Map<String, dynamic> toMap() {
    return {
      "startDate": this.startDate.toIso8601String(),
      "completionDate": this.completionDate.toIso8601String(),
      "implementationIntention": this.implementationIntention
    };
  }
}
