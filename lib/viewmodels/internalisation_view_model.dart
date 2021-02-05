import 'dart:math';

import 'package:serene/models/internalisation.dart';
import 'package:serene/services/data_service.dart';
import 'package:serene/services/experiment_service.dart';
import 'package:serene/services/navigation_service.dart';
import 'package:serene/services/notification_service.dart';
import 'package:serene/services/reward_service.dart';
import 'package:serene/shared/enums.dart';
import 'package:serene/shared/route_names.dart';
import 'package:serene/viewmodels/base_view_model.dart';

class InternalisationViewModel extends BaseViewModel {
  final DataService _dataService;
  final NavigationService _navigationService;
  final ExperimentService _experimentService;
  final RewardService _rewardService;
  String implementationIntention = "";
  Future<bool> initialized;
  InternalisationCondition internalisationCondition =
      InternalisationCondition.waiting;

  Internalisation _currentInternalisation = Internalisation();

  InternalisationViewModel(this._dataService, this._navigationService,
      this._experimentService, this._rewardService) {
    _currentInternalisation.startDate = DateTime.now();

    initialized = init();
  }

  Future<bool> init() async {
    this.implementationIntention =
        await this._dataService.getCurrentImplementationIntention();

    // TODO: TEMP! CHANGE BACK TO REGULAR!
    var random = Random();
    this.internalisationCondition =
        InternalisationCondition.values[random.nextInt(3)];
    // this.internalisationCondition =
    //     await _experimentService.getTodaysInternalisationCondition();

    return true;
  }

  Future<bool> submit(InternalisationCondition condition, String input) async {
    this.setState(ViewState.busy);
    _currentInternalisation.completionDate = DateTime.now();
    _currentInternalisation.input = input;
    _currentInternalisation.implementationIntention = implementationIntention;
    _currentInternalisation.condition = condition.toString();
    await this._dataService.saveInternalisation(_currentInternalisation);

    await this._rewardService.addPoints(1);

    this
        ._experimentService
        .scheduleRecallTaskNotificationIfAppropriate(DateTime.now());

    await _navigationService.navigateTo(RouteNames.NO_TASKS, arguments: this);
    return true;
  }
}
