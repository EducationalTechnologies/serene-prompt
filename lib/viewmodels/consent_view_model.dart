import 'package:prompt/services/data_service.dart';
import 'package:prompt/services/navigation_service.dart';
import 'package:prompt/services/user_service.dart';
import 'package:prompt/shared/enums.dart';
import 'package:prompt/shared/route_names.dart';
import 'package:prompt/viewmodels/base_view_model.dart';

class ConsentViewModel extends BaseViewModel {
  bool _consented = false;
  final UserService _userService;
  final NavigationService _navigationService;
  final DataService _dataService;

  ConsentViewModel(
      this._dataService, this._userService, this._navigationService);

  get consented => _consented;

  set consented(val) {
    _consented = val;
    notifyListeners();
  }

  submit() async {
    setState(ViewState.busy);
    await this._userService.saveRandomUser();
    await this._dataService.saveConsent(true);
    this._navigationService.navigateWithReplacement(RouteNames.INIT_START);
  }
}
