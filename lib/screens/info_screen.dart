import 'package:flutter/material.dart';

class InfoScreen extends StatefulWidget {
  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  @override
  Widget build(BuildContext context) {

    
    return Container(
      child: Column(children: <Widget>[
        Text("Current User: ")
      ],),
    );
  }
}