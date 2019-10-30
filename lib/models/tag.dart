import 'package:cloud_firestore/cloud_firestore.dart';

class TagModel {
  String name;
  String id;

  TagModel({this.name, this.id});

  Map<String, dynamic> toMap() {
    return {
      "id": this.id,
      "name": this.name,
    };
  }

  TagModel.fromDocument(DocumentSnapshot map) {
    id = map.documentID;
    name = map["name"];
  }
}
