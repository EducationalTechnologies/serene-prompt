import 'package:email_validator/email_validator.dart';
import 'package:serene/services/data_service.dart';
import 'package:serene/services/navigation_service.dart';
import 'package:serene/services/user_service.dart';
import 'package:serene/shared/enums.dart';
import 'package:serene/shared/route_names.dart';
import 'package:serene/viewmodels/base_view_model.dart';

class LoginViewModel extends BaseViewModel {
  String _email;
  String get email => _email;

  UserService _userService;
  DataService _dataService;
  NavigationService _navigationService;

  String defaultPassword = "Hasselhoernchen";

  LoginViewModel(
      this._userService, this._dataService, this._navigationService) {}

  Future<String> register(String email, String password) async {
    if (!validateEmail(email)) {
      email = "$email@prompt.studie";
    }
    if (password.isEmpty) {
      // TODO: Change for production to read from environment file
      password = "Hasselhoernchen";
    }

    setState(ViewState.busy);
    var success = "";
    var available = await this._userService.isNameAvailable(email);
    if (available) {
      success = await _userService.registerUser(email, password);
    } else {
      success = await _userService.signInUser(email, password);
    }
    setState(ViewState.idle);
    return success;
  }

  Future<String> signIn(String email, String password) async {
    setState(ViewState.busy);
    var signin = await _userService.signInUser(email, password);
    setState(ViewState.idle);
    return signin;
  }

  submit() async {
    // TODO: Implement
    bool userHasCreatedSession0 = false;

    if (userHasCreatedSession0) {
      _navigationService.navigateTo(RouteNames.NO_TASKS);
    } else {
      _navigationService.navigateTo(RouteNames.INIT_START);
    }
  }

  progressWithoutUsername() async {
    await _userService.saveRandomUser();
  }

  validateEmail(String userid) {
    return EmailValidator.validate(userid);
  }

  validateUserId(String value) {
    return true;
    // TODO: Create new validation function to check if user id is valid
  }
}
