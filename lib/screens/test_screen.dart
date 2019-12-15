import 'package:flutter/material.dart';
import 'package:serene/services/notification_service.dart';
import 'package:serene/shared/enums.dart';
import 'package:serene/shared/route_names.dart';
import 'package:serene/shared/screen_args.dart';
import 'package:serene/widgets/serene_drawer.dart';

class TestScreen extends StatefulWidget {
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
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
                title: Text("Assessment Pre Learning"),
                onTap: () async {
                  Navigator.pushNamed(context, RouteNames.AMBULATORY_ASSESSMENT,
                      arguments: AssessmentScreenArguments(
                          AssessmentType.preLearning));
                }),
            ListTile(
                title: Text("Assessment Post Learning"),
                onTap: () async {
                  Navigator.pushNamed(context, RouteNames.AMBULATORY_ASSESSMENT,
                      arguments: AssessmentScreenArguments(
                          AssessmentType.postLearning));
                }),
            ListTile(
                title: Text("Assessment Post Test"),
                onTap: () async {
                  Navigator.pushNamed(context, RouteNames.AMBULATORY_ASSESSMENT,
                      arguments:
                          AssessmentScreenArguments(AssessmentType.postTest));
                }),
            ListTile(
                title: Text("Test Notifications"),
                onTap: () async {
                  await NotificationService().showNotification();
                }),
            RaisedButton(
              onPressed: () {
                Navigator.pushNamed(context, RouteNames.MAIN);
              },
            ),
            FutureBuilder(
              future: NotificationService().getPendingNotifications(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Text("Open Stuff");
                    break;
                  case ConnectionState.waiting:
                    return Text("Open Stuff");
                    break;
                  case ConnectionState.active:
                    return Text("Open Stuff");
                    break;
                  case ConnectionState.done:
                    return snapshot.data;
                    break;
                  default:
                    return Text("DEFAULT");
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
