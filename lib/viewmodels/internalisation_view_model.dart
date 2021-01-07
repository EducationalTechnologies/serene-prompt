import 'package:serene/models/internalisation.dart';
import 'package:serene/services/data_service.dart';
import 'package:serene/shared/enums.dart';
import 'package:serene/viewmodels/base_view_model.dart';

class InternalisationViewModel extends BaseViewModel {
  DataService _dataService;
  String implementationIntention;
  InternalisationCondition internalisationCondition =
      InternalisationCondition.waiting;

  Internalisation _currentInternalisation = Internalisation();

  InternalisationViewModel(this._dataService) {
    this._dataService.getCurrentImplementationIntention().then((ii) {
      this.implementationIntention = ii;
      notifyListeners();
    });

    this._dataService.getInternalisationCondition().then((c) {
      this.internalisationCondition = InternalisationCondition.values[c];
    });

    _currentInternalisation.startDate = DateTime.now();
  }

  Future<bool> submit(InternalisationCondition condition) async {
    this.setState(ViewState.busy);
    _currentInternalisation.completionDate = DateTime.now();
    _currentInternalisation.implementationIntention = implementationIntention;
    _currentInternalisation.condition = condition.toString();
    await this._dataService.saveInternalisation(_currentInternalisation);
    return true;
  }
}
