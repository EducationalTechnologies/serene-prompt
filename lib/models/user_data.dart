class UserData {
  String userId;
  String email;
  int internalisationCondition;
  DateTime registrationDate;

  UserData(
      {this.userId,
      this.email,
      this.internalisationCondition,
      this.registrationDate});

  Map<String, dynamic> toMap() {
    return {
      "userId": this.userId,
      "email": this.email,
      "internalisationCondition": this.internalisationCondition,
      "registrationDate": this.registrationDate?.toIso8601String()
    };
  }

  UserData.fromJson(Map<String, dynamic> json) {
    email = json["email"];
    userId = json["userId"];
    internalisationCondition = json["internalisationCondition"];
    registrationDate = DateTime.parse(json["registrationDate"]);
  }
}
