import 'package:flutter/material.dart';
import 'package:serene/screens/internalisation/long_press_internalisation.dart';
import 'package:serene/screens/internalisation/scramble_internalisation.dart';

class GoalShieldingInternalisationScreen extends StatefulWidget {
  @override
  _GoalShieldingInternalisationScreenState createState() =>
      _GoalShieldingInternalisationScreenState();
}

class _GoalShieldingInternalisationScreenState
    extends State<GoalShieldingInternalisationScreen>
    with TickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    // return Container(
    //     padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
    //     child: LongPressInternalisation());
    return Scaffold(
        bottomNavigationBar: Material(
          child: TabBar(
            controller: _controller,
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.watch),
                text: "Long Press",
              ),
              // Tab(icon: Icon(Icons.headset_mic), ),
              Tab(
                icon: Icon(Icons.textsms),
                text: "Scramble",
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _controller,
          children: <Widget>[
            LongPressInternalisation(),
            // SpeechInternalisation(),
            ScrambleInternalisation()
          ],
        ));
  }
}
