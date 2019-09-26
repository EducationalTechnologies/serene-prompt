import 'package:flutter/material.dart';
import 'package:serene/shared/text_styles.dart';
import 'package:serene/shared/ui_helpers.dart';
import 'package:serene/state/goal_shielding_state.dart';
import 'package:provider/provider.dart';

class GoalShieldingSelectionScreen extends StatelessWidget {
  buildObstacleDropdown(BuildContext context) {
    final goalShieldingState = Provider.of<GoalShieldingState>(context);
    return Theme(
      data: ThemeData(),
      child: DropdownButton<String>(
        value: goalShieldingState.hindrance,
        onChanged: (String newValue) {
          // goalShieldingState.hindrance = newValue;
          goalShieldingState.selectHindrance(newValue);
        },
        items: goalShieldingState.hindrances
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(fontSize: 25),
              ));
        }).toList(),
      ),
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
            "Mein größtes Hindernis ist...",
            textAlign: TextAlign.left,
            style: subHeaderStyle,
          ),
          UIHelper.verticalSpaceSmall(),
          buildObstacleDropdown(context),
          // UIHelper.verticalSpaceSmall(),
          // Text(
          //   "Wenn das auftritt, werde ich...",
          //   textAlign: TextAlign.left,
          //   style: subHeaderStyle,
          // ),
          // UIHelper.verticalSpaceSmall(),
          // buildShieldSelection(context)
        ],
      ),
    );
  }
}
