import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:serene/locator.dart';
import 'package:serene/models/ldt_data.dart';
import 'package:serene/services/navigation_service.dart';
import 'package:serene/shared/route_names.dart';
import 'package:serene/shared/ui_helpers.dart';
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

  bool isTextState = true;
  int _currentWordIndex = 0;
  int timerDurationRegular = 1500;
  int timerDurationClear = 500;
  Stopwatch stopwatch;
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
    current = clear;
    isTextState = false;
  }

  change() {
    if (_currentWordIndex == _trial.length - 1) {
      setState(() {
        _trialComplete = true;
      });

      return;
    }

    int duration = isTextState ? timerDurationRegular : timerDurationClear;

    Timer(Duration(milliseconds: duration), () {
      next();
      change();
    });
  }

  next() {
    stopwatch.reset();
    stopwatch.start();
    setState(() {
      if (isTextState) {
        current = clear;
      } else {
        current = _trial[_currentWordIndex].word;
        _currentWordIndex++;
      }
    });
    isTextState = !isTextState;
  }

  pressed(int selection) {
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
          Text(
            current,
            style: TextStyle(fontSize: 40, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          Visibility(
            visible: isTextState,
            child: FullWidthButton(
              onPressed: () {
                pressed(1);
              },
              text: "Ja",
            ),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          body: Container(
        margin: UIHelper.getContainerMargin(),
        child: _trialComplete ? buildTrialSummary() : buildLDT(),
      )),
    );
  }
}
