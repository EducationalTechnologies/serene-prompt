import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:implementation_intentions/services/data_service.dart';

class AppState with ChangeNotifier {
  reloadData() {
    DataService().fetchData();
  }
}
