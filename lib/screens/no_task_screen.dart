import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:serene/locator.dart';
import 'package:serene/screens/rewards/reward_selection_screen.dart';
import 'package:serene/services/data_service.dart';
import 'package:serene/services/experiment_service.dart';
import 'package:serene/services/reward_service.dart';
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
  String _textNotification = "Vielen Dank, dass du mitmachst!";
  String _textStreakDays = "";
  String _textReward = "";

  Future<String> _nextText;

  bool _showToRecallTaskButton = false;

  @override
  void initState() {
    super.initState();
    _nextText = getNextText();
  }

  Future<String> getNextText() async {
    var dataService = locator<DataService>();
    var experimentService = locator<ExperimentService>();

    var lastRecallTask = await dataService.getLastRecallTask();

    if (lastRecallTask != null) {
      if (lastRecallTask.completionDate.isToday()) {
        var streakDays = await dataService.getStreakDays();
        if (streakDays > 1) {
          _textStreakDays =
              "Du hast jetzt $streakDays Tage in Folge mitgemacht";
        }
      }
    }

    return "Vielen Dank, dass du mitmachst!";

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
    return nextText;
  }

  _getNextTimeTodayString(DateTime nextTime) {
    var nextTimeString = DateFormat("HH:mm").format(nextTime);
    return "Ab $nextTimeString Uhr solltest du die Erinnerung an deinen Wenn-Dann-Plan überprüfen";
  }

  _getDrawer() {
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
    var rewardService = locator.get<RewardService>();
    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[Color(0xffffffff), Color(0xff00d4ff)],
            ),
            // color: Colors.black,
            image: DecorationImage(
                image: AssetImage(rewardService.backgroundImagePath),
                fit: BoxFit.contain,
                alignment: Alignment.bottomCenter)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: SereneAppBar(),
          drawer: _getDrawer(),
          body: FutureBuilder(
              future: _nextText,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
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
                                  style: Theme.of(context).textTheme.headline6),
                              UIHelper.verticalSpaceSmall(),
                              Text(_textStreakDays,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyText1),
                              UIHelper.verticalSpaceSmall(),
                              Text(_textReward,
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
                                          Icon(Icons.image),
                                          UIHelper.horizontalSpaceMedium(),
                                          Text(
                                            "Hintergrund ändern",
                                            style:
                                                TextStyle(color: Colors.black),
                                          )
                                        ],
                                      ),
                                      onPressed: () async {
                                        var rewardWidget =
                                            RewardSelectionScreen();
                                        await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    rewardWidget));
                                        setState(() {});
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
      ),
    );
  }
}
