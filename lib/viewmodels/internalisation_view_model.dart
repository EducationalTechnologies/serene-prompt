import 'package:serene/models/internalisation.dart';
import 'package:serene/services/data_service.dart';
import 'package:serene/viewmodels/base_view_model.dart';

class InternalisationViewModel extends BaseViewModel {
  DataService _dataService;
  String implementationIntention;
  int internalisationCondition = 1;

  Internalisation _currentInternalisation = Internalisation();

  InternalisationViewModel(this._dataService) {
    this._dataService.getCurrentImplementationIntention().then((ii) {
      this.implementationIntention = ii;
      notifyListeners();
    });

    this._dataService.getInternalisationCondition().then((c) {
      this.internalisationCondition = c;
    });

    _currentInternalisation.startDate = DateTime.now();
  }

  Future<bool> submit() async {
    _currentInternalisation.completionDate = DateTime.now();
    _currentInternalisation.implementationIntention = implementationIntention;
    return await this._dataService.saveInternalisation(_currentInternalisation);
  }
}
