import 'package:flutter/material.dart';
import 'package:implementation_intentions/models/goal.dart';
import 'package:implementation_intentions/state/goal_monitoring_state.dart';
import 'package:provider/provider.dart';

List<Goal> goalList = [
  new Goal(
      id: 0,
      goal: "My Goal Number one",
      deadline: DateTime.now(),
      progress: 80),
  new Goal(
      id: 1,
      goal: "This is the second goal",
      deadline: DateTime.now(),
      progress: 20),
  new Goal(
      id: 2, goal: "Goal number three", deadline: DateTime.now(), progress: 40),
  new Goal(id: 3, goal: "Goal four", deadline: DateTime.now(), progress: 60),
  new Goal(
      id: 4,
      goal: "My Goal Number one",
      deadline: DateTime.now(),
      progress: 80),
  new Goal(
      id: 5,
      goal: "My Goal Number one",
      deadline: DateTime.now(),
      progress: 80),
  new Goal(
      id: 6,
      goal: "My Goal Number one",
      deadline: DateTime.now(),
      progress: 80),
  new Goal(
      id: 7,
      goal: "My Goal Number one",
      deadline: DateTime.now(),
      progress: 80),
];

class ReflectScreen extends StatefulWidget {
  @override
  _ReflectScreenState createState() => _ReflectScreenState();
}

class _ReflectScreenState extends State<ReflectScreen> {
  List<Goal> _testGoals = [];

  @override
  Future initState() async {
    var appstate = Provider.of<GoalMonitoringState>(context, listen: false);
    await appstate.getGoalsAsync();
    _testGoals = appstate.goals;
  }

  @override
  Widget build(BuildContext context) {
    var appstate = Provider.of<GoalMonitoringState>(context);
    return Container(
        child: Column(
      children: <Widget>[
        Text("this is the reflect screen"),
        RaisedButton(
            child: Text("Fetch Goals"),
            onPressed: () {
              var goals = appstate.goals;
              setState(() {
                _testGoals = goals;
              });
            }),
        Expanded(
          child: ListView.builder(
            itemCount: _testGoals.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_testGoals[index].goal),
              );
            },
          ),
        )
      ],
    ));
  }
}
