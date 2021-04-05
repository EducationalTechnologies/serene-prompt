class UserData {
  String userId;
  String email;
  int internalisationCondition = 1;
  DateTime registrationDate;
  int streakDays = 0;
  int score = 0;

  UserData(
      {this.userId,
      this.email,
      this.internalisationCondition = 1,
      this.registrationDate,
      this.streakDays = 0,
      this.score = 0});

  Map<String, dynamic> toMap() {
    return {
      "userId": this.userId,
      "email": this.email,
      "internalisationCondition": this.internalisationCondition,
      "registrationDate": this.registrationDate?.toIso8601String(),
      "streakDays": this.streakDays,
      "score": this.score
    };
  }

  UserData.fromJson(Map<String, dynamic> json) {
    email = json["email"];
    userId = json["userId"];
    internalisationCondition = json["internalisationCondition"];
    registrationDate = DateTime.parse(json["registrationDate"]);

    if (json.containsKey("score")) {
      score = json["score"];
    } else {
      score = 0;
    }

    if (json.containsKey("streakDays")) {
      streakDays = json["streakDays"];
    } else {
      streakDays = 0;
    }
  }
}
