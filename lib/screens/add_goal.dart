import 'package:flutter/material.dart';
import 'package:implementation_intentions/models/goal.dart';
import 'package:implementation_intentions/services/database_helpers.dart';
import 'package:implementation_intentions/shared/app_colors.dart';
import 'package:implementation_intentions/shared/text_styles.dart';
import 'package:implementation_intentions/shared/ui_helpers.dart';
import 'package:implementation_intentions/state/goal_state.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddGoal extends StatefulWidget {
  AddGoal() : super();

  @override
  AddGoalState createState() => AddGoalState();
}

class AddGoalState extends State<AddGoal> {
  DateTime selectedDate = DateTime.now();
  String _goalText = "";

  _submitGoal() {
    var goal = new Goal();
    goal.deadline = selectedDate;
    goal.goal = _goalText;
    goal.progress = 0;

    DBProvider.db.insertGoal(goal);
  }

  Future<Null> _selectDate(BuildContext context) async {
    final appState = Provider.of<GoalState>(context);
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      appState.currentGoal.deadline = picked;

    // final TimeOfDay pickedTime = await showTimePicker(
    //   context: context,
    //   initialTime: TimeOfDay.fromDateTime(appState.currentGoal.deadline),
    // );

    // if (pickedTime != null) {
    //   var newDeadline = new DateTime(
    //       appState.currentGoal.deadline.year,
    //       appState.currentGoal.deadline.month,
    //       appState.currentGoal.deadline.day,
    //       pickedTime.hour,
    //       pickedTime.minute);
    //   appState.currentGoal.deadline = newDeadline;
    // }
  }

  Widget buildTextEntry() {
    return Column(
      children: <Widget>[
        // Text(
        //   "Ziel",
        //   textAlign: TextAlign.left,
        //   style: subHeaderStyle,
        // ),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.all(15.0),
          decoration: BoxDecoration(
              color: Colors.grey[100], borderRadius: BorderRadius.circular(5)),
          child: TextField(
            decoration: InputDecoration(labelText: "Gib dein Lernziel ein"),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            onChanged: (text) {
              setState(() {
                _goalText = text;
              });
            },
          ),
        )
      ],
    );
  }

  Widget buildDatePicker() {
    final appState = Provider.of<GoalState>(context);
    var dateText =
        DateFormat('dd.MM.yyy').format(appState.currentGoal.deadline);
    var timeText = DateFormat('kk:mm').format(appState.currentGoal.deadline);
    return Column(
      children: <Widget>[
        Text(
          "Deadline",
          textAlign: TextAlign.left,
          style: subHeaderStyle,
        ),
        UIHelper.verticalSpaceMedium(),
        InkWell(
            onTap: () {
              _selectDate(context);
            },
            child: Container(
              padding: EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(5)),
              child: Row(
                children: [
                  Icon(Icons.calendar_today, color: Colors.black),
                  UIHelper.horizontalSpaceSmall(),
                  Text(
                    "$dateText",
                    style: pickerStyle,
                  ),
                  UIHelper.horizontalSpaceMedium(),
                  // Icon(Icons.timer, color: Colors.black),
                  // UIHelper.horizontalSpaceSmall(),
                  // Text(
                  //   "$timeText",
                  //   style: pickerStyle,
                  // ),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20.0, right: 20.0),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            UIHelper.verticalSpaceMedium(),
            buildTextEntry(),
            UIHelper.verticalSpaceLarge(),
            buildDatePicker(),
            UIHelper.verticalSpaceLarge(),
            SizedBox(
                width: double.infinity,
                height: 80,
                child: RaisedButton(
                  color: accentColor,
                  onPressed: () {
                    _submitGoal();
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(55.0)),
                  child: Text("Speichern", style: TextStyle(fontSize: 20)),
                ))
          ],
        ),
      ),
    );
  }
}
