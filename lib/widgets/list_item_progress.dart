import 'package:flutter/material.dart';
import 'package:implementation_intentions/screens/add_goal_screen.dart';
import 'package:implementation_intentions/services/data_service.dart';
import 'package:implementation_intentions/shared/route_names.dart';
import 'package:implementation_intentions/state/goal_monitor_item_state.dart';
import 'package:implementation_intentions/state/goal_state.dart';
import 'package:provider/provider.dart';

enum ListItemMenu { delete, edit }

class ProgressListItem extends StatelessWidget {
  const ProgressListItem({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var goalMonitorItemState = Provider.of<GoalMonitorItemState>(context);

    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(children: <Widget>[
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(goalMonitorItemState.goalText),
              )),
              PopupMenuButton<ListItemMenu>(
                onSelected: (ListItemMenu result) async {
                  switch (result) {
                    case ListItemMenu.delete:
                      // TODO: Handle this case.
                      await DataService().deleteGoal(goalMonitorItemState.goal);
                      break;
                    case ListItemMenu.edit:
                      Navigator.pushNamed(context, RouteNames.ADD_GOAL);
                      // TODO: Handle this case.
                      break;
                  }
                },
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<ListItemMenu>>[
                  PopupMenuItem(value: ListItemMenu.edit, child: Text("Edit")),
                  PopupMenuItem(
                    value: ListItemMenu.delete,
                    child: Text("Delete"),
                  )
                ],
              ),
            ]),
            Slider(
              value: goalMonitorItemState.progress.toDouble(),
              min: 0,
              max: 100,
              onChanged: (double value) {
                goalMonitorItemState.progress = value.toInt();
              },
            )
          ],
        ),
      ),
    );
  }
}
