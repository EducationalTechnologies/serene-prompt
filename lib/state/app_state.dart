import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:serene/services/data_service.dart';
import 'package:serene/services/user_service.dart';

class AppState with ChangeNotifier {
  DataService _dataService;
  UserService _userService;

  UserService get userService => _userService;
  DataService get dataService => _dataService;

  AppState() {
    _dataService = DataService();
    _userService = UserService();
    // reloadData();
  }

  reloadData() async {
    await _dataService.fetchOpenGoals();
  }

  reloadGoals() async {
    await _dataService.fetchOpenGoals();
  }

  reloadOpenGoals() {}
}
