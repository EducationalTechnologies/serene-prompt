import 'package:flutter/material.dart';
import 'package:serene/models/goal.dart';
import 'package:serene/shared/enums.dart';
import 'package:serene/shared/route_names.dart';
import 'package:serene/shared/screen_args.dart';
import 'package:serene/shared/ui_helpers.dart';
import 'package:serene/state/goal_monitoring_state.dart';
import 'package:serene/widgets/list_item_progress.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class GoalMonitorScreen extends StatefulWidget {
  @override
  _GoalMonitorScreenState createState() => _GoalMonitorScreenState();
}

class _GoalMonitorScreenState extends State<GoalMonitorScreen> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  List<Goal> _goals = [];

  _finishGoal(Goal goal) async {
    // await Future.delayed(Duration(milliseconds: 500));
    _removeItem(goal);
  }

  _removeItem(Goal goal) async {
    final goalMonitoringState = Provider.of<GoalMonitoringState>(context);
    await goalMonitoringState.deleteGoal(goal);
    var index = _goals.indexOf(goal);
    Goal removed = _goals.removeAt(index);
    _listKey.currentState.removeItem(
        index,
        (context, animation) =>
            buildAnimatedListItem(context, index, goal, animation),
        duration: const Duration(milliseconds: 350));
    // update(context);
  }

  buildConfirmationDialog(BuildContext context, Goal goal) {
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
                  await _removeItem(goal);
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  buildDeadline(DateTime date) {
    return Container(
      margin: EdgeInsets.only(left: 50),
      child: Row(
        children: <Widget>[
          Icon(Icons.date_range),
          UIHelper.horizontalSpaceSmall(),
          Text(DateFormat('dd.MM.yyy').format(date))
        ],
      ),
    );
  }

  updateGoal(Goal goal) {
    var goalMonitoringState = Provider.of<GoalMonitoringState>(context);
    goalMonitoringState.updateGoal(goal);
  }

  update(BuildContext context) {
    // var goalMonitoringState = Provider.of<GoalMonitoringState>(context);
    // goalMonitoringState.update();
  }

  buildProgressInput(BuildContext context, int index, Goal goal) {
    return Slider(
      value: goal.progress.toDouble(),
      min: 0,
      max: 100,
      onChanged: (double value) {
        goal.progress = value.toInt();
      },
      onChangeEnd: (double value) {
        updateGoal(goal);
        if (value >= 100) {
          _finishGoal(goal);
        }
      },
    );
  }

  buildPopupMenu(BuildContext context, goal) {
    return PopupMenuButton<ListItemMenu>(
      onSelected: (ListItemMenu result) async {
        switch (result) {
          case ListItemMenu.delete:
            buildConfirmationDialog(context, goal);
            break;
          case ListItemMenu.edit:
            Navigator.pushNamed(context, RouteNames.ADD_GOAL,
                    arguments: GoalScreenArguments(goal))
                .then((value) {});
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<ListItemMenu>>[
        PopupMenuItem(value: ListItemMenu.edit, child: Text("Edit")),
        PopupMenuItem(
          value: ListItemMenu.delete,
          child: Text("Delete"),
        )
      ],
    );
  }

  buildAnimatedListItem(
      BuildContext context, int index, Goal goal, Animation animation) {
    var anim = new Tween(
      begin: new Offset(3.0, 0.0),
      end: new Offset(0.0, 0.0),
    ).animate(animation);

    return SlideTransition(
      position: anim,
      child: Container(
        key: Key('${goal.hashCode}'),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Row(children: <Widget>[
                  if (goal.progressIndicator == GoalProgressIndicator.checkbox)
                    Checkbox(
                      onChanged: (value) {
                        goal.progress = value ? 100 : 0;
                        updateGoal(goal);
                        if (value) {
                          _finishGoal(goal);
                        }
                      },
                      value: goal.progress == 100,
                    ),
                  Expanded(
                    child: Text(goal.goalText),
                  ),
                  buildPopupMenu(context, goal)
                ]),
                if (goal.progressIndicator == GoalProgressIndicator.slider)
                  buildProgressInput(context, index, goal),
                if (goal.deadline != null) buildDeadline(goal.deadline),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildListView(List<Goal> goals) {
    return AnimatedList(
      key: _listKey,
      initialItemCount: goals.length,
      itemBuilder: (context, index, animation) =>
          buildAnimatedListItem(context, index, goals[index], animation),
    );
  }

  @override
  Widget build(BuildContext context) {
    final goalMonitoringState = Provider.of<GoalMonitoringState>(context);

    if (goalMonitoringState.openGoals != null) {
      _goals = [];
      goalMonitoringState.openGoals.forEach((g) => _goals.add(g));
      print("build monitoring");
      return Container(
        child: buildListView(_goals),
      );
      // return Center(child: CircularProgressIndicator());
    } else {
      return Center(child: CircularProgressIndicator());
    }

    // return FutureBuilder(
    //   future: goalMonitoringState.getOpenGoalsAsync(),
    //   builder: (BuildContext context, snapshot) {
    //     if (snapshot.hasData) {
    //       if (snapshot.connectionState == ConnectionState.done) {
    //         _goals = snapshot.data;
    //         return Container(
    //           child: buildListView(_goals),
    //         );
    //       }
    //     }
    //     return Center(child: CircularProgressIndicator());
    //   },
    // );
  }
}
