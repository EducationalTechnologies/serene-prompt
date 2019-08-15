import 'package:flutter/material.dart';
import 'package:implementation_intentions/models/goal.dart';
import 'package:implementation_intentions/state/goal_monitor_item_state.dart';
import 'package:implementation_intentions/state/goal_state.dart';
import 'package:implementation_intentions/widgets/list_items.dart';
import 'package:provider/provider.dart';

class GoalMonitorScreen extends StatefulWidget {
  @override
  _GoalMonitorScreenState createState() => _GoalMonitorScreenState();
}

class _GoalMonitorScreenState extends State<GoalMonitorScreen> {
  buildListView(List<Goal> goals) {
    return ListView.builder(
      itemCount: goals.length,
      itemBuilder: (context, index) {
        return Card(
          child: ChangeNotifierProvider<GoalMonitorItemState>(
              builder: (_) => GoalMonitorItemState(goals.elementAt(index)),
              child: Column(
                children: <Widget>[ProgressListItem()],
              )),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<GoalState>(context);

    if (appState.isFetching) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Container(
        child: buildListView(appState.goals),
      );
    }
  }
}
