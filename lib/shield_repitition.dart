import 'package:flutter/material.dart';

class ShieldRepitition extends StatefulWidget {
  @override
  _ShieldRepititionState createState() => _ShieldRepititionState();
}

class _ShieldRepititionState extends State<ShieldRepitition> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text("When I start watching TV, I will turn it off"),
          SizedBox(height: 10),
          Text("Repeat this mentally three times"),
          SizedBox(height: 5),
          RaisedButton(
            onPressed: () {},
            child: const Text('1', style: TextStyle(fontSize: 20)),
          ),
        ],
      ),
    );
  }
}
