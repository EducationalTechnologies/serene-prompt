import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:prompt/locator.dart';
import 'package:prompt/models/internalisation.dart';
import 'package:prompt/screens/rewards/reward_selection_screen.dart';
import 'package:prompt/services/data_service.dart';
import 'package:prompt/services/experiment_service.dart';
import 'package:prompt/services/reward_service.dart';
import 'package:prompt/shared/enums.dart';
import 'package:prompt/shared/route_names.dart';
import 'package:prompt/shared/ui_helpers.dart';
import 'package:prompt/widgets/full_width_button.dart';
import 'package:prompt/widgets/serene_appbar.dart';
import 'package:prompt/widgets/serene_drawer.dart';
import 'package:prompt/shared/extensions.dart';
import 'package:intl/intl.dart';

class NoTasksScreen extends StatefulWidget {
  final NoTaskSituation previousRoute;
  const NoTasksScreen({Key key, this.previousRoute = NoTaskSituation.standard})
      : super(key: key);

  @override
  _NoTasksScreenState createState() => _NoTasksScreenState();
}

class _NoTasksScreenState extends State<NoTasksScreen>
    with WidgetsBindingObserver {
  String _textNotification = "Vielen Dank, dass du mitmachst!";
  String _textNextTask = "";
  String _nextRoute = RouteNames.AMBULATORY_ASSESSMENT_MORNING;

  ExperimentService _experimentService;

  Future<bool> _nextTask;

  bool _showNextButton = false;

  Timer updateRegularlyTimer;

  @override
  void initState() {
    super.initState();
    _nextTask = getNextText();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showDialogIfNecessary();
    });

    WidgetsBinding.instance.addObserver(this);

    updateRegularly();
  }

  updateRegularly() {
    updateRegularlyTimer = Timer(Duration(minutes: 5), () {
      setState(() {
        getNextText();
      });
      updateRegularly();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    updateRegularlyTimer.cancel();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        onResumed();
        break;
      case AppLifecycleState.inactive:
        onPaused();
        break;
      case AppLifecycleState.paused:
        onInactive();
        break;
      case AppLifecycleState.detached:
        onDetached();
        break;
    }
  }

  void onResumed() {
    print("on resumed");
    setState(() {
      getNextText();
    });
  }

  void onPaused() {
    print("on paused");
  }

  void onInactive() {
    print("on inactive");
  }

  void onDetached() {
    print("on detached");
  }

  showDialogIfNecessary() async {
    if (widget.previousRoute == NoTaskSituation.standard) return;
    if (widget.previousRoute == NoTaskSituation.afterLdt) return;
    if (widget.previousRoute == NoTaskSituation.afterInitialization) return;
    if (widget.previousRoute == NoTaskSituation.afterFinal) return;
    String _title = "";
    String _textReward = "";
    String _textStreak = "";
    String _textTotal = "";
    var rewardService = locator<RewardService>();
    if (widget.previousRoute == NoTaskSituation.afterRecall) {
      _title = "🎉 Belohnung erhalten 🎉";
      _textReward =
          "### Du hast heute **beide** Aufgaben erledigt. Dafür bekommst du 10💎";

      if (rewardService.streakDays > 0) {
        if (rewardService.streakDays == 1) {
          _textStreak =
              "### Außerdem hast du gestern auch schon **alle** Aufgaben erledigt. Dafür bekommst du heute zusätzlich ${rewardService.streakDays}💎 als Bonus";
        }
        if (rewardService.streakDays > 1) {
          _textStreak =
              "### Außerdem hast du ${rewardService.streakDays} Tage in Folge alle Aufgaben erledigt. Dafür bekommst du heute zusätzlich ${rewardService.streakDays}💎 als Bonus";
        }
      }
    }
    if (widget.previousRoute == NoTaskSituation.afterFinal) {
      _title = "Die Studie ist fertig!";
      _textReward =
          "Du hast diese Studie hiermit abgeschlossen und es gibt erstmal keine weiteren Aufgaben. Wenn du bei weiteren Studien mitmachen möchtest, dann schreibe doch eine E-Mail an **breitwieser@dipf.de**";
    }

    await showDialog<String>(
      context: context,
      builder: (BuildContext context) => new AlertDialog(
        title: new Text(_title),
        content: new Column(
          children: [
            MarkdownBody(data: _textReward),
            UIHelper.verticalSpaceMedium(),
            MarkdownBody(data: _textStreak),
            UIHelper.verticalSpaceMedium(),
            Text(_textTotal)
          ],
        ),
        actions: <Widget>[
          new ElevatedButton(
            child: new Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Future<bool> getNextText() async {
    var dataService = locator<DataService>();
    _experimentService = locator<ExperimentService>();
    await dataService.cacheAllInternalisations();
    var lastRecallTask = await dataService.getLastRecallTask();
    var lastInternalisation = await dataService.getLastInternalisation();
    var userData = await dataService.getUserData();
    _showNextButton = false;

    if (widget.previousRoute == NoTaskSituation.afterInitialization ||
        userData.registrationDate.isToday()) {
      _textNextTask =
          "Morgen geht es richtig los, dann musst du dir zum ersten mal einen Plan merken.";
      return true;
    }

    if (widget.previousRoute == NoTaskSituation.afterFinal) {
      _setIsStudyCompleted();
      return true;
    }

    var now = DateTime.now();
    if (await _experimentService.isTimeForRecallTask(now)) {
      _setIsRecallTask();
      return true;
    }

    if (await _experimentService.isTimeForLexicalDecisionTask(now)) {
      _setIsTimeForLDT();
      return true;
    }

    if (await _experimentService.isTimeForInternalisationTask()) {
      _setIsTimeForInternalisation();
      return true;
    }

    if (await _experimentService.isTimeForFinalTask()) {
      _setIsFinalTask();
      return true;
    }

    // No prior recall task done
    if (lastRecallTask == null) {
      // Previously done an internalisation
      if (lastInternalisation != null) {
        // That internalisation was today
        if (lastInternalisation.completionDate.isToday()) {
          _setNextRecallTimeToday(lastInternalisation);
          return true;
        }
      }
    }

    // Previously performed a recall task
    if (lastRecallTask != null) {
      if (!lastRecallTask.completionDate.isToday()) {
        // Previously done an internalisation
        if (lastInternalisation != null) {
          // The last recall task was before the last internalisation
          if (lastRecallTask.completionDate
              .isBefore(lastInternalisation.completionDate)) {
            _setNextRecallTimeToday(lastInternalisation);
            return true;
          }
        }
      }
    }

    // the most unlikely request at the end in order to not do this request
    if (await dataService.finalAssessmentCompleted()) {
      _setIsStudyCompleted();
      return true;
    }

    _setIsNoTasksForToday();
    return true;
  }

  _setIsNoTasksForToday() {
    _showNextButton = false;
    _textNextTask = "Du hast für heute alle Aufgaben erledigt";
  }

  _setIsTimeForLDT() {
    _nextRoute = RouteNames.AMBULATORY_ASSESSMENT_USABILITY;
    _showNextButton = true;
    _textNextTask =
        "Beantworte ein paar Fragen zum Merken der Pläne, und erledige dann die Wortaufgabe.";
  }

  _setIsTimeForInternalisation() {
    _nextRoute = RouteNames.AMBULATORY_ASSESSMENT_MORNING;
    _showNextButton = true;
    _textNextTask = "Es ist jetzt Zeit, dir deinen Plan zu merken.";
  }

  _setIsRecallTask() {
    _nextRoute = RouteNames.RECALL_TASK;
    _showNextButton = true;
    _textNextTask = "Versuche jetzt, dich an deinen Plan zu erinnern.";
  }

  _setIsStudyCompleted() {
    _showNextButton = false;
    _textNotification =
        "Vielen Dank, dass du mitgemacht hast! Du bist mit allen Aufgaben fertig! 🎉🎉 Anfang Juli bekommst du von uns deinen Gutschein zugeschickt. Dann erfährst du auch, ob du bei der Verlosung gewonnen hast.";
    _textNextTask = "";
  }

  _setIsFinalTask() {
    _nextRoute = RouteNames.AMBULATORY_ASSESSMENT_FINISH;
    _showNextButton = true;
    _textNotification = "";
    _textNextTask =
        "Jetzt ist es Zeit für die Abschlussbefragung. Danach hast du alle Aufgaben erledigt, und bist mit der gesamten Studie fertig.";
  }

  _setNextRecallTimeToday(Internalisation lastInternalisation) {
    var nextRecallTaskTime = _experimentService
        .getScheduleTimeForRecallTask(lastInternalisation?.completionDate);
    if (nextRecallTaskTime.isToday()) {
      var nextTimeString = DateFormat("HH:mm").format(nextRecallTaskTime);
      _textNextTask =
          "Überprüfe ab $nextTimeString Uhr, wie gut du dich an deinen Plan erinnern kannst.";
    } else {
      _textNextTask =
          "Du hast deinen Plan heute sehr spät gelernt. Versuche doch, das morgen etwas früher zu tun, damit du beide Aufgaben erledigen kannst.";
    }
  }

  _getDrawer() {
    return SereneDrawer();
  }

  _buildToRecallTaskButton() {
    return Container(
      margin: EdgeInsets.all(10),
      child: FullWidthButton(
        onPressed: () async {
          Navigator.pushNamed(context, _nextRoute);
          return;
        },
        text: "Weiter zur Aufgabe",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var rewardService = locator.get<RewardService>();
    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
        decoration: BoxDecoration(
            gradient: rewardService.backgroundColor,
            image: DecorationImage(
                image: AssetImage(rewardService.backgroundImagePath),
                fit: BoxFit.contain,
                alignment: Alignment.bottomCenter)),
        child: Scaffold(
          // floatingActionButton: _buildAboutButton(),
          backgroundColor: Colors.transparent,
          appBar: SereneAppBar(showBackButton: false),
          // drawer: _getDrawer(),
          body: FutureBuilder(
              future: _nextTask,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                      child: Align(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              UIHelper.verticalSpaceMedium(),
                              Text(_textNotification,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.headline6),
                              UIHelper.verticalSpaceMedium(),
                              Text(_textNextTask,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.headline6),
                              UIHelper.verticalSpaceMedium(),
                              if (_showNextButton) _buildToRecallTaskButton(),
                              UIHelper.verticalSpaceMedium(),
                              _buildChangeBackgroundButton()
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

  _buildChangeBackgroundButton() {
    return Container(
        width: 250,
        height: 40,
        child: OutlinedButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Hintergrund ändern",
                  style: TextStyle(color: Colors.black),
                )
              ],
            ),
            style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0))),
            ),
            onPressed: () async {
              var rewardWidget = RewardSelectionScreen();
              await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => rewardWidget));
              setState(() {});
            }));
  }
}
