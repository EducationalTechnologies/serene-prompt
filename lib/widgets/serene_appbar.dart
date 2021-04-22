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
  getRewardDisplay() {}

  @override
  void initState() {
    super.initState();
    var rewardService = locator.get<RewardService>();

    rewardService.retrieveScore();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  AppBar build(BuildContext context) {
    var rewardService = locator.get<RewardService>();
    return AppBar(
      // TODO: REMOVE SEMI_TRANSPARENT ICON BEFORE RELEASE
      leading: Opacity(
          opacity: 0.0,
          child: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          )),
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        TextButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon(Icons.brush),
                // Text(
                //   "Hintergrund ändern",
                //   style: TextStyle(
                //     color: Colors.black,
                //     fontSize: 20,
                //   ),
                // )
              ],
            ),
            onPressed: () async {
              // var rewardWidget = RewardSelectionScreen();
              // await Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => rewardWidget));
              setState(() {});
            }),
        UIHelper.horizontalSpaceMedium(),
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
                            fontSize: 20,
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
