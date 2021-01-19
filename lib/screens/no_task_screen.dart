import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:serene/locator.dart';
import 'package:serene/services/data_service.dart';
import 'package:serene/shared/route_names.dart';
import 'package:serene/shared/ui_helpers.dart';
import 'package:serene/widgets/serene_appbar.dart';
import 'package:serene/widgets/serene_drawer.dart';
import 'package:flutter/foundation.dart';
import 'package:serene/shared/extensions.dart';
import 'package:intl/intl.dart';

class NoTasksScreen extends StatefulWidget {
  const NoTasksScreen({Key key}) : super(key: key);

  @override
  _NoTasksScreenState createState() => _NoTasksScreenState();
}

class _NoTasksScreenState extends State<NoTasksScreen> {
  String _textNext = "";

  getNextStats(BuildContext context) async {
    var dataService = locator<DataService>();
    String nextText = "";
    var lastInternalisation = await dataService.getLastInternalisation();

    if (lastInternalisation == null) {
      Navigator.pushNamed(context, RouteNames.INTERNALISATION);
      return;
    }

    var lastRecall = await dataService.getLastRecallTask();

    if (lastInternalisation.completionDate.isToday()) {
      if (lastRecall != null) {
        if (lastRecall.completionDate.isToday()) {
          nextText =
              "Danke, dass du für heute die Aufgaben erledigt hast. Bitte mache morgen weiter";
        }
      }
      //If no recall task was done today, we check when it is due next
      else {
        var now = DateTime.now();

        var hourDiff = now.hour - lastInternalisation.completionDate.hour;
        if (hourDiff >= 6) {
          nextText =
              "Überprüfe jetzt, wie gut du dich an deinen Wenn-Dann-Plan erinnern kannst";
        } else {
          //If the recall task is in less than
          var nextTime =
              lastInternalisation.completionDate.add(Duration(hours: 6));
          var nextTimeString = DateFormat("HH:mm").format(nextTime);
          nextText =
              "Ab $nextTimeString Uhr solltest du deine Erinnerung an deinen Wenn-Dann-Plan überprüfen";
        }
      }
    }

    setState(() {
      _textNext = nextText;
    });
    return Future.delayed(Duration.zero).then((res) => true);
  }

  _getDrawer() {
    if (kDebugMode) return SereneDrawer();

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SereneAppBar(),
      drawer: _getDrawer(),
      body: FutureBuilder(
          future: getNextStats(context),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                  margin: UIHelper.getContainerMargin(),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage(
                        "assets/illustrations/undraw_in_no_time_6igu.png"),
                    fit: BoxFit.scaleDown,
                  )),
                  child: Align(
                      child: Column(
                        children: [
                          Text(_textNext,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headline4),
                        ],
                      ),
                      alignment: Alignment(0.0, 0.6)));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
