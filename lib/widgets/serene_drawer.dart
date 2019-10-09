import 'package:flutter/material.dart';
import 'package:serene/services/data_service.dart';
import 'package:serene/services/database_helpers.dart';
import 'package:serene/shared/route_names.dart';
import 'package:serene/shared/text_styles.dart';

class SereneDrawer extends StatelessWidget {
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
          DrawerHeader(
            child: Text("Serene"),
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          ),
          _buildDrawerItem(
              icon: Icons.add_box,
              text: "Neues Ziel",
              onTap: () {
                Navigator.pushNamed(context, RouteNames.ADD_GOAL);
              }),
          _buildDrawerItem(
              icon: Icons.list,
              text: "Ziele",
              onTap: () {
                Navigator.pushNamed(context, RouteNames.MAIN);
              }),
          _buildDrawerItem(
              icon: Icons.list,
              text: "Open Goals",
              onTap: () {
                Navigator.pushNamed(context, RouteNames.OPEN_GOALS);
              }),
          _buildDrawerItem(
              icon: Icons.security,
              text: "Shielding",
              onTap: () {
                Navigator.pushNamed(context, RouteNames.GOAL_SHIELDING);
              }),
          Divider(),
          ListTile(
            title: Text(
              "DEBUG STUFF",
              style: subHeaderStyle,
            ),
          ),
          Divider(),
          ListTile(
              title: Text("Consent"),
              onTap: () async {
                Navigator.pushNamed(context, RouteNames.CONSENT);
              }),
          ListTile(
              title: Text("Timer"),
              onTap: () async {
                Navigator.pushNamed(context, RouteNames.TIMER);
              }),
          ListTile(
              title: Text("Test"),
              onTap: () async {
                Navigator.pushNamed(context, RouteNames.TEST);
              }),
          ListTile(
              title: Text("Clear Goals Database"),
              onTap: () async {
                await DBProvider.db.clearDatabase();
              }),
          // ListTile(
          //     title: Text("Insert Sample Goals"),
          //     onTap: () async {
          //       await DBProvider.db.insertSampleData();
          //     }),
          ListTile(
              title: Text("Log In"),
              onTap: () async {
                Navigator.pushNamed(context, RouteNames.LOG_IN);
              }),
        ],
      ),
    );
  }
}
