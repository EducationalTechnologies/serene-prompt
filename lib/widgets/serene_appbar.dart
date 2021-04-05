import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:serene/locator.dart';
import 'package:serene/services/reward_service.dart';
import 'package:serene/shared/ui_helpers.dart';

class SereneAppBar extends StatefulWidget with PreferredSizeWidget {
  final String title;

  const SereneAppBar({Key key, this.title = ""}) : super(key: key);

  @override
  _SereneAppBarState createState() => _SereneAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(50);
}

class _SereneAppBarState extends State<SereneAppBar> {
  getRewardDisplay() {}

  @override
  AppBar build(BuildContext context) {
    var rewardService = locator.get<RewardService>();
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        FutureBuilder(
            future: rewardService.initialized,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(
                  "${rewardService.score}💎",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.yellow[800]),
                );
                return Row(
                  children: [
                    Image(
                        image: AssetImage("assets/rewards/crown_12.png"),
                        width: 34,
                        height: 34,
                        fit: BoxFit.scaleDown),
                    Text(
                      "${rewardService.score.toString()}",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.yellow[800]),
                    ),
                  ],
                );
              } else {
                return Text("0💎",
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.yellow[800]));
              }
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
