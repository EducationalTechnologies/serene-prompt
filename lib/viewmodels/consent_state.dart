import 'package:flutter/widgets.dart';

class ConsentState extends ChangeNotifier {
  bool _consented = false;

  get consented => _consented;

  set consented(val) {
    _consented = val;
    notifyListeners();
  }
}
