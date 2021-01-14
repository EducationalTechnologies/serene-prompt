import 'package:serene/models/internalisation.dart';
import 'package:serene/services/data_service.dart';
import 'package:serene/services/navigation_service.dart';
import 'package:serene/shared/enums.dart';
import 'package:serene/shared/route_names.dart';
import 'package:serene/viewmodels/base_view_model.dart';

class InternalisationViewModel extends BaseViewModel {
  DataService _dataService;
  NavigationService _navigationService;
  String implementationIntention;
  InternalisationCondition internalisationCondition =
      InternalisationCondition.waiting;

  Internalisation _currentInternalisation = Internalisation();

  InternalisationViewModel(this._dataService, this._navigationService) {
    this._dataService.getCurrentImplementationIntention().then((ii) {
      this.implementationIntention = ii;
      notifyListeners();
    });

    this._dataService.getUserData().then((ud) {
      this.internalisationCondition =
          InternalisationCondition.values[ud.internalisationCondition];
    });

    _currentInternalisation.startDate = DateTime.now();
  }

  Future<bool> submit(InternalisationCondition condition) async {
    this.setState(ViewState.busy);
    _currentInternalisation.completionDate = DateTime.now();
    _currentInternalisation.implementationIntention = implementationIntention;
    _currentInternalisation.condition = condition.toString();
    await this._dataService.saveInternalisation(_currentInternalisation);

    _navigationService.navigateTo(RouteNames.NO_TASKS);
    return true;
  }
}
