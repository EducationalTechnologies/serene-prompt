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
  }

  Widget buildTextEntry(ImplementationIntentionModel intention) {
    return Column(
      children: <Widget>[
        SizedBox(height: 100),
        Text("My goal is...:", textAlign: TextAlign.left,),
        SizedBox(height: 10),
        TextField(
          onChanged: (text) {
            intention.setGoal(text);
          },
        )
      ],
    );
  }

  Widget buildDatePicker() {
    final intention = Provider.of<ImplementationIntentionModel>(context);

    var dateText = DateFormat('dd.MM.yyy - kk:mm').format(intention.deadline);
    return Column(
      children: <Widget>[
        SizedBox(height: 50),
        Text(
          "Until...",
          textAlign: TextAlign.left,
        ),
        SizedBox(height: 10),
        GestureDetector(
            onTap: () {
              _selectDate(context);
            },
            child: Row(children: [
              Icon(Icons.calendar_today, color: Colors.black),
              Text("$dateText")
            ]))
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
          buildTextEntry(intention),
          buildDatePicker(),
        ],
      ),
    );
  }
}
