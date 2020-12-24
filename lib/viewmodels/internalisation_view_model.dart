import 'package:serene/services/data_service.dart';
import 'package:serene/viewmodels/base_view_model.dart';

class InternalisationViewModel extends BaseViewModel {
  DataService _dataService;
  String implementationIntention;
  int internalisationCondition = 1;
  InternalisationViewModel(this._dataService) {
    this._dataService.getCurrentImplementationIntention().then((ii) {
      this.implementationIntention = ii;
      notifyListeners();
    });

    this._dataService.getInternalisationCondition().then((c) {
      this.internalisationCondition = c;
    });
  }
}
