import 'package:flutter/material.dart';

class ReflectScreen extends StatefulWidget {
  @override
  _ReflectScreenState createState() => _ReflectScreenState();
}

class _ReflectScreenState extends State<ReflectScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[
        Text("this is the reflect screen"),
        RaisedButton(child: Text("Fetch Goals"), onPressed: () {}),
        Expanded(
          child: Text("Here will come some graph ya know"),
        )
      ],
    ));
  }
}
