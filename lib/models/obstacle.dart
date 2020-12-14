import 'package:flutter/widgets.dart';

class Obstacle {
  String name;
  String description;
  bool isSelected;
  String iconPath;

  Obstacle(
      {@required this.name,
      this.description,
      this.iconPath,
      this.isSelected = false});
}
