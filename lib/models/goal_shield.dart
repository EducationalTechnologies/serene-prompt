import 'package:implementation_intentions/models/goal.dart';

class GoalShield {
  int id;
  String hindrance;
  List<String> shields;

  GoalShield.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    hindrance = json["hindrance"];
    shields = json["shields"].cast<List<String>>();
  }
}
