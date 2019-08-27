import 'package:flutter/material.dart';
import 'package:implementation_intentions/models/goal.dart';
import 'package:implementation_intentions/screens/add_goal.dart';
import 'package:implementation_intentions/shared/screen_args.dart';
import 'package:implementation_intentions/state/goal_state.dart';
import 'package:provider/provider.dart';

class AddGoalScreen extends StatelessWidget {
  Goal _goal;

  AddGoalScreen();
  AddGoalScreen.fromGoal(this._goal);

  @override
  Widget build(BuildContext context) {
    var goalState =
        this._goal != null ? GoalState.fromGoal(this._goal) : GoalState();
    return ChangeNotifierProvider<GoalState>(
      builder: (_) => goalState,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Neues Ziel'),
          actions: <Widget>[
            FlatButton.icon(
                textColor: Colors.white,
                icon: const Icon(Icons.save),
                label: Text("Speichern"),
                onPressed: () async {
                  await goalState.saveCurrentGoal();
                  Navigator.pop(context);
                }),
          ],
        ),
        body: Container(
          child: Padding(padding: const EdgeInsets.all(8.0), child: AddGoal()),
        ),
      ),
    );
  }
}
