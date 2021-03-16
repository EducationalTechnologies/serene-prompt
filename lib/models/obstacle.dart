import 'package:flutter/widgets.dart';

class Obstacle {
  String name;
  String description;
  bool isSelected;
  String iconPath;

  Obstacle(
      {@required this.name = "",
      this.description = "",
      this.iconPath = "",
      this.isSelected = false});

  Obstacle.fromDocument(dynamic document) {
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
