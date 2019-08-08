import 'package:flutter/material.dart';

class GoalMonitorScreen extends StatefulWidget {
  @override
  _GoalMonitorScreenState createState() => _GoalMonitorScreenState();
}

class _GoalMonitorScreenState extends State<GoalMonitorScreen> {
  final goals = [
    'Goal One',
    'Goal Two',
    'Goal Three',
    'Goal Four',
    'Goal Five',
    'Goal Six',
    'Goal Seven',
    'Goal Eight'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          ListView.builder(
            itemCount: goals.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  leading: Icon(Icons.today),
                  title: Text(goals[index]),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

abstract class ListItem {}

// class CheckboxItem implements ListItem {
//   final String goal;
//   bool complete
//   ProgressItem
// }
