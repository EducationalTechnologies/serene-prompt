import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:serene/shared/route_names.dart';
import 'package:serene/shared/ui_helpers.dart';
import 'package:serene/viewmodels/lexical_decision_task_view_model.dart';
import 'package:serene/widgets/countdown.dart';
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
  Future<bool> ldtLoaded;

  final TextStyle ldtTextStyle = TextStyle(fontSize: 40, color: Colors.black);

  bool isTextState = true;

  @override
  void initState() {
    super.initState();
    vm = Provider.of<LexicalDecisionTaskViewModel>(context, listen: false);
    vm.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    vm.dispose();
    super.dispose();
  }

  void _onCountdownFinished() {
    ldtLoaded = vm.init().then((value) {
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: AppBar(),
          drawer: SereneDrawer(),
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
              return _buildCountDown();
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
          Text(t.selection.toString())
        ],
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
      ));
    }

    return Container(
      margin: UIHelper.getContainerMargin(),
      child: Column(
        children: [
          Text(
            "Gut gemacht!",
            style: Theme.of(context).textTheme.headline6,
          ),
          Text(
            "Drücke jetzt auf 'Abschicken', um die Aufgabe abzuschließen",
            style: Theme.of(context).textTheme.headline6,
          ),
          FullWidthButton(onPressed: () async {
            await vm.submit();
          })
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
      ),
    );
  }

  buildTrial() {
    Widget currentPhaseWidget;

    isTextState = false;

    if (vm.phase == 0) {
      currentPhaseWidget = buildFixationCross();
    } else if (vm.phase == 1) {
      vm.startPrimeStopwatch();
      currentPhaseWidget = buildPrime(vm.getNextPrime());
    } else if (vm.phase == 2) {
      vm.stopPrimeStopwatch();
      currentPhaseWidget = buildBackwardMask();
    } else if (vm.phase == 3) {
      isTextState = true;
      currentPhaseWidget = buildTarget(vm.getNextTarget());
    }

    return Container(
        margin: UIHelper.getContainerMargin(),
        child: Column(
            children: [
              UIHelper.verticalSpaceLarge(),
              UIHelper.verticalSpaceLarge(),
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
                          vm.pressed(1);
                        },
                        text: "Ja",
                        height: 140),
                    UIHelper.verticalSpaceMedium(),
                    FullWidthButton(
                        onPressed: () {
                          vm.pressed(0);
                        },
                        text: "Nein",
                        height: 140),
                  ],
                ),
              ),
              LinearProgressIndicator(
                value: vm.getProgress(),
                minHeight: 5,
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center));
  }

  _buildCountDown() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Mach dich bereit, gleich geht die Wortaufgabe los",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline6,
        ),
        CountDown(
          5,
          onFinished: _onCountdownFinished,
        ),
      ],
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
}
