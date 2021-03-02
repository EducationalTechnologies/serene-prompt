import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:serene/shared/ui_helpers.dart';
import 'package:serene/viewmodels/lexical_decision_task_view_model.dart';
import 'package:serene/widgets/full_width_button.dart';
import 'package:serene/widgets/serene_drawer.dart';

class LexicalDecisionTaskScren extends StatefulWidget {
  LexicalDecisionTaskScren({Key key}) : super(key: key);

  @override
  _LexicalDecisionTaskScrenState createState() =>
      _LexicalDecisionTaskScrenState();
}

class _LexicalDecisionTaskScrenState extends State<LexicalDecisionTaskScren> {
  LexicalDecisionTaskViewModel vm;
  int phase = 0;
  int currentStep = 0;

  Future<bool> ldtLoaded;

  final TextStyle ldtTextStyle = TextStyle(fontSize: 40, color: Colors.black);

  bool isTextState = true;
  Stopwatch _primeStopwatch = Stopwatch();
  Stopwatch stopwatch;
  List<int> primeDurations = [];
  @override
  void initState() {
    super.initState();
    vm = Provider.of<LexicalDecisionTaskViewModel>(context, listen: false);
    stopwatch = Stopwatch();
    currentStep = 0;
    ldtLoaded = vm.init().then((value) {
      change();
      return true;
    });
  }

  change() {
    int duration = vm.phaseDurations[phase];
    Timer(Duration(milliseconds: duration), () {
      next();
      change();
    });
  }

  next() {
    stopwatch.reset();
    stopwatch.start();
    setState(() {
      currentStep += 1;
      phase = currentStep % vm.phaseDurations.length;
    });
  }

  pressed(int selection) {
    stopwatch.stop();
    vm.setTrialResult(
        stopwatch.elapsedMilliseconds, selection, primeDurations.last);

    next();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: vm.done ? AppBar() : null,
          drawer: vm.done ? SereneDrawer() : null,
          body: FutureBuilder(
            future: ldtLoaded,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                if (vm.done) {
                  return buildTrialSummary();
                } else {
                  return buildTrial();
                }
              }
              return CircularProgressIndicator();
            },
          ),
        ));
  }

  buildTrialSummary() {
    List<Widget> summaryItems = [];

    for (var i = 0; i < vm.ldt.trials.length; i++) {
      var t = vm.ldt.trials[i];
      summaryItems.add(Row(
        children: [
          Text(
            "Prime Duration: ${vm.ldt.trials[i].primeDuration}| ",
            textAlign: TextAlign.left,
          ),
          Text(t.target),
          Text("|"),
          Text(t.responseTime.toString()),
          Text("|"),
          Text(t.status.toString())
        ],
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
      ));
    }

    return Container(
      margin: UIHelper.getContainerMargin(),
      child: Column(
        children: [
          ...summaryItems,
          FullWidthButton(onPressed: () async {
            await vm.submit();
          })
        ],
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
      ),
    );
  }

  buildTrial() {
    Widget currentPhaseWidget;

    isTextState = false;

    if (phase == 0) {
      currentPhaseWidget = buildFixationCross();
    } else if (phase == 1) {
      _primeStopwatch.reset();
      _primeStopwatch.start();
      currentPhaseWidget = buildPrime(vm.getCurrentPrime());
    } else if (phase == 2) {
      _primeStopwatch.stop();
      primeDurations.add(_primeStopwatch.elapsedMilliseconds);
      currentPhaseWidget = buildBackwardMask();
    } else if (phase == 3) {
      isTextState = true;
      currentPhaseWidget = buildTarget(vm.getCurrentTarget());
    }

    return Container(
        margin: UIHelper.getContainerMargin(),
        child: Column(
            children: [
              currentPhaseWidget,
              Visibility(
                maintainSize: true,
                maintainState: true,
                maintainAnimation: true,
                visible: isTextState,
                child: Column(
                  children: [
                    FullWidthButton(
                        onPressed: () {
                          pressed(1);
                        },
                        text: "Ja",
                        height: 140),
                    UIHelper.verticalSpaceLarge(),
                    FullWidthButton(
                        onPressed: () {
                          pressed(0);
                        },
                        text: "Nein",
                        height: 140),
                  ],
                ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center));
  }

  buildBackwardMask() {
    return Text("##########", style: ldtTextStyle, textAlign: TextAlign.center);
  }

  buildFixationCross() {
    return Text("+", style: ldtTextStyle, textAlign: TextAlign.center);
  }

  buildPrime(String primeText) {
    return Text(primeText, style: ldtTextStyle, textAlign: TextAlign.center);
  }

  buildTarget(String targetText) {
    return Text(targetText, style: ldtTextStyle, textAlign: TextAlign.center);
  }
}
