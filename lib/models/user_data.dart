class UserData {
  String userId;
  String email;
  int group = 1;
  DateTime registrationDate;
  int streakDays = 0;
  int score = 0;
  int daysActive = 0;
  int initSessionStep = 0;
  String appVersion = "";

  UserData(
      {this.userId,
      this.email,
      this.group = 1,
      this.registrationDate,
      this.streakDays = 0,
      this.score = 0,
      this.appVersion = "",
      this.daysActive = 0});

  Map<String, dynamic> toMap() {
    return {
      "userId": this.userId,
      "email": this.email,
      "group": this.group,
      "registrationDate": this.registrationDate?.toIso8601String(),
      "streakDays": this.streakDays,
      "score": this.score,
      "daysActive": this.daysActive,
      "initSessionStep": this.initSessionStep,
      "appVersion": this.appVersion
    };
  }

  UserData.fromJson(Map<String, dynamic> json) {
    email = json["email"];
    userId = json["userId"];
    group = json["group"];
    registrationDate = DateTime.parse(json["registrationDate"]);

    if (json.containsKey("score")) {
      score = json["score"];
    }
    if (json.containsKey("streakDays")) {
      streakDays = json["streakDays"];
    }
    if (json.containsKey("daysActive")) {
      daysActive = json["daysActive"];
    }
    if (json.containsKey("initSessionStep")) {
      initSessionStep = json["initSessionStep"];
    }
    if (json.containsKey("appVersion")) {
      appVersion = json["appVersion"];
    }
  }
}
