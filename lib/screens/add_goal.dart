import 'package:flutter/material.dart';
import 'package:implementation_intentions/models/goal.dart';
import 'package:implementation_intentions/models/implementation_intention.dart';
import 'package:implementation_intentions/services/database_helpers.dart';
import 'package:implementation_intentions/shared/text_styles.dart';
import 'package:implementation_intentions/shared/ui_helpers.dart';
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
    final intention = Provider.of<ImplementationIntentionModel>(context);
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) intention.deadline = picked;

    final TimeOfDay pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(intention.deadline),
    );

    if (pickedTime != null) {
      var newDeadline = new DateTime(
          intention.deadline.year,
          intention.deadline.month,
          intention.deadline.day,
          pickedTime.hour,
          pickedTime.minute);
      intention.deadline = newDeadline;
    }
  }

  Widget buildTextEntry() {
    final intention = Provider.of<ImplementationIntentionModel>(context);

    return Column(
      children: <Widget>[
        Text(
          "My goal:",
          textAlign: TextAlign.left,
          style: subHeaderStyle,
        ),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.all(15.0),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(15)),
          child: TextField(
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            onChanged: (text) {
              intention.setGoal(text);
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
    final intention = Provider.of<ImplementationIntentionModel>(context);

    var dateText = DateFormat('dd.MM.yyy').format(intention.deadline);
    var timeText = DateFormat('kk:mm').format(intention.deadline);
    return Column(
      children: <Widget>[
        Text(
          "Until",
          textAlign: TextAlign.left,
          style: subHeaderStyle,
        ),
        SizedBox(height: 20),
        InkWell(
            onTap: () {
              _selectDate(context);
            },
            child: Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.black),
                UIHelper.horizontalSpaceSmall(),
                Text(
                  "$dateText",
                  style: pickerStyle,
                ),
                UIHelper.horizontalSpaceMedium(),
                Icon(Icons.timer, color: Colors.black),
                UIHelper.horizontalSpaceSmall(),
                Text(
                  "$timeText",
                  style: pickerStyle,
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20.0, right: 20.0),
      child: Column(
        children: <Widget>[
          UIHelper.verticalSpaceMedium(),
          buildTextEntry(),
          UIHelper.verticalSpaceLarge(),
          buildDatePicker(),
          UIHelper.verticalSpaceLarge(),
          SizedBox(
              width: 250,
              height: 80,
              child: RaisedButton(
                onPressed: () {
                  _submitGoal();
                },
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(15.0)),
                child: Text("Submit", style: TextStyle(fontSize: 20)),
              ))
        ],
      ),
    );
  }
}
