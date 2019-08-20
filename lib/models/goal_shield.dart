class GoalShield {
  int id;
  String hindrance;
  List<String> shields;

  GoalShield.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    hindrance = json["hindrance"];
    shields = ["1", "2"]; //(json["shields"] as List<dynamic>).cast<String>();
  }
}
