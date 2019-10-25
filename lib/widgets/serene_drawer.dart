import 'package:flutter/material.dart';
import 'package:serene/shared/route_names.dart';
import 'package:serene/shared/text_styles.dart';
// import 'package:package_info/package_info.dart';

class SereneDrawer extends StatelessWidget {
  // TODO: Grab correct version number
  final String versionNumber = "0.1.1";

  SereneDrawer() {
    // PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
    //   String appName = packageInfo.appName;
    //   String packageName = packageInfo.packageName;
    //   String version = packageInfo.version;
    //   String buildNumber = packageInfo.buildNumber;
    // });
  }

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
                    children: [
                    Text("Serene"),
                    Text("Version $versionNumber")
                  ])),
            ),
          ),
          Divider(),
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
              icon: Icons.security,
              text: "Shielding",
              onTap: () {
                Navigator.pushNamed(context, RouteNames.GOAL_SHIELDING);
              }),
          _buildDrawerItem(
              icon: Icons.label,
              text: "Tags",
              onTap: () {
                Navigator.pushNamed(context, RouteNames.EDIT_TAGS);
              }),
          Divider(),
          _buildDrawerItem(
              icon: Icons.settings,
              text: "Settings",
              onTap: () {
                Navigator.pushNamed(context, RouteNames.SETTINGS);
              }),
          Divider(),
          ListTile(
              title: Text(
                "TEST STUFF",
                style: subHeaderStyle,
              ),
              onTap: () async {
                Navigator.pushNamed(context, RouteNames.TEST);
              }),
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
              title: Text("Log In"),
              onTap: () async {
                Navigator.pushNamed(context, RouteNames.LOG_IN);
              }),
          Text(versionNumber)
        ],
      ),
    );
  }
}
