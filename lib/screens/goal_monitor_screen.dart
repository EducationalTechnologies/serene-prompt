import 'package:flutter/material.dart';
import 'package:implementation_intentions/models/goal.dart';
import 'package:implementation_intentions/services/database_helpers.dart';

class GoalMonitorScreen extends StatefulWidget {
  @override
  _GoalMonitorScreenState createState() => _GoalMonitorScreenState();
}

class _GoalMonitorScreenState extends State<GoalMonitorScreen> {
  buildListView(List<Goal> goals) {
    return ListView.builder(
      itemCount: goals.length,
      itemBuilder: (context, index) {
        return CheckboxListTile(
            value: goals.elementAt(index).progress == 100,
            title: Text(goals.elementAt(index).goal),
            onChanged: (bool value) {
              setState(() {
                goals.elementAt(index).progress = 100;
              });
            },
            controlAffinity: ListTileControlAffinity.leading);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: FutureBuilder<dynamic>(
      future: DBProvider.db.getGoals(),
      initialData: List(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.connectionState == ConnectionState.done) {
            return buildListView(snapshot.data as List<Goal>);
          }
        }
        return Center(child: CircularProgressIndicator());
      },
    ));
  }
}

// class CheckboxItem implements ListItem {
//   final String goal;
//   bool complete
//   ProgressItem
// }
