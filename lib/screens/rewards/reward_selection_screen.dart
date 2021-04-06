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
    List<Widget> unlockItems = [];
    var rewardService = locator<RewardService>();
    for (var bg in rewardService.backgrounds) {
      var unlocked = rewardService.daysActive >= bg.requiredDays;
      unlockItems
          .add(_buildUnlockItem(bg.name, bg.path, bg.requiredDays, unlocked));
    }

    return Scaffold(
      appBar: SereneAppBar(title: "Wähle einen neuen Hintergrud"),
      body: Container(
          child: Timeline(
              indicatorColor: Theme.of(context).primaryColor,
              children: [...unlockItems])),
    );
  }

  _buildUnlockItem(String header, String path, int price, bool unlocked) {
    var rewardService = locator.get<RewardService>();

    Widget unlockButton;

    if (unlocked) {
      unlockButton = ElevatedButton(
        onPressed: () {
          setState(() {
            rewardService.setBackgroundImagePath(path);
          });
        },
        child: Text("Aktivieren"),
      );
    } else {
      unlockButton = ElevatedButton(
        style: ElevatedButton.styleFrom(primary: Colors.blue[300]),
        onPressed: () {
          setState(() {
            // rewardService.setBackgroundImagePath(path);
          });
        },
        child: Text("Wird nach $price Tagen Aktivität freigeschaltet"),
      );
    }

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
          if (!isSelected) unlockButton
        ],
      ),
    );
  }
}
