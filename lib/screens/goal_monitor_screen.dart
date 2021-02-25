import 'dart:async';
import 'package:flutter/material.dart';
import 'package:serene/models/goal.dart';
import 'package:serene/shared/enums.dart';
import 'package:serene/shared/materialized_path.dart';
import 'package:serene/shared/route_names.dart';
import 'package:serene/shared/screen_args.dart';
import 'package:serene/shared/ui_helpers.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:serene/viewmodels/goal_monitoring_view_model.dart';

enum ListItemMenu { delete, edit }

class GoalMonitorScreen extends StatefulWidget {
  @override
  _GoalMonitorScreenState createState() => _GoalMonitorScreenState();
}

class _GoalMonitorScreenState extends State<GoalMonitorScreen> {
  GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      var vm = Provider.of<GoalMonitoringVielModel>(context, listen: false);

      vm.goalAdded = ((goal) => this._addGoalToAnimatedList(goal));
      vm.goalRemoved = ((goal) => this._removeGoalFromAnimatedList(goal));
    });
  }

  @override
  Future dispose() async {
    super.dispose();
  }

  _updateGoal(Goal goal) async {
    await Provider.of<GoalMonitoringVielModel>(context, listen: false)
        .updateGoal(goal);
  }

  _finishGoal(Goal goal) async {
    await Provider.of<GoalMonitoringVielModel>(context, listen: false)
        .completeGoal(goal);
  }

  _deleteGoal(Goal goal) async {
    await Provider.of<GoalMonitoringVielModel>(context, listen: false)
        .deleteGoal(goal);
  }

  _addGoalToAnimatedList(Goal goal) async {
    var vm = Provider.of<GoalMonitoringVielModel>(context, listen: false);
    print("Goal Length: ${vm.openGoals.length}");
    if (_listKey.currentState != null) {
      _listKey.currentState.insertItem(vm.openGoals.length,
          duration: Duration(milliseconds: 250));
    }
  }

  _removeGoalFromAnimatedList(Goal goal) async {
    var vm = Provider.of<GoalMonitoringVielModel>(context, listen: false);
    var index = vm.openGoals.indexOf(goal);
    _listKey.currentState.removeItem(
        index,
        (context, animation) =>
            buildAnimatedListItem(context, index, goal, animation),
        duration: const Duration(milliseconds: 350));
  }

  buildConfirmationDialog(BuildContext context, Goal goal) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Löschen bestätigen"),
            content: Text("Möchtest du dieses Ziel wirklich löschen?"),
            actions: <Widget>[
              ElevatedButton(
                child: Text("Abbrechen"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                child: Text("Löschen"),
                onPressed: () async {
                  _deleteGoal(goal);
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

  buildProgressInput(BuildContext context, int index, Goal goal) {
    return Slider(
      value: goal.progress.toDouble(),
      min: 0,
      max: 100,
      label: "${goal.progress}%",
      divisions: 100,
      onChanged: (double value) {
        setState(() {
          goal.progress = value.toInt();
        });
      },
      onChangeEnd: (double value) {
        print("Gooal end");
        if (value >= 100) {
          _finishGoal(goal);
        } else {
          _updateGoal(goal);
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
                arguments: GoalScreenArguments(goal));
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<ListItemMenu>>[
        PopupMenuItem(value: ListItemMenu.edit, child: Text("Bearbeiten")),
        PopupMenuItem(
          value: ListItemMenu.delete,
          child: Text("Löschen"),
        )
      ],
    );
  }

  buildAnimatedListItem(
      BuildContext context, int index, Goal goal, Animation animation) {
    var vm = Provider.of<GoalMonitoringVielModel>(context, listen: false);
    var anim = new Tween(
      begin: new Offset(3.0, 0.0),
      end: new Offset(0.0, 0.0),
    ).animate(animation);

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        if (vm.openGoals.length == 0) {
          setState(() {});
        }
      }
    });

    var insetValue = MaterializedPath.getDepth(goal.path);

    return SlideTransition(
      position: anim,
      child: Container(
        margin: EdgeInsets.only(left: insetValue * 8.0),
        key: Key('${goal.hashCode}'),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: InkWell(
            onTap: () async {
              await Navigator.pushNamed(context, RouteNames.ADD_GOAL,
                  arguments: GoalScreenArguments(goal));
              Provider.of<GoalMonitoringVielModel>(context, listen: false)
                  .refetchGoals();
            },
            child: Column(
              children: <Widget>[
                Row(children: <Widget>[
                  if (goal.progressIndicator == GoalProgressIndicator.checkbox)
                    Checkbox(
                      onChanged: (value) {
                        goal.progress = value ? 100 : 0;
                        if (value) {
                          _finishGoal(goal);
                        }
                      },
                      value: goal.progress == 100,
                    ),
                  Expanded(
                    child: Text(goal.goalText, style: TextStyle(fontSize: 20)),
                  ),
                  buildPopupMenu(context, goal)
                ]),
                if (goal.progressIndicator == GoalProgressIndicator.slider)
                  buildProgressInput(context, index, goal),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    if (goal.deadline != null) buildDeadline(goal.deadline),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final goalMonitoringState = Provider.of<GoalMonitoringVielModel>(context);
    if (goalMonitoringState.openGoals != null) {
      print("build monitoring");
      if (goalMonitoringState.openGoals.length > 0) {
        return AnimatedList(
          key: _listKey,
          initialItemCount: goalMonitoringState.openGoals.length,
          itemBuilder: (context, index, animation) => buildAnimatedListItem(
              context, index, goalMonitoringState.openGoals[index], animation),
        );
      } else {
        return Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/illustrations/undraw_plans_y8ru.png"),
            fit: BoxFit.scaleDown,
          )),
          child: Padding(
            padding: EdgeInsets.only(bottom: 50),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                "Du hast derzeit keine offenen Ziele",
                style: Theme.of(context).textTheme.headline4,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      }
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }
}
