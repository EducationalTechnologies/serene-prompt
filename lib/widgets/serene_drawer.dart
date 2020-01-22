import 'package:flutter/material.dart';
import 'package:serene/locator.dart';
import 'package:serene/services/local_database_service.dart';
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
          // DrawerHeader(
          //   child: Text("Serene"),
          //   decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          // ),

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
                      children: [Text("Serene"), VersionInfo()])),
            ),
          ),
          Divider(),
          _buildDrawerItem(
              icon: Icons.add_box,
              text: "Neues Ziel",
              onTap: () async {
                await Navigator.pushNamed(context, RouteNames.ADD_GOAL);
                Navigator.pop(context);
                await Navigator.pushNamed(context, RouteNames.MAIN);
              }),
          _buildDrawerItem(
              icon: Icons.list,
              text: "Ziele",
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, RouteNames.MAIN);
              }),
          _buildDrawerItem(
              icon: Icons.security,
              text: "Shielding",
              onTap: () {
                Navigator.pushNamed(context, RouteNames.GOAL_SHIELDING);
              }),
          // _buildDrawerItem(
          //     icon: Icons.label,
          //     text: "Tags",
          //     onTap: () {
          //       Navigator.pushNamed(context, RouteNames.EDIT_TAGS);
          //     }),
          Divider(),
          _buildDrawerItem(
              icon: Icons.settings,
              text: "Einstellungen",
              onTap: () {
                Navigator.pushNamed(context, RouteNames.SETTINGS);
              }),
          Divider(),
          _buildDrawerItem(
              icon: Icons.receipt,
              text: "Einverständniserklärung",
              onTap: () {
                Navigator.pushNamed(context, RouteNames.CONSENT);
              }),
          Divider(),
          ListTile(
              title: Text(
                "TEST STUFF",
                style: subHeaderStyle,
              ),
              onTap: () async {
                // Navigator.pushNamed(context, RouteNames.TEST);
                // await NotificationService().scheduleDailyNotification();
                // await NotificationService().clearPendingNotifications();
                await Navigator.pushNamed(
                    context, RouteNames.AMBULATORY_ASSESSMENT,
                    arguments:
                        AssessmentScreenArguments(AssessmentType.postLearning));
              }),
          Divider(),
          ListTile(
              title: Text("Login"),
              onTap: () async {
                Navigator.pushNamed(context, RouteNames.LOG_IN);
              }),
          ListTile(
              title: Text("Test"),
              onTap: () async {
                await Navigator.pushNamed(
                    context, RouteNames.AMBULATORY_ASSESSMENT,
                    arguments:
                        AssessmentScreenArguments(AssessmentType.dailyQuestion));
              }),
          ListTile(
              title: Text("Habit UI"),
              onTap: () async {
                // // Navigator.pushNamed(context, RouteNames.LOG_IN);
                // var s = locator.get<LocalDatabaseService>();
                // s.deleteSetting(SettingsKeys.email);
                // s.deleteSetting(SettingsKeys.userId);
                await Navigator.pushNamed(
                    context, RouteNames.HABIT_CREATE);
              }),
          // VersionInfo()
        ],
      ),
    );
  }
}
