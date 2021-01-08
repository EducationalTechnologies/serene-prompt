import 'package:flutter/material.dart';

class InitialExplanationScreen extends StatefulWidget {
  InitialExplanationScreen({Key key}) : super(key: key);

  @override
  _InitialExplanationScreenState createState() =>
      _InitialExplanationScreenState();
}

class _InitialExplanationScreenState extends State<InitialExplanationScreen> {
  _buildExplanationCard(String title, String subtitle) {
    return Card(
        color: Colors.orange[50],
        child: Container(
          padding: EdgeInsets.all(10),
          child: ListTile(
            title: Text(title, style: TextStyle(fontSize: 20)),
            subtitle: Text(
              subtitle,
              style: TextStyle(fontSize: 18),
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView(
      children: [
        _buildExplanationCard("Worum geht es?",
            "In den folgenden 30 Tagen sollst du diese App verwenden, um dir Wenn-Dann-Pläne zu merken"),
        _buildExplanationCard("Was sollst du machen?",
            "Jeden Tag sollst du dir Morgens einen Wenn-Dann-Plan merken, und wirst dann später gefragt, wie gut du dir diesen Plan merken konntest"),
        _buildExplanationCard("Was sollst du machen?",
            "Du sollst dir die Wenn-Dann-Pläne nicht aufschreiben, sondern nur merken"),
      ],
    ));
  }
}
