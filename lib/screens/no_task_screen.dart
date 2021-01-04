import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NoTasksScreen extends StatelessWidget {
  const NoTasksScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/illustrations/undraw_empty_xct9.png"),
          fit: BoxFit.scaleDown,
        )),
        child: Text("Gibt nüscht zu tun im Moment"),
      ),
    );
  }
}
