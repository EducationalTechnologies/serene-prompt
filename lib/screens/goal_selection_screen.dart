import 'package:flutter/material.dart';
import 'package:serene/models/goal.dart';
import 'package:serene/shared/ui_helpers.dart';
import 'package:serene/state/goal_monitoring_state.dart';
import 'package:serene/state/goal_shielding_state.dart';
import 'package:provider/provider.dart';

class GoalSelectionScreen extends StatefulWidget {
  @override
  _GoalSelectionScreenState createState() => _GoalSelectionScreenState();
}

class _GoalSelectionScreenState extends State<GoalSelectionScreen> {
  bool _showText = false;

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
    GoalShieldingState goalShieldingState =
        Provider.of<GoalShieldingState>(context);

    if (goalShieldingState.openGoals != null) {
      print("build SHIELDING LIST");
      if (goalShieldingState.openGoals.length > 0) {
        return Container(
          child: Column(children: <Widget>[
            UIHelper.verticalSpaceMedium(),
            Text("Ziel auswählen"),
            UIHelper.verticalSpaceMedium(),
            Expanded(
              child: GoalSelectionList(),
            ),
            // this._showText ? buildNewGoalRow() : buildAddGoalButton()
          ]),
        );
      } else {
        return Container(
          child: Center(
            child: Text(
              "Du hast derzeit keine offenen Ziele",
              style: Theme.of(context).textTheme.display1,
              textAlign: TextAlign.center,
            ),
          ),
        );
      }

      // return Center(child: CircularProgressIndicator());
    } else {
      return Center(child: CircularProgressIndicator());
    }
    // return Container(
    //     child: FutureBuilder<List<Goal>>(
    //   future: goalShieldingState.getGoalsAsync(),
    //   builder: (context, snapshot) {
    //     if (snapshot.hasData &&
    //         snapshot.connectionState == ConnectionState.done) {
    //       return Column(children: <Widget>[
    //         UIHelper.verticalSpaceMedium(),
    //         Text("Ziel auswählen"),
    //         UIHelper.verticalSpaceMedium(),
    //         Expanded(
    //           child: GoalSelectionList(),
    //         ),
    //         // this._showText ? buildNewGoalRow() : buildAddGoalButton()
    //       ]);
    //     }
    //     return Center(child: CircularProgressIndicator());
    //   },
    // ));
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
    goalShieldingState.selectedGoal = goalShieldingState.openGoals[index];
    setState(() {
      _selectedIndex = index;
    });
    print(goalShieldingState.selectedGoal);
  }

  @override
  Widget build(BuildContext context) {
    GoalShieldingState goalShieldingState =
        Provider.of<GoalShieldingState>(context);
    _selectedIndex =
        goalShieldingState.openGoals.indexOf(goalShieldingState.selectedGoal);
    print("Selected Index: $_selectedIndex");
    return Container(
        child: ListView.builder(
      itemCount: goalShieldingState.openGoals.length,
      itemBuilder: (context, index) {
        return Card(
          child: Container(
              // TODO: Change color to something more pretty
              color: _selectedIndex == index
                  ? Colors.orange[200]
                  : Colors.transparent,
              child: ListTile(
                title: Text(goalShieldingState.openGoals[index].goalText),
                onTap: () {
                  _onSelected(index);
                },
              )),
        );
      },
    ));
  }
}
