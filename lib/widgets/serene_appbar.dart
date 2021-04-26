import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:prompt/locator.dart';
import 'package:prompt/services/reward_service.dart';
import 'package:prompt/shared/ui_helpers.dart';
import 'package:prompt/screens/info_screen.dart';

class SereneAppBar extends StatefulWidget with PreferredSizeWidget {
  final String title;
  final bool showBackButton;

  const SereneAppBar({Key key, this.title = "", this.showBackButton = false})
      : super(key: key);

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
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: widget.showBackButton,
      elevation: 0,
      actions: [
        // IconButton(
        //     icon: Icon(Icons.info_outline),
        //     onPressed: () async {
        //       await Navigator.push(context,
        //           MaterialPageRoute(builder: (context) => InfoScreen()));
        //       setState(() {});
        //     }),
        TextButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.info_outline),
                Text(
                  "Über PROMPT",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                )
              ],
            ),
            onPressed: () async {
              await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => InfoScreen()));
              setState(() {});
            }),
        UIHelper.horizontalSpaceSmall(),
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
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black));
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
