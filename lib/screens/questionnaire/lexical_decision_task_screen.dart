import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:serene/locator.dart';
import 'package:serene/services/navigation_service.dart';
import 'package:serene/shared/route_names.dart';
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

  final TextStyle ldtTextStyle = TextStyle(fontSize: 40, color: Colors.black);

  bool isTextState = true;
  Stopwatch stopwatch;
  bool _trialComplete = false;

  @override
  void initState() {
    vm = Provider.of<LexicalDecisionTaskViewModel>(context, listen: false);
    stopwatch = Stopwatch();
    super.initState();
    currentStep = 0;
    change();
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
    vm.setTrialResult(stopwatch.elapsedMilliseconds, selection);
  }

  buildTrialSummary() {
    List<Widget> summaryItems = [];

    for (var t in vm.ldt.trials) {
      summaryItems.add(Row(
        children: [
          Text(t.target),
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
          // TODO: Loading screen while submit
          await vm.submit();
          await locator<NavigationService>().navigateTo(RouteNames.NO_TASKS);
        })
      ],
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
    );
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

  buildTrial() {
    Widget currentPhaseWidget;

    isTextState = false;

    if (phase == 0) {
      currentPhaseWidget = buildFixationCross();
    } else if (phase == 1) {
      currentPhaseWidget = buildPrime(vm.getCurrentPrime());
    } else if (phase == 2) {
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
                        height: 90),
                    UIHelper.verticalSpaceMedium(),
                    FullWidthButton(
                        onPressed: () {
                          pressed(0);
                        },
                        text: "Nein",
                        height: 90),
                  ],
                ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: AppBar(),
          drawer: SereneDrawer(),
          body: FutureBuilder(
            future: vm.initialized,
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
}
