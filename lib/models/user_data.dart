class UserData {
  String userId;
  String email;
  int internalisationCondition;

  UserData({this.userId, this.email, this.internalisationCondition});

  Map<String, dynamic> toMap() {
    return {
      "userId": this.userId,
      "email": this.email,
      "internalisationCondition": this.internalisationCondition
    };
  }

  UserData.fromJson(Map<String, dynamic> json) {
    email = json["email"];
    userId = json["userId"];
    internalisationCondition = json["internalisationCondition"];
  }
}
