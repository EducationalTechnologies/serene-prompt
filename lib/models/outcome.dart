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
}
