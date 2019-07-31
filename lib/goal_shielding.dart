import 'package:flutter/material.dart';

class GoalShielding extends StatefulWidget {
  @override
  _GoalShieldingState createState() => _GoalShieldingState();
}

class _GoalShieldingState extends State<GoalShielding> {
  String dropdownValue = 'Watching TV';

  buildObstacleDropdown() {
    return DropdownButton<String>(
      value: dropdownValue,
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
        });
      },
      items: <String>["Watching TV", "Playing Games"]
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(value: value, child: Text(value));
      }).toList(),
    );
  }

  buildShieldSelection() {
    return Column(
      children: <Widget>[
        CheckboxListTile(
          title: Text("Turn it off"),
          value: true,
          onChanged: (bool value) {},
        ),
        CheckboxListTile(
          title: Text("Curl into a ball and cry"),
          value: false,
          onChanged: (bool value) {},
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.cyan,
      child: Column(
        children: <Widget>[
          SizedBox(height: 100),
          Text("My biggest obstacle is...", textAlign: TextAlign.left),
          SizedBox(height: 10),
          buildObstacleDropdown(),
          SizedBox(height: 10),
          Text("To overcome this, I will...", textAlign: TextAlign.left),
          SizedBox(height: 10),
          buildShieldSelection()
        ],
      ),
    );
  }
}
