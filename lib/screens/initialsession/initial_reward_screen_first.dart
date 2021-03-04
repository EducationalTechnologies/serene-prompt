import 'package:flutter/material.dart';
import 'package:serene/shared/ui_helpers.dart';

class InitialRewardScreenFirst extends StatelessWidget {
  const InitialRewardScreenFirst({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text("Danke für deine Mitarbeit bis hierhin!"),
          Text("Du hast dir damit deine ersten"),
          Text("6 Punkte"),
          Text("verdient!"),
          UIHelper.verticalSpaceMedium(),
          Text(
              "Jezt haben wir noch ein paar Fragen und eine Aufgabe für dich, dann hast du es geschafft!"),
        ],
      ),
    );
  }
}
