import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serene/state/goal_monitor_item_state.dart';

enum ListItemMenu { delete, edit }

class ProgressListItem extends StatelessWidget {
  const ProgressListItem({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return Text("Lahme");
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
                onSelected: (ListItemMenu result) {},
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
                goalMonitorItemState.setProgress(value.toInt());
              },
            )
          ],
        ),
      ),
    );
  }
}
