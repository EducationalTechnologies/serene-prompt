import 'package:flutter/material.dart';
import 'package:serene/locator.dart';
import 'package:serene/services/reward_service.dart';
import 'package:serene/widgets/serene_appbar.dart';
import 'package:serene/widgets/timeline.dart';

class RewardSelectionScreen extends StatefulWidget {
  RewardSelectionScreen() : super();

  @override
  _RewardSelectionScreenState createState() => _RewardSelectionScreenState();
}

class _RewardSelectionScreenState extends State<RewardSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SereneAppBar(),
      body: Container(
          child: Timeline(
              indicatorColor: Theme.of(context).primaryColor,
              children: [
            _buildUnlockItem(
                "Weltraum", "assets/illustrations/mascot_space.png", 1, true),
            _buildUnlockItem(
                "Meer", "assets/illustrations/mascot_ocean.png", 1, true),
            _buildUnlockItem(
                "Flugzeug", "assets/illustrations/mascot_plane.png", 1, false),
            _buildUnlockItem("Pyramiden",
                "assets/illustrations/mascot_pyramid.png", 1, false),
          ])),
    );
    // return Scaffold(
    //     appBar: SereneAppBar(),
    //     body: Container(
    //       child: Container(
    //         child: Column(
    //           children: [
    //             Text(
    //                 "Hier kannst du deine Punkte gegen Hintergründe einlösen."),
    //             Text(
    //                 "Sobald du die Hintergründe gekauft hast, werden sie in voller Pracht auf dem Hauptbildschirm erscheinen."),
    //             UIHelper.verticalSpaceMedium(),
    //             Text("Du hast derzeit 120 🥇"),
    //             UIHelper.verticalSpaceMedium(),
    //             Expanded(
    //               child: GridView.count(
    //                 crossAxisCount: 2,
    //                 children: [
    //                   _buildPreviewItem("Weltraum",
    //                       "assets/illustrations/mascot_space_preview.png", 10),
    //                   _buildPreviewItem("Unter Wasser",
    //                       "assets/illustrations/mascot_ocean_preview.png", 20),
    //                   _buildPreviewItem("Weltraum",
    //                       "assets/illustrations/mascot_space_preview.png", 30),
    //                   _buildPreviewItem("Unter Wasser",
    //                       "assets/illustrations/mascot_ocean_preview.png", 40),
    //                   _buildPreviewItem("Weltraum",
    //                       "assets/illustrations/mascot_space_preview.png", 50),
    //                   _buildPreviewItem("Unter Wasser",
    //                       "assets/illustrations/mascot_ocean_preview.png", 60),
    //                 ],
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ));
  }

  _buildUnlockItem(String header, String path, int price, bool unlocked) {
    var rewardService = locator.get<RewardService>();

    var isSelected = rewardService.backgroundImagePath == path;
    return Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            blurRadius: .5,
            spreadRadius: 1.0,
            color: Colors.black.withOpacity(.12))
      ], borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        children: [
          Text(
            header,
            style: Theme.of(context).textTheme.headline6,
          ),
          if (unlocked)
            Image(
              image: AssetImage(path),
              width: 130,
              height: 110,
            ),
          if (!unlocked)
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.grey,
                BlendMode.saturation,
              ),
              child: Image(
                image: AssetImage(path),
                width: 130,
                height: 110,
              ),
            ),
          Divider(),
          if (isSelected)
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.green[300]),
              onPressed: () {
                setState(() {});
              },
              child: Text("Ausgewählt"),
            ),
          if (!isSelected)
            ElevatedButton(
              onPressed: () {
                setState(() {
                  rewardService.setBackgroundImagePath(path);
                });
              },
              child: Text("Aktivieren"),
            )
        ],
      ),
    );
  }

  _buildPreviewItem(String header, String path, int price, bool unlocked) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            blurRadius: .5,
            spreadRadius: 1.0,
            color: Colors.black.withOpacity(.12))
      ], borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        children: [
          Text(
            header,
            style: Theme.of(context).textTheme.headline6,
          ),
          Image(
            image: AssetImage(path),
            width: 130,
            height: 110,
          ),
          Divider(),
          Text(
            "${price.toString()} 🥇",
          )
        ],
      ),
    );
  }
}
