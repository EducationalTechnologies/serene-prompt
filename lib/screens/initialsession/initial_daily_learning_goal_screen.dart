import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serene/shared/ui_helpers.dart';
import 'package:serene/viewmodels/init_session_view_model.dart';

class InitialDailyLearningGoalScreen extends StatefulWidget {
  const InitialDailyLearningGoalScreen({Key key}) : super(key: key);

  @override
  _InitialDailyLearningGoalScreenState createState() =>
      _InitialDailyLearningGoalScreenState();
}

class _InitialDailyLearningGoalScreenState
    extends State<InitialDailyLearningGoalScreen> {
  List<bool> isSelected = [false, false, false, false, false, false, false];

  @override
  Widget build(BuildContext context) {
    var vm = Provider.of<InitSessionViewModel>(context);
    return ListView(children: [
      Text(
        "Setze dir hier ein Ziel für das Lernen mit cabuu.",
        style: Theme.of(context).textTheme.subtitle1,
      ),
      UIHelper.verticalSpaceMedium(),
      Text(
        "Ich will es schaffen, an mindestens",
        style: Theme.of(context).textTheme.subtitle1,
      ),
      UIHelper.verticalSpaceMedium(),
      ToggleButtons(
        children: [
          Text("1"),
          Text("2"),
          Text("3"),
          Text("4"),
          Text("5"),
          Text("6"),
          Text("7"),
        ],
        isSelected: isSelected,
        onPressed: (index) {
          vm.setNumberOfDaysLearningGoal((index + 1).toString());
          setState(() {
            for (int buttonIndex = 0;
                buttonIndex < isSelected.length;
                buttonIndex++) {
              if (buttonIndex == index) {
                isSelected[buttonIndex] = true;
              } else {
                isSelected[buttonIndex] = false;
              }
            }
          });
        },
      ),
      UIHelper.verticalSpaceMedium(),
      Text(
        "Tagen pro Woche mit cabuu zu lernen",
        style: Theme.of(context).textTheme.subtitle1,
      )
    ]);
  }
}
