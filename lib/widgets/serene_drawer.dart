import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:serene/locator.dart';
import 'package:serene/services/notification_service.dart';
import 'package:serene/services/user_service.dart';
import 'package:serene/shared/enums.dart';
import 'package:serene/shared/route_names.dart';
import 'package:serene/shared/screen_args.dart';
import 'package:serene/shared/text_styles.dart';
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
              text: "Internalisation",
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, RouteNames.INTERNALISATION);
              }),
          Divider(),
          _buildDrawerItem(
              icon: Icons.settings,
              text: "FORCE CRASH",
              onTap: () async {
                // Navigator.pushNamed(context, RouteNames.SETTINGS);
                FirebaseCrashlytics.instance.crash();
              }),
          Divider(),
          _buildDrawerItem(
              icon: Icons.receipt,
              text: "Trigger Reminder",
              onTap: () {
                // Navigator.pushNamed(context, RouteNames.CONSENT);
                locator<NotificationService>().sendDebugReminder();
              }),
          Divider(),
          ListTile(
              title: Text(
                "Lexical Decision Task",
                style: subHeaderStyle,
              ),
              onTap: () async {
                Navigator.pop(context);
                await Navigator.pushNamed(context, RouteNames.LDT);
              }),
          Divider(),
          ListTile(
              title: Text("Einverständnis"),
              onTap: () async {
                Navigator.pop(context);
                Navigator.pushNamed(context, RouteNames.CONSENT);
              }),
          ListTile(
              title: Text("Initialisierung"),
              onTap: () async {
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
