import 'package:flutter/material.dart';
import 'package:implementation_intentions/shared/text_styles.dart';
import 'package:implementation_intentions/shared/ui_helpers.dart';
import 'package:implementation_intentions/state/implementation_intention_state.dart';
import 'package:provider/provider.dart';

class GoalShielding extends StatefulWidget {
  @override
  _GoalShieldingState createState() => _GoalShieldingState();
}

class _GoalShieldingState extends State<GoalShielding> {
  List<String> hindrances = ["Watching TV", "Playing Games"];
  List<String> shields = ["Turn it off", "Curl into a ball and cry"];
  String selectedHindrance;

  buildObstacleDropdown() {
    final intention = Provider.of<ImplementationIntentionState>(context);
    return DropdownButton<String>(
      value: selectedHindrance,
      onChanged: (String newValue) {
        intention.hindrance = newValue;
        setState(() {
          selectedHindrance = newValue;
        });
      },
      items: hindrances.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(value: value, child: Text(value));
      }).toList(),
    );
  }

  buildShieldItem(String shield) {
    final intention = Provider.of<ImplementationIntentionState>(context);

    return CheckboxListTile(
      title: Text(shield),
      value: intention.shieldingActions.contains(shield),
      onChanged: (bool value) {
        if (value)
          intention.addShieldingAction(shield);
        else
          intention.removeShieldingAction(shield);
      },
    );
  }

  buildShieldSelection() {
    return Column(children: <Widget>[
      for (var shield in shields) buildShieldItem(shield)
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          UIHelper.verticalSpaceMedium(),
          Text(
            "My biggest obstacle is:",
            textAlign: TextAlign.left,
            style: subHeaderStyle,
          ),
          UIHelper.verticalSpaceSmall(),
          buildObstacleDropdown(),
          UIHelper.verticalSpaceSmall(),
          Text(
            "To overcome this, I will:",
            textAlign: TextAlign.left,
            style: subHeaderStyle,
          ),
          UIHelper.verticalSpaceSmall(),
          buildShieldSelection()
        ],
      ),
    );
  }
}
