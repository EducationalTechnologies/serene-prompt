import 'package:flutter/material.dart';
import 'package:serene/shared/ui_helpers.dart';

class InitialRewardScreenSecond extends StatelessWidget {
  const InitialRewardScreenSecond({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text("Danke für deine Mitarbeit!"),
          Text("Du hast dir damit weitere"),
          Text("6 Punkte"),
          Text("verdient!"),
          UIHelper.verticalSpaceMedium(),
        ],
      ),
    );
  }
}
