import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:serene/services/data_service.dart';
import 'package:serene/services/user_service.dart';

class AppState with ChangeNotifier {
  DataService dataService;
  UserService _userService;

  UserService get userService => _userService;

  AppState() {
    dataService = DataService();
    _userService = UserService();
    reloadData();
  }

  reloadData() async {
    await dataService.fetchData();
  }

  reloadGoals() async {
    await dataService.fetchData();
  }

  reloadOpenGoals() {}
}
