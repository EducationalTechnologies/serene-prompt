import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:serene/shared/ui_helpers.dart';
import 'package:serene/widgets/serene_appbar.dart';
import 'package:serene/widgets/serene_drawer.dart';
import 'package:flutter/foundation.dart';

class NoTasksScreen extends StatelessWidget {
  const NoTasksScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TODO: Remove before release
      appBar: SereneAppBar(),
      drawer: SereneDrawer(),
      body: Container(
          margin: UIHelper.getContainerMargin(),
          decoration: BoxDecoration(
              image: DecorationImage(
            image:
                AssetImage("assets/illustrations/undraw_in_no_time_6igu.png"),
            fit: BoxFit.scaleDown,
          )),
          child: Align(
              child: Text("Derzeit gibt es hier nichts zu tun",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline4),
              alignment: Alignment(0.0, 0.6))),
    );
  }
}
