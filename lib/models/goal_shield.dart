class GoalShield {
  String id;
  String hindrance;
  List<String> shields;
  DateTime submissionDate;

  GoalShield({this.id, this.hindrance, this.shields});

  GoalShield.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    hindrance = json["hindrance"];
    shields = ["1", "2"]; //(json["shields"] as List<dynamic>).cast<String>();
  }

  GoalShield.fromDocument(dynamic document) {
    this.id = document.documentID;
    this.submissionDate = DateTime.parse(document["submissionDate"]);
    this.hindrance = document["hindrance"];
    this.shields = document["shields"];
  }

  Map<String, dynamic> toMap() {
    return {
      "id": this.id,
      "hindrance": this.hindrance,
      "shield": this.shields,
      "submissionDate": this.submissionDate.toIso8601String()
    };
  }
}
