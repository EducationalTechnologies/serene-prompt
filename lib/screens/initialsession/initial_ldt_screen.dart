import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serene/shared/ui_helpers.dart';
import 'package:serene/viewmodels/init_session_view_model.dart';
import 'package:serene/viewmodels/lexical_decision_task_view_model.dart';
import 'package:serene/widgets/full_width_button.dart';
import 'package:serene/widgets/speech_bubble.dart';

class InitialLdtScreen extends StatefulWidget {
  final String trialName;
  final VoidCallback onFinished;

  InitialLdtScreen(this.trialName, this.onFinished, {Key key})
      : super(key: key);

  @override
  _InitialLdtScreenState createState() => _InitialLdtScreenState();
}

class _InitialLdtScreenState extends State<InitialLdtScreen> {
  LexicalDecisionTaskViewModel vm;
  Future<bool> ldtLoaded;
  final TextStyle ldtTextStyle = TextStyle(fontSize: 40, color: Colors.black);

  @override
  void initState() {
    super.initState();

    ldtLoaded = Provider.of<InitSessionViewModel>(context, listen: false)
        .initTrial(this.widget.trialName)
        .then((value) {
      return true;
    }).then((value) => true);

    vm = Provider.of<InitSessionViewModel>(context, listen: false).ldtvm;
    vm.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => {
          if (vm.done) {widget.onFinished()}
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
        return CircularProgressIndicator();
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
              currentPhaseWidget,
              Visibility(
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
    var message = Provider.of<InitSessionViewModel>(context, listen: false)
        .getTrialMessage();
    return Container(
      child: SpeechBubble(
        text: message,
      ),
    );
  }
}
