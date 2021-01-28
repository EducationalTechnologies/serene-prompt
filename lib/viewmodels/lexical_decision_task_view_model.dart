import 'package:serene/models/ldt_data.dart';
import 'package:serene/services/experiment_service.dart';
import 'package:serene/viewmodels/base_view_model.dart';
import 'package:serene/shared/extensions.dart';

class LexicalDecisionTaskViewModel extends BaseViewModel {
  final int durationFixationCross = 1000;
  final int durationPrime = 50;
  final int durationBackwardMask = 700;
  final int durationIntertrialScreen = 2000;
  List<int> phaseDurations;

  bool done = false;

  Future<bool> initialized;

  final ExperimentService _experimentService;

  LdtData ldt = LdtData();

  int currenTargetIndex = 0;
  int currentPrimeIndex = 0;

  LexicalDecisionTaskViewModel(this._experimentService) {
    phaseDurations = [
      durationFixationCross,
      durationPrime,
      durationBackwardMask,
      durationIntertrialScreen
    ];

    initialized = init();
  }

  Future<bool> init() async {
    ldt = await this._experimentService.getLdtData();

    ldt.trials = ldt.trials.randomizeList();

    return true;
  }

  getCurrentPrime() {
    var curr = ldt.primes[currentPrimeIndex];
    currentPrimeIndex += 1;
    // Overflow should not happen, but if it does we prefer not to crash
    if (currentPrimeIndex == ldt.primes.length) {
      currentPrimeIndex = 0;
    }
    return curr;
  }

  finish() {
    done = true;
  }

  getCurrentTarget() {
    var curr = ldt.trials[currenTargetIndex].target;
    currenTargetIndex += 1;
    // Overflow should not happen, but if it does we prefer not to crash
    if (currenTargetIndex == ldt.trials.length) {
      finish();
      currenTargetIndex = 0;
    }
    return curr;
  }

  setTrialResult(int msResponseTime, selection) {
    ldt.trials[currenTargetIndex].responseTime = msResponseTime;
    ldt.trials[currenTargetIndex].status = selection;
  }

  submit() async {
    // TODO: Submit the trial
  }
}
