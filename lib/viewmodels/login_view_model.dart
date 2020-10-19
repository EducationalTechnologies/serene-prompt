import 'package:email_validator/email_validator.dart';
import 'package:serene/services/data_service.dart';
import 'package:serene/services/user_service.dart';
import 'package:serene/shared/enums.dart';
import 'package:serene/viewmodels/base_view_model.dart';

enum SignInScreenMode { signIn, register }

class LoginViewModel extends BaseViewModel {
  String _email;
  String get email => _email;

  SignInScreenMode mode;

  UserService _userService;
  DataService _dataService;

  LoginViewModel(this._userService, this._dataService) {
    this._email = this._userService.getUserEmail();

    if (this._email == null) {
      mode = SignInScreenMode.register;
    } else {
      mode = SignInScreenMode.signIn;
    }
  }

  Future<String> register(String email, String password) async {
    setState(ViewState.busy);
    var success = "";
    var available = await this._userService.isNameAvailable(email);
    if (available) {
      success = await _userService.registerUser(email, password);
      _dataService.clearCache();
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

  progressWithoutUsername() async {
    await _userService.saveRandomUser();
  }

  validateEmail(String value) {
    return EmailValidator.validate(value);
  }

  toRegisterScreen() {
    this._email = "";
    this.mode = SignInScreenMode.register;
    notifyListeners();
  }

  toSignInScreen() {
    this._email = "";
    this.mode = SignInScreenMode.signIn;
    notifyListeners();
  }
}
