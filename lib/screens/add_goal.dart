import 'package:flutter/material.dart';
import 'package:implementation_intentions/models/implementation_intention.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddGoal extends StatefulWidget {
  AddGoal() : super();

  @override
  AddGoalState createState() => AddGoalState();
}

class AddGoalState extends State<AddGoal> {
  DateTime selectedDate = DateTime.now();

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

  Widget buildTextEntry(ImplementationIntentionModel intention) {
    return Column(
      children: <Widget>[
        Text(
          "My goal:",
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.display1,
        ),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.all(15.0),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(15)),
          child: TextField(
            keyboardType: TextInputType.multiline,
            onChanged: (text) {
              intention.setGoal(text);
            },
          ),
        )
      ],
    );
  }

  getTextStyleForPicker() {
    return TextStyle(fontWeight: FontWeight.w600, fontSize: 18);
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
          style: Theme.of(context).textTheme.display1,
        ),
        SizedBox(height: 20),
        InkWell(
            onTap: () {
              _selectDate(context);
            },
            child: Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.black),
                SizedBox(width: 20),
                Text(
                  "$dateText",
                  style: getTextStyleForPicker(),
                ),
                SizedBox(width: 20),
                Icon(Icons.timer, color: Colors.black),
                SizedBox(width: 20),
                Text(
                  "$timeText",
                  style: getTextStyleForPicker(),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final intention = Provider.of<ImplementationIntentionModel>(context);

    return Container(
      margin: EdgeInsets.only(left: 20.0, right: 20.0),
      child: Column(
        children: <Widget>[
          SizedBox(height: 50),
          buildTextEntry(intention),
          SizedBox(height: 50),
          buildDatePicker(),
        ],
      ),
    );
  }
}
