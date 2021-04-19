import 'package:prompt/models/internalisation.dart';
import 'package:prompt/services/data_service.dart';
import 'package:prompt/services/experiment_service.dart';
import 'package:prompt/shared/enums.dart';
import 'package:prompt/shared/route_names.dart';
import 'package:prompt/viewmodels/base_view_model.dart';

class InternalisationViewModel extends BaseViewModel {
  final DataService _dataService;
  final ExperimentService _experimentService;

  String get plan => _currentInternalisation.plan;

  List<String> scrambleCorrections = [];

  Future<bool> initialized;
  InternalisationCondition internalisationCondition =
      InternalisationCondition.waiting;
  Duration waitingDuration = Duration(seconds: 15);
  Internalisation _currentInternalisation = Internalisation();

  InternalisationViewModel(
    this._dataService,
    this._experimentService,
  ) {
    initialized = init();
    waitingDuration = ExperimentService.WAITING_TIMER_DURATION;
  }

  Future<bool> init() async {
    var numberOf = await _experimentService.getDayOfExperiment();
    var ud = await _dataService.getUserData();
    _currentInternalisation =
        await _experimentService.getTodaysPlan(numberOf, ud.group);
    _currentInternalisation.startDate = DateTime.now();
    this.internalisationCondition =
        await _experimentService.getTodaysInternalisationCondition(numberOf);

    return true;
  }

  void onScrambleCorrection(String correction) {
    scrambleCorrections.add(correction);
  }

  Future<bool> submit(InternalisationCondition condition, String input) async {
    if (state == ViewState.busy) return false;
    setState(ViewState.busy);

    _currentInternalisation.completionDate = DateTime.now();
    _currentInternalisation.input = input;
    _currentInternalisation.plan = plan;
    _currentInternalisation.condition = condition.toString();
    await this
        ._experimentService
        .submitInternalisation(_currentInternalisation);

    _dataService.saveScrambleCorrections(
        scrambleCorrections, _currentInternalisation.planId);

    _experimentService.nextScreen(RouteNames.INTERNALISATION);
    return true;
  }
}
