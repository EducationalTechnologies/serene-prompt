import 'package:flutter/material.dart';
import 'package:serene/shared/ui_helpers.dart';
import 'package:serene/state/goal_shielding_state.dart';
import 'package:provider/provider.dart';

class GoalShieldingSelectionScreen extends StatelessWidget {
  buildObstacleDropdown(BuildContext context) {
    final goalShieldingState = Provider.of<GoalShieldingState>(context);
    return DropdownButton<String>(
      value: goalShieldingState.hindrance,
      onChanged: (String newValue) {
        goalShieldingState.selectHindrance(newValue);
      },
      items: goalShieldingState.hindrances
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: Theme.of(context).textTheme.body1,
            ));
      }).toList(),
    );
  }

  _onSelected(BuildContext context, String shield) {
    var goalShieldingState = Provider.of<GoalShieldingState>(context);
    goalShieldingState.selectedShieldingAction = shield;
  }

  buildObstacleCard(
      BuildContext context, IconData icon, String title, String description) {
    final goalShieldingState = Provider.of<GoalShieldingState>(context);

    return Card(
      color: goalShieldingState.selectedShieldingAction == title
          ? Colors.orange
          : Colors.white,
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(description),
        isThreeLine: true,
        trailing: Icon(Icons.help_outline),
        onTap: () async {
          _onSelected(context, title);
        },
      ),
    );
  }

  buildObstacleList(BuildContext context) {
    return ListView(
      children: <Widget>[
        buildObstacleCard(context, Icons.announcement, "Überforderung",
            "Ist dir deine Aufgabe zu schwer?"),
        buildObstacleCard(context, Icons.chat_bubble, "Ablenkung",
            "Kannst du dich nicht ausreichend konzentrieren, oder lenkst dich ständig ab?"),
        buildObstacleCard(context, Icons.child_care, "Lustlosigkeit",
            "Bist du nicht ausreichend motiviert um dich der Aufgabe zu widmen?"),
        buildObstacleCard(context, Icons.cloud_upload, "Körperliche Verfassung",
            "Fühlst du dich körperlich nicht in der Lage, mit dem Lernen zu beginnen?"),
        // buildObstacleCard(context, "Überforderung", "Ist dir deine Aufgabe zu schwer?"),
        // buildObstacleCard(context, "Überforderung", "Ist dir deine Aufgabe zu schwer?"),
        // buildObstacleCard(context, "Überforderung", "Ist dir deine Aufgabe zu schwer?")
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final goalShieldingState = Provider.of<GoalShieldingState>(context);

    return Container(
      padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Text("Dein Ziel:", style: _style),
          // UIHelper.verticalSpaceMedium(),
          if (goalShieldingState.selectedGoal != null)
            Text(goalShieldingState.selectedGoal.goalText,
                style: Theme.of(context).textTheme.body1),
          Text(
            "Was könnte dich vom Erreichen deines Zieles abhalten?",
            textAlign: TextAlign.left,
          ),
          UIHelper.verticalSpaceSmall(),
          // buildObstacleDropdown(context),
          Expanded(
            child: buildObstacleList(context),
          ),
        ],
      ),
    );
  }
}
