import 'package:flutter/material.dart';

class LearnGoalEnterScreen extends StatelessWidget {
  const LearnGoalEnterScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
              "Setze dir hier ein Ziel für das Lernen mit cabuu: Ich will es schaffen, an mindestens"),
          TextField(),
          Text("Tagen pro Woche mit cabuu zu lernen"),
        ],
      ),
    );
  }
}
