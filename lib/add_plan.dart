import 'package:flutter/material.dart';

class AddPlan extends StatefulWidget {
  AddPlan() : super();

  @override
  AddPlanState createState() => AddPlanState();
}

class AddPlanState extends State<AddPlan> {
  DateTime selectedDate = DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Widget buildTextEntry() {
    return Column(
      children: <Widget>[
        SizedBox(height: 100),
        Text("Add your goal:", textAlign: TextAlign.center),
        SizedBox(height: 10),
        TextField()
      ],
    );
  }

  Widget buildDatePicker() {
    return Column(
      children: <Widget>[
        SizedBox(height: 100),
        Text("Until...", textAlign: TextAlign.center),
        SizedBox(height: 10),
        GestureDetector(
            onTap: () {
              _selectDate(context);
            },
            child: Text("${selectedDate.toLocal()}"))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          children: <Widget>[buildTextEntry(), buildDatePicker(),
          FloatingActionButton(
            onPressed: () {},
            child: Icon(Icons.arrow_forward),
            backgroundColor: Colors.orangeAccent,
          )],
        ),
        alignment: Alignment(0.0, 0.0),
      ),
    ));
  }
}
