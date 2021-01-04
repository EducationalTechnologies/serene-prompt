class UserData {
  String userId;
  String email;
  int group;
  int internalisationCondition;

  UserData(
      {this.userId, this.email, this.group, this.internalisationCondition});

  Map<String, dynamic> toMap() {
    return {
      "userId": this.userId,
      "email": this.email,
      "group": this.group,
      "internalisationCondition": this.internalisationCondition
    };
  }

  UserData.fromJson(Map<String, dynamic> json) {
    email = json["email"];
    userId = json["userId"];
    group = json["group"];
    internalisationCondition = json["internalisationCondition"];
  }
}
