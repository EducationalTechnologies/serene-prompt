import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:prompt/locator.dart';
import 'package:prompt/services/notification_service.dart';
import 'package:prompt/services/user_service.dart';
import 'package:prompt/shared/route_names.dart';
import 'package:prompt/widgets/version_info.dart';

class SereneDrawer extends StatelessWidget {
  SereneDrawer();

  _buildDrawerItem(
      {IconData icon = Icons.ac_unit,
      String text = "",
      GestureTapCallback onTap}) {
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(locator<UserService>().getUsername()),
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
              icon: Icons.filter_1,
              text: "Session 0 ",
              onTap: () {
                // Navigator.pop(context);
                //
                Navigator.pushNamed(context, RouteNames.LOG_IN);
                // var now = DateTime.now();
                // var next = now.add(Duration(seconds: 100));
                // locator<NotificationService>().scheduleRecallTaskReminder(next);
              }),

          Divider(),
          _buildDrawerItem(
              icon: Icons.wb_sunny,
              text: "Morgens",
              onTap: () {
                Navigator.pushNamed(
                    context, RouteNames.AMBULATORY_ASSESSMENT_MORNING,
                    arguments: "1");
              }),
          // VersionInfo()
          Divider(),
          _buildDrawerItem(
              icon: Icons.nightlight_round,
              text: "Abends",
              onTap: () {
                Navigator.pushNamed(context, RouteNames.RECALL_TASK,
                    arguments: "1");
              }),
          Divider(),
          _buildDrawerItem(
              icon: Icons.gamepad,
              text: "Usability",
              onTap: () {
                Navigator.pushNamed(
                    context, RouteNames.AMBULATORY_ASSESSMENT_USABILITY,
                    arguments: "1");
              }),
          Divider(),
          _buildDrawerItem(
              icon: Icons.golf_course_sharp,
              text: "Abschluss",
              onTap: () {
                Navigator.pushNamed(
                    context, RouteNames.AMBULATORY_ASSESSMENT_FINISH,
                    arguments: "1");
              }),
        ],
      ),
    );
  }
}
