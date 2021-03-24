import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:serene/locator.dart';
import 'package:serene/screens/rewards/reward_selection_screen.dart';
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
  String _textNotification = "Vielen Dank, dass du mitmachst!";

  Future<String> _nextText;

  bool _showToRecallTaskButton = false;

  @override
  void initState() {
    super.initState();
    _nextText = getNextText();
  }

  Future<String> getNextText() async {
    return "Vielen Dank, dass du mitmachst!";

    var dataService = locator<DataService>();
    var experimentService = locator<ExperimentService>();
    String nextText = "";
    var lastInternalisation = await dataService.getLastInternalisation();

    if (await experimentService.isTimeForInternalisationTask()) {
      Navigator.pushNamed(context, RouteNames.INTERNALISATION);
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
        DateTime nextTime =
            experimentService.getScheduleTimeForRecallTask(DateTime.now());

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
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                "assets/illustrations/mascot_ocean.png"),
                            fit: BoxFit.none,
                            // scale: 7.0,
                            alignment: Alignment.bottomCenter)),
                    child: Align(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Text(_textNext,
                            //     textAlign: TextAlign.center,
                            //     style: Theme.of(context).textTheme.headline5),
                            // UIHelper.verticalSpaceLarge(),
                            Text(_textNotification,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyText1),
                            UIHelper.verticalSpaceSmall(),
                            Text(
                                "Du hast heute am 5. Tag in Folge teilgenommen.",
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyText1),
                            UIHelper.verticalSpaceSmall(),
                            Text("Dafür kriegst du 10💎 und 5💎 als Bonus.",
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyText1),
                            UIHelper.verticalSpaceMedium(),
                            // Text("Du kriegst für deine Teilnahme 15💎.",
                            //     textAlign: TextAlign.center,
                            //     style: Theme.of(context).textTheme.headline5),
                            Container(
                                width: 250,
                                height: 40,
                                child: OutlinedButton(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.shopping_cart),
                                        UIHelper.horizontalSpaceMedium(),
                                        Text(
                                          "Punkte einlösen",
                                          style: TextStyle(color: Colors.black),
                                        )
                                      ],
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        var rewardWidget =
                                            RewardSelectionScreen();
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    rewardWidget));
                                      });
                                    })),
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
