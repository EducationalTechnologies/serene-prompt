import 'package:serene/services/user_service.dart';
import 'package:serene/viewmodels/base_view_model.dart';

class LoginViewModel extends BaseViewModel {
  String _userId;

  String get userId => _userId;

  UserService _userService;
  LoginViewModel(this._userService) {
    this._userId = this._userService.getUsername();
  }

  saveUsername(String userId) async {
    _userId = await this._userService.saveUsername(userId);
    this._userId = userId;
  }

  register(String userID, String password) async {
    await this._userService.isNameAvailable(userId);
  }

  progressWithoutUsername() async {
    await _userService.saveRandomUsername();
  }
}
