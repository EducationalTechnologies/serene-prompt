import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:serene/services/data_service.dart';

class AppState with ChangeNotifier {
  DataService dataService;

  AppState() {
    dataService = DataService();
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
