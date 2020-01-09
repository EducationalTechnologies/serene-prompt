import 'package:flutter/material.dart';
import 'package:serene/shared/ui_helpers.dart';
import 'package:provider/provider.dart';
import 'package:serene/viewmodels/goal_shielding_view_model.dart';

class GoalShieldingSelectionScreen extends StatelessWidget {
  buildObstacleDropdown(BuildContext context) {
    final goalShieldingState = Provider.of<GoalShieldingViewModel>(context);
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

  _onSelected(BuildContext context, String hindrance) {
    Provider.of<GoalShieldingViewModel>(context, listen: false).selectHindrance(hindrance);
  }

  _buildHindranceItem(BuildContext context, IconData icon, String hindrance,
      String description) {
    final goalShieldingState = Provider.of<GoalShieldingViewModel>(context);

    return Card(
      color: goalShieldingState.hindrance == hindrance
          ? Theme.of(context).selectedRowColor
          : Colors.white,
      child: ListTile(
        leading: Icon(icon),
        title: Text(hindrance),
        subtitle: Text(description),
        isThreeLine: true,
        trailing: Icon(Icons.help_outline),
        onTap: () async {
          _onSelected(context, hindrance);
        },
      ),
    );
  }

  buildObstacleList(BuildContext context) {
    var vm = Provider.of<GoalShieldingViewModel>(context);
    return ListView(
      children: <Widget>[
        _buildHindranceItem(context, Icons.announcement, vm.hindrances[0],
            "Ist dir deine Aufgabe zu schwer?"),
        _buildHindranceItem(context, Icons.chat_bubble, vm.hindrances[1],
            "Kannst du dich nicht ausreichend konzentrieren, oder lenkst dich ständig ab?"),
        _buildHindranceItem(context, Icons.child_care, vm.hindrances[2],
            "Bist du nicht ausreichend motiviert um dich der Aufgabe zu widmen?"),
        _buildHindranceItem(context, Icons.cloud_upload, vm.hindrances[3],
            "Fühlst du dich körperlich nicht in der Lage, mit dem Lernen zu beginnen?"),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<GoalShieldingViewModel>(context);

    return Container(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Text("Dein Ziel:", style: _style),
          // UIHelper.verticalSpaceMedium(),
          if (vm.selectedGoals != null)
            for (var g in vm.selectedGoals)
              Text(g.goalText, style: Theme.of(context).textTheme.headline),
          UIHelper.verticalSpaceSmall(),
          Text("Was könnte dich vom Erreichen deiner Ziele abhalten?",
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.subhead),
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
