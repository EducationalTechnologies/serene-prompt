import 'package:flutter/material.dart';
import 'package:implementation_intentions/screens/add_goal.dart';
import 'package:implementation_intentions/state/goal_state.dart';
import 'package:provider/provider.dart';

class AddGoalScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GoalState>(
      builder: (_) => GoalState(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Neues Ziel'),
          actions: <Widget>[
            FlatButton.icon(
                textColor: Colors.white,
                icon: const Icon(Icons.save),
                label: Text("Speichern"),
                onPressed: () async {
                  final appState = Provider.of<GoalState>(context);
                  await appState.saveCurrentGoal();
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
