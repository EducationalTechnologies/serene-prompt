import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:serene/locator.dart';
import 'package:serene/services/data_service.dart';
import 'package:serene/services/experiment_service.dart';
import 'package:serene/shared/route_names.dart';
import 'package:serene/shared/ui_helpers.dart';
import 'package:serene/widgets/full_width_button.dart';
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
  String _textNotification =
      "Sobald es weitergeht, wird dich die App benachrichtigen";

  Future<String> _nextText;

  bool _showToRecallTaskButton = false;
  bool _showInternalisationTaskButton = false;

  @override
  void initState() {
    super.initState();
    _nextText = getNextText();
  }

  Future<String> getNextText() async {
    var dataService = locator<DataService>();
    var experimentService = locator<ExperimentService>();
    String nextText = "";
    var lastInternalisation = await dataService.getLastInternalisation();

    if (await experimentService.isTimeForInternalisationTask()) {
      Navigator.pushNamed(context, RouteNames.INTERNALISATION);
      _showInternalisationTaskButton = true;
      return "";
    }

    if (await experimentService.isTimeForRecallTask()) {
      Navigator.pushNamed(context, RouteNames.RECALL_TASK);
      _showToRecallTaskButton = true;
      return "";
    }

    var lastRecall = await dataService.getLastRecallTask();

    if (lastInternalisation.completionDate.isToday()) {
      //If no recall task was done today, we check when it is due next

      var timeForRecall = await experimentService.isTimeForRecallTask();
      if (timeForRecall) {
        nextText =
            "Überprüfe jetzt, wie gut du dich an deinen heutigen Wenn-Dann-Plan erinnern kannst";

        _showToRecallTaskButton = true;
        // setState(() {
        //   _showToRecallTaskButton = true;
        // });
      } else {
        //If the recall task is in less than
        DateTime nextTime = lastInternalisation.completionDate.add(
            Duration(hours: ExperimentService.INTERNALISATION_RECALL_BREAK));

        if (nextTime.isToday()) {
          if (lastRecall != null) {
            if (lastRecall.completionDate.isToday()) {
              nextText = "Danke, dass du für heute die Aufgaben erledigt hast.";
            } else {
              nextText = _getNextTimeTodayString(nextTime);
            }
          } else {
            nextText = _getNextTimeTodayString(nextTime);
          }
        } else {
          nextText =
              "Du hast deinen Wenn-Dann-Plan heute sehr spät gelernt. Versuche doch, das Morgen etwas früher zu tun.";
        }
      }
    }
    _textNext = nextText;
    return nextText;
  }

  _getNextTimeTodayString(DateTime nextTime) {
    var nextTimeString = DateFormat("HH:mm").format(nextTime);
    return "Ab $nextTimeString Uhr solltest du die Erinnerung an deinen Wenn-Dann-Plan überprüfen";
  }

  _getDrawer() {
    // TODO: Reactivate before release
    // if (kDebugMode) return SereneDrawer();

    return SereneDrawer();
  }

  _buildToRecallTaskButton() {
    return FullWidthButton(
      onPressed: () async {
        Navigator.pushNamed(context, RouteNames.RECALL_TASK);
        return;
      },
      text: "Zur Gedächtnisaufgabe",
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: SereneAppBar(),
        drawer: _getDrawer(),
        body: FutureBuilder(
            future: _nextText,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                    margin: UIHelper.getContainerMargin(),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                "assets/illustrations/mascot_schild.png"),
                            fit: BoxFit.contain,
                            scale: 2.0,
                            alignment: Alignment.bottomLeft)),
                    child: Align(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(_textNext,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.headline5),
                            UIHelper.verticalSpaceLarge(),
                            Text(_textNotification,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.headline5),
                            if (_showToRecallTaskButton)
                              _buildToRecallTaskButton(),
                          ],
                        ),
                        alignment: Alignment(0.0, 0.6)));
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }
}
