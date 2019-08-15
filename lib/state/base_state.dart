import 'package:flutter/material.dart';
import 'package:implementation_intentions/shared/enums.dart';

class BaseState extends ChangeNotifier {
  ViewState _state = ViewState.idle;

  ViewState get state => _state;

  void setState(ViewState state) {
    _state = state;
    notifyListeners();
  }
}
