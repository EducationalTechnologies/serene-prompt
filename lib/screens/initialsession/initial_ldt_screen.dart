import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serene/shared/ui_helpers.dart';
import 'package:serene/viewmodels/init_session_view_model.dart';
import 'package:serene/widgets/full_width_button.dart';
import 'package:serene/widgets/speech_bubble.dart';

class InitialLdtScreen extends StatefulWidget {
  final String trialName;

  InitialLdtScreen(this.trialName, {Key key}) : super(key: key);

  @override
  _InitialLdtScreenState createState() => _InitialLdtScreenState();
}

class _InitialLdtScreenState extends State<InitialLdtScreen> {
  InitSessionViewModel vm;
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
    stopwatch = Stopwatch();
    currentStep = 0;
    vm = Provider.of<InitSessionViewModel>(context, listen: false);
    ldtLoaded = vm.initTrial(this.widget.trialName).then((value) {
      return true;
    }).then((value) => true);
    change();
  }

  change() {
    int duration = vm.ldtvm.phaseDurations[phase];
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
      phase = currentStep % vm.ldtvm.phaseDurations.length;
    });
  }

  pressed(int selection) {
    stopwatch.stop();
    vm.ldtvm.setTrialResult(
        stopwatch.elapsedMilliseconds, selection, primeDurations.last);

    next();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ldtLoaded,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          if (vm.ldtvm.done) {
            return buildTrialSummary();
          } else {
            return buildTrial();
          }
        }
        return CircularProgressIndicator();
      },
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
      currentPhaseWidget = buildPrime(vm.ldtvm.getCurrentPrime());
    } else if (phase == 2) {
      _primeStopwatch.stop();
      primeDurations.add(_primeStopwatch.elapsedMilliseconds);
      currentPhaseWidget = buildBackwardMask();
    } else if (phase == 3) {
      isTextState = true;
      currentPhaseWidget = buildTarget(vm.ldtvm.getCurrentTarget());
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

  buildTrialSummary() {
    var message = vm.getTrialMessage();
    return Container(
      child: SpeechBubble(
        text: message,
      ),
    );
  }
}
