class UserData {
  String userId;
  String email;
  int internalisationCondition;
  DateTime registrationDate;
  int streakDays = 0;
  int score = 0;

  UserData(
      {this.userId,
      this.email,
      this.internalisationCondition,
      this.registrationDate,
      this.streakDays,
      this.score});

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
