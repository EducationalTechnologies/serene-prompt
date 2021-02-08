import 'package:flutter/material.dart';
import 'package:serene/locator.dart';
import 'package:serene/services/logging_service.dart';
import 'package:serene/widgets/serene_drawer.dart';

class TestScreen extends StatefulWidget {
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    var logs = locator<LoggingService>().logs;
    return Scaffold(
      drawer: SereneDrawer(),
      body: Container(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            for (var l in logs) Text("${l['name']}: ${l['time']}")
          ],
        ),
      ),
    );
  }
}
