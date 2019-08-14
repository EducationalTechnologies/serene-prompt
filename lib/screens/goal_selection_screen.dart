import 'package:flutter/material.dart';
import 'package:implementation_intentions/state/goal_shielding_state.dart';
import 'package:provider/provider.dart';

class GoalSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = Provider.of<GoalShieldingState>(context);
    return Container(
      child: ListView(
        children: <Widget>[
          for (var goal in state.goals)
            Container(
              child: ListTile(
                title: Text(goal.goal)),
            )
        ],
      ),
    );
  }
}
