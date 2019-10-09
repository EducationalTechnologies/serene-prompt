import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:serene/services/data_service.dart';
import 'package:serene/services/user_service.dart';

class AppState with ChangeNotifier {
  DataService dataService;
  // UserService userService;

  AppState() {
    dataService = DataService();
    // userService = UserService();
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
