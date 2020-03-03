import 'dart:math';

import 'package:flutter/material.dart';
import 'package:serene/screens/internalisation/long_press_internalisation.dart';
import 'package:serene/screens/internalisation/scramble_internalisation.dart';
import 'package:serene/screens/internalisation/typing_internalisation_screen.dart';
import 'package:serene/screens/internalisation/waiting_internalisation_screen.dart';

class GoalShieldingInternalisationScreen extends StatefulWidget {
  @override
  _GoalShieldingInternalisationScreenState createState() =>
      _GoalShieldingInternalisationScreenState();
}

class _GoalShieldingInternalisationScreenState
    extends State<GoalShieldingInternalisationScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var rng = Random();
    // var next = rng.nextInt(3);
    var next = 2;
    Widget internalisation = LongPressInternalisation();
    if (next == 0) {
      internalisation = LongPressInternalisation();
    } else if (next == 1) {
      internalisation = TypingInternalisationScreen();
    } else if (next == 2) {
      internalisation = ScrambleInternalisation();
    } else if (next == 3) {
      internalisation = WaitingInternalisationScreen();
    }
    return Scaffold(backgroundColor: Colors.transparent, body: internalisation);
  }
}
