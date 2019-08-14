import 'package:flutter/material.dart';
import 'package:implementation_intentions/shared/text_styles.dart';
import 'package:implementation_intentions/shared/ui_helpers.dart';
import 'package:implementation_intentions/state/goal_shielding_state.dart';
import 'package:provider/provider.dart';

class GoalShieldingSelectionScreen extends StatelessWidget {
  final List<String> hindrances = ["Watching TV", "Playing Games"];
  final List<String> shields = ["Turn it off", "Curl into a ball and cry"];

  buildObstacleDropdown(BuildContext context) {
    final intention = Provider.of<GoalShieldingState>(context);
    return DropdownButton<String>(
      value: intention.hindrance,
      onChanged: (String newValue) {
        intention.hindrance = newValue;
      },
      items: hindrances.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(value: value, child: Text(value));
      }).toList(),
    );
  }

  buildShieldItem(BuildContext context, String shield) {
    final intention = Provider.of<GoalShieldingState>(context);

    return CheckboxListTile(
      title: Text(shield),
      value: intention.selectedShieldingActions.contains(shield),
      onChanged: (bool value) {
        if (value)
          intention.addShieldingAction(shield);
        else
          intention.removeShieldingAction(shield);
      },
    );
  }

  buildShieldSelection(BuildContext context) {
    final state = Provider.of<GoalShieldingState>(context);
    return Column(children: <Widget>[
      for (var shield in state.shields) buildShieldItem(context, shield)
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
          buildObstacleDropdown(context),
          UIHelper.verticalSpaceSmall(),
          Text(
            "To overcome this, I will:",
            textAlign: TextAlign.left,
            style: subHeaderStyle,
          ),
          UIHelper.verticalSpaceSmall(),
          buildShieldSelection(context)
        ],
      ),
    );
  }
}
