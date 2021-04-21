import 'package:email_validator/email_validator.dart';
import 'package:prompt/locator.dart';
import 'package:prompt/services/navigation_service.dart';
import 'package:prompt/services/reward_service.dart';
import 'package:prompt/services/user_service.dart';
import 'package:prompt/shared/enums.dart';
import 'package:prompt/shared/route_names.dart';
import 'package:prompt/viewmodels/base_view_model.dart';
import 'package:prompt/services/data_service.dart';
import 'package:prompt/viewmodels/init_session_view_model.dart';

class LoginViewModel extends BaseViewModel {
  String _email;
  String get email => _email;

  UserService _userService;
  NavigationService _navigationService;

  String defaultPassword = "Hasselhoernchen";

  LoginViewModel(this._userService, this._navigationService);

  Future<String> register(String input, String password) async {
    var email = input;
    if (!validateEmail(email)) {
      email = "$email@prompt.studie";
    }
    if (password.isEmpty) {
      password = getDefaultPassword(input);
    }

    setState(ViewState.busy);
    var success = "";
    var available = await this._userService.isNameAvailable(email);
    success = await _userService.signInUser(email, password);
    if (available) {
      success = await _userService.registerUser(email, password);
    } else {}
    setState(ViewState.idle);
    return success;
  }

  Future<String> signIn(String input, String password) async {
    var email = input;
    if (!validateEmail(email)) {
      email = "$email@prompt.studie";
    }
    if (password.isEmpty) {
      // TODO: Change for production to read from environment file
      password = getDefaultPassword(input);
    }
    setState(ViewState.busy);
    var signin = await _userService.signInUser(email, password);
    await locator<RewardService>().initialize();
    setState(ViewState.idle);
    return signin;
  }

  getDefaultPassword(String userid) {
    return "hasselhoernchen!$userid";
  }

  submit() async {
    int maxStep = await locator<DataService>().getCompletedInitialSessionStep();
    locator<DataService>().setRegistrationDate(DateTime.now());
    bool userHasCreatedSession0 = maxStep == STEP.values.length;
    if (userHasCreatedSession0) {
      _navigationService.navigateTo(RouteNames.NO_TASKS);
    } else {
      // TODO: Incorporate completed steps
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
