import 'package:serene/models/tag.dart';

class UserData {
  String userId;
  String email;
  List<TagModel> tags;
  int group;

  UserData({this.userId, this.email, this.tags, this.group});

  Map<String, dynamic> toMap() {
    return {
      "userId": this.userId,
      "email": this.email,
      "tags": this.tags,
      "group": this.group
    };
  }

  UserData.fromJson(Map<String, dynamic> json) {
    email = json["email"];
    userId = json["userId"];
    tags = json["tags"];
    group = json["group"];
  }
}
