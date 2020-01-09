class GoalShield {
  String id;
  String hindrance;
  List<String> shields;
  List<String> goalsToShield;
  DateTime submissionDate;

  GoalShield({this.id, this.hindrance, this.shields, this.goalsToShield});

  GoalShield.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    hindrance = json["hindrance"];
    shields = ["1", "2"]; //(json["shields"] as List<dynamic>).cast<String>();
  }

  GoalShield.fromDocument(dynamic document) {
    this.id = document.documentID;
    this.submissionDate = DateTime.parse(document["submissionDate"]);
    this.hindrance = document["hindrance"];
    this.shields = List<String>.from(document["shields"]);
    this.goalsToShield = List<String>.from(document["goalsToShield"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "id": this.id,
      "hindrance": this.hindrance,
      "shields": this.shields,
      "goalsToShield": this.goalsToShield,
      "submissionDate": this.submissionDate.toIso8601String()
    };
  }
}
