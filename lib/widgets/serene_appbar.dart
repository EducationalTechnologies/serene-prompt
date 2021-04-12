import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:prompt/locator.dart';
import 'package:prompt/services/reward_service.dart';
import 'package:prompt/shared/ui_helpers.dart';

class SereneAppBar extends StatefulWidget with PreferredSizeWidget {
  final String title;

  const SereneAppBar({Key key, this.title = ""}) : super(key: key);

  @override
  _SereneAppBarState createState() => _SereneAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(50);
}

class _SereneAppBarState extends State<SereneAppBar> {
  StreamController<int> scoreStream;
  getRewardDisplay() {}

  @override
  void initState() {
    super.initState();
    var rewardService = locator.get<RewardService>();
    scoreStream = rewardService.controller;

    rewardService.retrieveScore();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  AppBar build(BuildContext context) {
    var rewardService = locator.get<RewardService>();
    var scoreValue = rewardService.scoreValue;
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        StreamBuilder(
            stream: rewardService.controller.stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active ||
                  snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return TextButton(
                      onPressed: () {},
                      child: Text(
                        "${snapshot.data}💎",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[850]),
                      ));
                }
              }
              return Text("${rewardService.scoreValue}💎",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.yellow[800]));
            }),
        UIHelper.horizontalSpaceMedium()
      ],
      title: Text(""),
      textTheme:
          TextTheme(headline6: TextStyle(color: Colors.black, fontSize: 22)),
      centerTitle: true,
    );
  }
}
