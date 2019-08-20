import 'package:flutter/material.dart';
import 'package:implementation_intentions/models/goal.dart';
import 'package:implementation_intentions/shared/text_styles.dart';
import 'package:implementation_intentions/shared/ui_helpers.dart';
import 'package:implementation_intentions/state/goal_shielding_state.dart';
import 'package:implementation_intentions/state/goal_state.dart';
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
          _newGoal.goal = value;
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
    var shieldingState = Provider.of<GoalShieldingState>(context);
    var goalState = Provider.of<GoalState>(context);
    // if (MediaQuery.of(context).viewInsets.bottom == 0) {
    //   setState(() {
    //     _showText = false;
    //   });
    // }
    return Container(
        child: FutureBuilder<List<Goal>>(
      future: goalState.goals,
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
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var goalState = Provider.of<GoalState>(context);
    print("Calling Build Goal List");
    return Container(
      // TOOD: Lift FutureBuilder up
        child: FutureBuilder<List<Goal>>(
            future: goalState.goals,
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                List<Goal> goals = snapshot.data;
                return ListView.builder(
                  itemCount: goals.length,
                  itemBuilder: (context, index) {
                    return Container(
                        // TODO: Change color to something more pretty
                        color: _selectedIndex == index
                            ? Colors.orange[200]
                            : Colors.transparent,
                        child: ListTile(
                          title: Text(goals[index].goal),
                          onTap: () {
                            _onSelected(index);
                          },
                        ));
                  },
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }
}
