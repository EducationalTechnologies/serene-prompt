import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:serene/services/data_service.dart';

class AppState with ChangeNotifier {
  reloadData() async {
    await DataService().fetchData();
  }

  reloadGoals() async {
    await DataService().fetchData();
  }

  reloadOpenGoals() {}
}
