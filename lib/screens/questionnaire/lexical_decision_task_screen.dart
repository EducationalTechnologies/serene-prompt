import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:serene/locator.dart';
import 'package:serene/models/ldt_data.dart';
import 'package:serene/services/navigation_service.dart';
import 'package:serene/shared/route_names.dart';
import 'package:serene/widgets/full_width_button.dart';

class LexicalDecisionTaskScren extends StatefulWidget {
  LexicalDecisionTaskScren({Key key}) : super(key: key);

  @override
  _LexicalDecisionTaskScrenState createState() =>
      _LexicalDecisionTaskScrenState();
}

class _LexicalDecisionTaskScrenState extends State<LexicalDecisionTaskScren> {
  String current = "";

  final String clear = "++++++++++++";

  bool clearState = false;
  int _currentWordIndex = 0;
  int timerDuration = 500;
  Stopwatch stopwatch;
  Timer _nextTimer;
  bool _trialComplete = false;

  final List<LdtData> _trial = [
    LdtData(
      blockname: "Test 1",
      word: "WURST",
      condition: "word",
    ),
    LdtData(blockname: "Test 1", word: "MARF", condition: "nonword"),
    LdtData(blockname: "Test 1", word: "SCHREI", condition: "word"),
    LdtData(blockname: "Test 1", word: "PORLO", condition: "nonword"),
    LdtData(blockname: "Test 1", word: "ANGST", condition: "word"),
    LdtData(blockname: "Test 1", word: "LOMPFO", condition: "nonword"),
    LdtData(blockname: "Test 1", word: "ENGE", condition: "word"),
    LdtData(blockname: "Test 1", word: "GOLBT", condition: "nonword"),
    LdtData(blockname: "Test 1", word: "FOLGEN", condition: "word"),
    LdtData(blockname: "Test 1", word: "MURLA", condition: "nonword"),
    LdtData(blockname: "Test 1", word: "TUMOR", condition: "word"),
  ];

  @override
  void initState() {
    stopwatch = Stopwatch();
    super.initState();
    change();
  }

  change() {
    if (_currentWordIndex == _trial.length - 1) {
      _trialComplete = true;
      return;
    }

    if (!clearState) {
      timerDuration = 500;
    } else {
      timerDuration = 2000;
    }
    _nextTimer = Timer(Duration(milliseconds: timerDuration), () {
      next();
      change();
    });
  }

  next() {
    stopwatch.reset();
    stopwatch.start();
    setState(() {
      if (clearState) {
        current = clear;
      } else {
        current = _trial[_currentWordIndex].word;
        _currentWordIndex++;
      }
      clearState = !clearState;
    });
  }

  getRoundTime(int selection) {
    stopwatch.stop();
    _trial[_currentWordIndex].responseTime = stopwatch.elapsedMilliseconds;
    _trial[_currentWordIndex].status = selection;
  }

  buildTrialSummary() {
    List<Widget> summaryItems = [];

    for (var t in _trial) {
      summaryItems.add(Row(
        children: [
          Text(t.word),
          Text("|"),
          Text(t.responseTime.toString()),
          Text("|"),
          Text(t.status.toString())
        ],
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
      ));
    }

    return Column(
      children: [
        ...summaryItems,
        FullWidthButton(onPressed: () async {
          await locator<NavigationService>().navigateTo(RouteNames.NO_TASKS);
        })
      ],
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
    );
  }

  buildLDT() {
    return Column(
      children: [
        Text(current, style: TextStyle(fontSize: 40, color: Colors.black)),
        buildYesNo()
      ],
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    );
  }

  Widget buildYesNo() {
    return Row(
      children: [
        RaisedButton(
          onPressed: () {
            getRoundTime(1);
          },
          child: Text("Ja"),
        ),
        RaisedButton(
            onPressed: () {
              getRoundTime(0);
            },
            child: Text("Nein"))
      ],
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: _trialComplete ? buildTrialSummary() : buildLDT(),
    ));
  }
}
