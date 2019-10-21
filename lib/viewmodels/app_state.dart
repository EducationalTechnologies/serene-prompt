import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:serene/services/data_service.dart';
import 'package:serene/services/notification_service.dart';
import 'package:serene/services/user_service.dart';

class AppState with ChangeNotifier {
  DataService _dataService;
  UserService _userService;
  NotificationService _notificationService;

  UserService get userService => _userService;
  DataService get dataService => _dataService;
  NotificationService get notificationService => _notificationService;

  AppState() {
    // _userService = UserService();
    _dataService = DataService();
    _notificationService = NotificationService();
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
