import 'package:serene/services/user_service.dart';
import 'package:serene/shared/enums.dart';
import 'package:serene/viewmodels/base_view_model.dart';

class LoginViewModel extends BaseViewModel {
  String _userId;
  String _email;

  String get userId => _userId;
  String get userEmail => _email;

  UserService _userService;
  LoginViewModel(this._userService) {
    this._userId = this._userService.getUsername();
    this._email = this._userService.getUserEmail();
  }

  saveUsername(String userId) async {
    _userId = await this._userService.saveUsername(userId);
    this._userId = userId;
  }

  Future<bool> register(String email, String password) async {
    setState(ViewState.busy);
    var success = await this._userService.isNameAvailable(email);
    if (success) {
      _userService.registerUser(email, password);
    }
    setState(ViewState.idle);
    return success;
  }

  signIn(String email, String password) async {
    setState(ViewState.busy);
    var userData = await _userService.signInUser(email, password);
    setState(ViewState.idle);
    return userData != null;
  }

  progressWithoutUsername() async {
    await _userService.saveRandomUser();
  }
}
