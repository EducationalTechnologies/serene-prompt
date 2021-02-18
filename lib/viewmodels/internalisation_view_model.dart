import 'package:serene/models/internalisation.dart';
import 'package:serene/services/data_service.dart';
import 'package:serene/services/experiment_service.dart';
import 'package:serene/shared/enums.dart';
import 'package:serene/viewmodels/base_view_model.dart';

class InternalisationViewModel extends BaseViewModel {
  final DataService _dataService;
  final ExperimentService _experimentService;

  String implementationIntention = "";
  Future<bool> initialized;
  InternalisationCondition internalisationCondition =
      InternalisationCondition.waiting;
  Duration waitingDuration = Duration(seconds: 15);
  Internalisation _currentInternalisation = Internalisation();

  InternalisationViewModel(this._dataService, this._experimentService) {
    _currentInternalisation.startDate = DateTime.now();

    initialized = init();
    waitingDuration = ExperimentService.WAITING_TIMER_DURATION;
  }

  Future<bool> init() async {
    this.implementationIntention =
        await this._dataService.getCurrentImplementationIntention();

    this.internalisationCondition =
        await _experimentService.getTodaysInternalisationCondition();

    return true;
  }

  Future<bool> submit(InternalisationCondition condition, String input) async {
    if (state == ViewState.busy) return false;
    setState(ViewState.busy);

    _currentInternalisation.completionDate = DateTime.now();
    _currentInternalisation.input = input;
    _currentInternalisation.implementationIntention = implementationIntention;
    _currentInternalisation.condition = condition.toString();
    await this
        ._experimentService
        .submitInternalisation(_currentInternalisation);
    return true;
  }
}
