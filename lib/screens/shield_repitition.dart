import 'package:flutter/material.dart';
import 'package:implementation_intentions/models/implementation_intention.dart';
import 'package:provider/provider.dart';

class ShieldRepitition extends StatefulWidget {
  @override
  _ShieldRepititionState createState() => _ShieldRepititionState();
}

class _ShieldRepititionState extends State<ShieldRepitition> {
  buildShieldingText() {
    final intention = Provider.of<ImplementationIntentionModel>(context);
    return RichText(
        text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
          TextSpan(
              text: "When I start ",
              style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: intention.hindrance),
          TextSpan(text: " I will "),
          TextSpan(text: "Continue here and add the shieldings")
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(height: 50),
          buildShieldingText(),
          SizedBox(height: 50),
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
