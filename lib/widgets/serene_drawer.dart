import 'package:flutter/material.dart';
import 'package:serene/locator.dart';
import 'package:serene/services/notification_service.dart';
import 'package:serene/services/user_service.dart';
import 'package:serene/shared/enums.dart';
import 'package:serene/shared/route_names.dart';
import 'package:serene/shared/screen_args.dart';
import 'package:serene/widgets/version_info.dart';

class SereneDrawer extends StatelessWidget {
  SereneDrawer();

  _buildDrawerItem({IconData icon, String text, GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          ),
        ],
      ),
      onTap: onTap,
    );
  }

  buildLDTSelection(BuildContext context) {
    List trials = ["0_1", "1", "2", "3", "4", "5", "6", "7", "8", "9"];

    return AlertDialog(content: Text("Trial auswählen"), actions: [
      for (var t in trials)
        TextButton(
          child: Text(
            t,
            style: TextStyle(color: Colors.black),
          ),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, RouteNames.LDT, arguments: t);
          },
        )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          ListTile(
            title: Container(
              padding: EdgeInsets.only(top: 20, bottom: 10.0),
              child: Container(
                  height: 140,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/icons/icon_256.png'),
                          fit: BoxFit.cover)),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Serene"),
                        Text(locator<UserService>().getUserEmail()),
                        VersionInfo()
                      ])),
            ),
          ),
          Divider(),
          // _buildDrawerItem(
          //     icon: Icons.add_box,
          //     text: "Neues Ziel",
          //     onTap: () async {
          //       await Navigator.pushNamed(context, RouteNames.ADD_GOAL);
          //       Navigator.pop(context);
          //       await Navigator.pushNamed(context, RouteNames.MAIN);
          //     }),
          _buildDrawerItem(
              icon: Icons.question_answer,
              text: "Recall",
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, RouteNames.RECALL_TASK);
              }),
          _buildDrawerItem(
              icon: Icons.security,
              text: "Internalisierung",
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context,
                    RouteNames.AMBULATORY_ASSESSMENT_PRE_II_INTERNALISATION);
              }),
          Divider(),
          // _buildDrawerItem(
          //     icon: Icons.settings,
          //     text: "Emoji Task",
          //     onTap: () async {
          //       Navigator.pushNamed(context, RouteNames.EMOJI_STORY);
          //       // FirebaseCrashlytics.instance.crash();
          //     }),
          Divider(),
          _buildDrawerItem(
              icon: Icons.receipt,
              text: "Notification Anzeigen",
              onTap: () {
                // Navigator.pushNamed(context, RouteNames.TEST);
                // // locator<DataService>().saveScore(2);
                locator<NotificationService>().sendDebugReminder();
              }),
          Divider(),
          ListTile(
              title: Text(
                "Lexical Decision Task",
              ),
              onTap: () async {
                // Navigator.pop(context);
                //await Navigator.pushNamed(context, RouteNames.LDT);
                // await buildLDTSelection(context);
                showDialog(
                    context: context,
                    builder: (context) {
                      return buildLDTSelection(context);
                    });
              }),
          Divider(),
          ListTile(
              title: Text("Usability"),
              onTap: () async {
                Navigator.pop(context);
                Navigator.pushNamed(
                    context, RouteNames.AMBULATORY_ASSESSMENT_USABILITY);
              }),
          Divider(),
          ListTile(
              title: Text("Session 0"),
              onTap: () async {
                // await Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => StartupScreen()),
                // );
                await Navigator.pushNamed(context, RouteNames.INIT_START,
                    arguments: AssessmentScreenArguments(
                        AssessmentType.dailyQuestion));
              }),
          // VersionInfo()
        ],
      ),
    );
  }
}
