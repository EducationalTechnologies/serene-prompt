import 'dart:async';

import 'package:serene/models/ldt_data.dart';
import 'package:serene/services/experiment_service.dart';
import 'package:serene/shared/enums.dart';
import 'package:serene/shared/route_names.dart';
import 'package:serene/viewmodels/base_view_model.dart';

class LexicalDecisionTaskViewModel extends BaseViewModel {
  final int durationFixationCross = 1000;
  final int durationPrime = 40;
  final int durationBackwardMask = 700;
  final int durationIntertrialScreen = 5000;
  List<int> phaseDurations;

  bool done = false;

  final ExperimentService _experimentService;
  final String _trialName;

  LdtData ldt = LdtData();

  Stopwatch _primeStopwatch = Stopwatch();
  Stopwatch _stopwatch;
  List<int> primeDurations = [];
  int phase = 0;
  int currentStep = 0;
  int currenTargetIndex = -1;
  int currentPrimeIndex = -1;
  Timer _ldtTimer;

  LexicalDecisionTaskViewModel(this._trialName, this._experimentService) {
    phaseDurations = [
      durationFixationCross,
      durationPrime,
      durationBackwardMask,
      durationIntertrialScreen
    ];

    _stopwatch = Stopwatch();
    _primeStopwatch = Stopwatch();
  }

  change() {
    int duration = phaseDurations[phase];
    _ldtTimer = Timer(Duration(milliseconds: duration), () {
      nextStep();
      if (!done) {
        change();
      }
    });
  }

  nextStep() {
    _stopwatch.reset();
    _stopwatch.start();
    currentStep += 1;
    phase = currentStep % phaseDurations.length;
    notifyListeners();
  }

  @override
  dispose() {
    super.dispose();
    _stopwatch.stop();
    _primeStopwatch.stop();
  }

  pressed(int selection) {
    _stopwatch.stop();
    setTrialResult(
        _stopwatch.elapsedMilliseconds, selection, primeDurations.last);
    _ldtTimer.cancel();
    nextStep();
    change();
  }

  Future<LdtData> init() async {
    ldt = await this._experimentService.getLdtData(this._trialName);

    ldt.startDate = DateTime.now();
    ldt.durationBackwardMask = this.durationBackwardMask;
    ldt.durationFixationCross = this.durationFixationCross;
    ldt.durationInterTrialScreen = this.durationIntertrialScreen;
    ldt.durationPrime = this.durationPrime;

    change();

    return ldt;
  }

  getProgress() {
    return currenTargetIndex / ldt.targets.length;
  }

  finish() {
    _stopwatch.stop();
    _primeStopwatch.stop();
    done = true;
    ldt.completionDate = DateTime.now();
    _experimentService.submitLDT(ldt);
  }

  startPrimeStopwatch() {
    _primeStopwatch.reset();
    _primeStopwatch.start();
  }

  stopPrimeStopwatch() {
    _primeStopwatch.stop();
    primeDurations.add(_primeStopwatch.elapsedMilliseconds);
  }

  getNextTarget() {
    if (currenTargetIndex + 1 == ldt.targets.length) {
      finish();
    } else {
      currenTargetIndex += 1;
    }

    var curr = ldt.trials[currenTargetIndex].target;

    return curr;
  }

  getNextPrime() {
    if (currentPrimeIndex + 1 == ldt.primes.length) {
      finish();
      return "";
    }
    currentPrimeIndex += 1;
    var curr = ldt.primes[currentPrimeIndex];

    return curr;
  }

  setTrialResult(int msResponseTime, int selection, int primeDuration) {
    ldt.trials[currenTargetIndex].primeDuration = primeDuration;
    ldt.trials[currenTargetIndex].responseTime = msResponseTime;
    ldt.trials[currenTargetIndex].selection = selection;
  }

  submit() async {
    if (state == ViewState.busy) return;
    setState(ViewState.busy);

    _experimentService.nextScreen(RouteNames.LDT);
  }
}
