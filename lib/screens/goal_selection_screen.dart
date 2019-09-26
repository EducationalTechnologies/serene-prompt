import 'package:flutter/material.dart';
import 'package:serene/models/goal.dart';
import 'package:serene/shared/text_styles.dart';
import 'package:serene/shared/ui_helpers.dart';
import 'package:serene/state/goal_monitoring_state.dart';
import 'package:serene/state/goal_shielding_state.dart';
import 'package:serene/state/goal_state.dart';
import 'package:provider/provider.dart';

class GoalSelectionScreen extends StatefulWidget {
  @override
  _GoalSelectionScreenState createState() => _GoalSelectionScreenState();
}

class _GoalSelectionScreenState extends State<GoalSelectionScreen> {
  bool _showText = false;
  Goal _newGoal = new Goal();

  buildNewGoalRow() {
    return TextField(
      autofocus: true,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      onSubmitted: (term) {
        finishGoalInput();
      },
      onChanged: (value) {
        setState(() {
          _newGoal.goalText = value;
        });
      },
      // onEditingComplete: () {
      //   finishGoalInput();
      // },
      decoration: InputDecoration(icon: Icon(Icons.pages)),
    );
  }

  finishGoalInput() {
    setState(() {
      _showText = false;
    });

    _newGoal.deadline = null;
    _newGoal.progress = 0;

    Provider.of<GoalState>(context).saveNewGoal(_newGoal);
  }

  buildAddGoalButton() {
    return SizedBox(
        width: double.infinity,
        height: 60.0,
        // height: double.infinity,
        child: new RaisedButton(
          child: Text("Neues Ziel"),
          onPressed: () {
            setState(() {
              _showText = !_showText;
            });
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    GoalMonitoringState goalMonitoringState = Provider.of<GoalMonitoringState>(context);

    return Container(
        child: FutureBuilder<List<Goal>>(
      future: goalMonitoringState.getGoalsAsync(),
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          return Column(children: <Widget>[
            UIHelper.verticalSpaceMedium(),
            Text("Ziel auswählen", style: subHeaderStyle),
            UIHelper.verticalSpaceMedium(),
            Expanded(
              child: GoalSelectionList(),
            ),
            // this._showText ? buildNewGoalRow() : buildAddGoalButton()
          ]);
        }
        return Center(child: CircularProgressIndicator());
      },
    ));
  }
}

class GoalSelectionList extends StatefulWidget {
  @override
  _GoalSelectionListState createState() => _GoalSelectionListState();
}

class _GoalSelectionListState extends State<GoalSelectionList> {
  int _selectedIndex;

  _onSelected(int index) {
    var goalShieldingState = Provider.of<GoalShieldingState>(context);
    var goalMonitoringState = Provider.of<GoalMonitoringState>(context);
    goalShieldingState.selectedGoal = goalMonitoringState.goals[index];
    setState(() {
      _selectedIndex = index;
    });
    print(goalShieldingState.selectedGoal);
  }

  @override
  Widget build(BuildContext context) {
    GoalMonitoringState goalMonitoringState =
        Provider.of<GoalMonitoringState>(context);
    GoalShieldingState goalShieldingState =
        Provider.of<GoalShieldingState>(context);
    _selectedIndex =
        goalMonitoringState.goals.indexOf(goalShieldingState.selectedGoal);
    print("Selected Index: $_selectedIndex");
    return Container(
        child: ListView.builder(
      itemCount: goalMonitoringState.goals.length,
      itemBuilder: (context, index) {
        return Card(
          child: Container(
              // TODO: Change color to something more pretty
              color: _selectedIndex == index
                  ? Colors.orange[200]
                  : Colors.transparent,
              child: ListTile(
                title: Text(goalMonitoringState.goals[index].goalText),
                onTap: () {
                  _onSelected(index);
                },
              )),
        );
      },
    ));
  }
}
