import 'package:flutter/material.dart';

class GoalShieldingPleaScreen extends StatelessWidget {
  const GoalShieldingPleaScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Text(
        "Versuche, den auf der folgenden Seite erscheinenden Satz zu verinnerlichen wenn du beim Lernen auf dein Hindernis stößt",
        style: Theme.of(context).textTheme.headline1,
      ),
    ));
  }
}
