import 'package:flutter/material.dart';
import 'package:serene/services/user_service.dart';

class LoginState with ChangeNotifier {
  String _userId;

  String get userId => _userId;

  UserService _userService;
  LoginState(this._userService) {
    this._userId = this._userService.getUsername();
  }

  saveUsername(String userId) async {
    _userId = await this._userService.saveUsername(userId);
    this._userId = userId;
  }
}
