import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prompt/screens/initialsession/text_explanation_screen.dart';
import 'package:prompt/shared/ui_helpers.dart';
import 'package:prompt/viewmodels/init_session_view_model.dart';
import 'package:prompt/viewmodels/lexical_decision_task_view_model.dart';
import 'package:prompt/widgets/countdown.dart';
import 'package:prompt/widgets/full_width_button.dart';

typedef void OnLoadedCallback(String trialName);

class InitialLdtScreen extends StatefulWidget {
  final String trialName;
  final VoidCallback onFinished;
  final OnLoadedCallback onLoaded;

  InitialLdtScreen(this.trialName, this.onFinished, {this.onLoaded, key})
      : super(key: key);

  @override
  _InitialLdtScreenState createState() => _InitialLdtScreenState();
}

class _InitialLdtScreenState extends State<InitialLdtScreen> {
  LexicalDecisionTaskViewModel vm;
  InitSessionViewModel initVm;
  Future<bool> ldtLoaded;

  final TextStyle ldtTextStyle = TextStyle(fontSize: 40, color: Colors.black);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (vm != null) {
        if (vm.done) {
          if (widget != null) {
            if (widget.onFinished != null) {
              widget.onFinished();
            }
          }
        }
      }
    });

    return FutureBuilder(
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
    );
  }

  buildTrial() {
    Widget currentPhaseWidget;

    var phase = vm.phase;

    if (phase == 0) {
      currentPhaseWidget = buildFixationCross();
    } else if (phase == 1) {
      vm.startPrimeStopwatch();
      currentPhaseWidget = buildPrime(vm.getNextPrime());
    } else if (phase == 2) {
      vm.stopPrimeStopwatch();
      currentPhaseWidget = buildBackwardMask();
    } else if (phase == 3) {
      currentPhaseWidget = buildTarget(vm.getNextTarget());
    }

    return Container(
        margin: UIHelper.getContainerMargin(),
        child: Column(
            children: [
              UIHelper.verticalSpaceMedium(),
              currentPhaseWidget,
              OrientationBuilder(builder: (context, orientation) {
                if (orientation == Orientation.portrait) {
                  return buildInputPortrait();
                } else {
                  return buildInputLandscape();
                }
              }),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center));
  }

  buildInputPortrait() {
    return Visibility(
      maintainSize: true,
      maintainState: true,
      maintainAnimation: true,
      visible: vm.phase == 3,
      child: Column(
        children: [
          FullWidthButton(
              onPressed: () {
                vm.pressed(1);
              },
              text: "Ja",
              height: 140),
          UIHelper.verticalSpaceSmall(),
          LinearProgressIndicator(
            value: vm.getProgress(),
            minHeight: 8,
          ),
          UIHelper.verticalSpaceSmall(),
          FullWidthButton(
              onPressed: () {
                vm.pressed(0);
              },
              text: "Nein",
              height: 140),
        ],
      ),
    );
  }

  buildInputLandscape() {
    return Visibility(
      maintainSize: true,
      maintainState: true,
      maintainAnimation: true,
      visible: vm.phase == 3,
      child: Column(
        children: [
          FullWidthButton(
              onPressed: () {
                vm.pressed(1);
              },
              text: "Ja",
              height: 140),
          UIHelper.verticalSpaceLarge(),
          FullWidthButton(
              onPressed: () {
                vm.pressed(0);
              },
              text: "Nein",
              height: 140),
        ],
      ),
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

  buildTrialSummary() {
    var message = Provider.of<InitSessionViewModel>(context, listen: false)
        .getTrialMessage(this.widget.key);
    return TextExplanationScreen(message);
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

  void _onCountdownFinished() {
    ldtLoaded = Provider.of<InitSessionViewModel>(context, listen: false)
        .initTrial(this.widget.trialName)
        .then((value) {
      vm = Provider.of<InitSessionViewModel>(context, listen: false).ldtvm;
      vm.addListener(() {
        setState(() {});
      });
      if (widget.onLoaded != null) {
        widget.onLoaded(widget.trialName);
      }
      return true;
    }).then((value) => true);
  }
}
