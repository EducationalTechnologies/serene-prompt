import 'package:flutter/material.dart';
import 'package:serene/services/data_service.dart';
import 'package:serene/services/database_helpers.dart';
import 'package:serene/services/firebase_service.dart';
import 'package:serene/services/notification_service.dart';
import 'package:serene/shared/route_names.dart';
import 'package:serene/widgets/serene_drawer.dart';

class TestScreen extends StatefulWidget {
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
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
    return Scaffold(
      drawer: SereneDrawer(),
      body: Container(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
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
                title: Text("Test Ambulatory Assessment"),
                onTap: () async {
                  Navigator.pushNamed(
                      context, RouteNames.AMBULATORY_ASSESSMENT);
                }),
            ListTile(
                title: Text("Clear Goals Database"),
                onTap: () async {
                  await DBProvider.db.clearDatabase();
                }),
            ListTile(
                title: Text("Test Notifications"),
                onTap: () async {
                  await NotificationService().showNotification();
                }),
            ListTile(
                title: Text("Test Firebase Messages"),
                onTap: () async {
                  FirebaseService().getGoals();
                }),
          ],
        ),
      ),
    );
  }
}
