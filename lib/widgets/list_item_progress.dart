import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:serene/shared/enums.dart';
import 'package:serene/shared/route_names.dart';
import 'package:serene/shared/screen_args.dart';
import 'package:serene/state/goal_monitor_item_state.dart';
import 'package:serene/state/goal_monitoring_state.dart';

enum ListItemMenu { delete, edit }

class ProgressListItem extends StatelessWidget {
  const ProgressListItem({Key key}) : super(key: key);

  buildConfirmationDialog(BuildContext context) {
    var goalMonitorItemState = Provider.of<GoalMonitorItemState>(context);
    var goalMonitoringState = Provider.of<GoalMonitoringState>(context);
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Löschen bestätigen"),
            content: Text("Möchtest du dieses Ziel wirklich löschen?"),
            actions: <Widget>[
              FlatButton(
                child: Text("Abbrechen"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("Löschen"),
                onPressed: () async {
                  await goalMonitoringState
                      .deleteGoal(goalMonitorItemState.goal);
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  buildDeadline(DateTime date) {
    return Row(
      children: <Widget>[
        Icon(Icons.calendar_today),
        Text(DateFormat('dd.MM.yyy').format(date))
      ],
    );
  }

  buildProgressInput(GoalMonitorItemState goalMonitorItemState) {
    return Slider(
      value: goalMonitorItemState.progress.toDouble(),
      min: 0,
      max: 100,
      onChanged: (double value) {
        goalMonitorItemState.progress = value.toInt();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var goalMonitorItemState = Provider.of<GoalMonitorItemState>(context);
    var goalMonitoringState = Provider.of<GoalMonitoringState>(context);
    var goal = goalMonitorItemState.goal;
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(children: <Widget>[
              if (goal.progressIndicator == GoalProgressIndicator.checkbox)
                Checkbox(
                  onChanged: (value) {
                    goalMonitorItemState.progress = value ? 100 : 0;
                  },
                  value: goalMonitorItemState.progress == 100,
                ),
              Expanded(
                child: Text(goal.goalText),
              ),
              PopupMenuButton<ListItemMenu>(
                onSelected: (ListItemMenu result) async {
                  switch (result) {
                    case ListItemMenu.delete:
                      buildConfirmationDialog(context);
                      break;
                    case ListItemMenu.edit:
                      Navigator.pushNamed(context, RouteNames.ADD_GOAL,
                              arguments: GoalScreenArguments(
                                  goalMonitorItemState.goal))
                          .then((value) {
                        goalMonitoringState.init();
                      });
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
            if (goal.progressIndicator == GoalProgressIndicator.slider) buildProgressInput(goalMonitorItemState),
            if (goalMonitorItemState.goal.deadline != null)
              buildDeadline(goal.deadline),
          ],
        ),
      ),
    );
  }
}
