import 'package:flutter/widgets.dart';

class Outcome {
  String name;
  String description;
  bool isSelected;
  String iconPath;

  Outcome(
      {@required this.name,
      this.description,
      this.iconPath,
      this.isSelected = false});

  Outcome.fromDocument(dynamic document) {
    this.name = document["name"];
    this.description = document["description"];
  }

  Map<String, dynamic> toMap() {
    return {
      "name": this.name,
      "description": this.description,
    };
  }
}
