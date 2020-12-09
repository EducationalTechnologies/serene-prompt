import 'package:flutter/material.dart';
import 'package:serene/shared/ui_helpers.dart';
import 'package:provider/provider.dart';
import 'package:serene/viewmodels/goal_shielding_view_model.dart';

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
    GoalShieldingViewModel goalShieldingState =
        Provider.of<GoalShieldingViewModel>(context);

    if (goalShieldingState.openGoals != null) {
      print("build SHIELDING LIST");
      if (goalShieldingState.openGoals.length > 0) {
        return Container(
          child: Column(children: <Widget>[
            UIHelper.verticalSpaceMedium(),
            Text(
              "Wähle die Ziele aus, an denen du heute arbeiten möchtest",
              style: Theme.of(context).textTheme.subtitle1,
            ),
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
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Du hast noch keine Lernpläne erstellt",
                style: Theme.of(context).textTheme.headline4,
                textAlign: TextAlign.center,
              ),
              UIHelper.verticalSpaceLarge(),
              Text(
                "Lege ein an, indem du unten auf das + drückst",
                style: Theme.of(context).textTheme.headline4,
                textAlign: TextAlign.center,
              ),
            ],
          )),
        );
      }
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }
}

class GoalSelectionList extends StatefulWidget {
  @override
  _GoalSelectionListState createState() => _GoalSelectionListState();
}

class _GoalSelectionListState extends State<GoalSelectionList> {
  int _selectedIndex;

  _onSelected(int index) {
    var goalShieldingState =
        Provider.of<GoalShieldingViewModel>(context, listen: false);
    goalShieldingState.toggleGoal(goalShieldingState.openGoals[index]);
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    GoalShieldingViewModel vm =
        Provider.of<GoalShieldingViewModel>(context, listen: false);

    return Container(
        child: ListView.builder(
      itemCount: vm.openGoals.length,
      itemBuilder: (context, index) {
        var isSelected = vm.selectedGoals.contains(vm.openGoals[index]);
        return Card(
          color: isSelected ? Theme.of(context).selectedRowColor : Colors.white,
          child: Container(
              child: ListTile(
            title: Text(vm.openGoals[index].goalText),
            onTap: () {
              _onSelected(index);
            },
          )),
        );
      },
    ));
  }
}
