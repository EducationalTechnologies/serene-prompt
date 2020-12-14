import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:serene/screens/initialsession/obstacle_selection_screen.dart';
import 'package:serene/screens/initialsession/obstacle_sorting_screen.dart';
import 'package:serene/screens/initialsession/outcome_selection_screen.dart';
import 'package:serene/screens/initialsession/outcome_sorting_screen.dart';
import 'package:serene/viewmodels/init_session_view_model.dart';

class InitialSessionScreen extends StatefulWidget {
  InitialSessionScreen({Key key}) : super(key: key);

  @override
  _InitialSessionScreenState createState() => _InitialSessionScreenState();
}

class _InitialSessionScreenState extends State<InitialSessionScreen> {
  int _index;
  final _controller = new PageController();
  final _kDuration = const Duration(milliseconds: 300);
  final _kCurve = Curves.ease;

  final List<Widget> _pages = [
    ObstacleSelectionScreen(),
    ObstacleSortingScreen(),
    OutcomeSelectionScreen(),
    OutcomeSortingScreen()
  ];

  @override
  void initState() {
    super.initState();
    _index = 1;
  }

  _buildBottomNavigation() {
    var vm = Provider.of<InitSessionViewModel>(context);
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Visibility(
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            visible: true, // _index > 1 && _index < _pages.length - 1,
            child: FlatButton(
              child: Row(
                children: <Widget>[
                  Icon(Icons.navigate_before),
                  Text(
                    "Zurück",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              onPressed: () {
                setState(() {
                  _index--;
                });
                _controller.previousPage(duration: _kDuration, curve: _kCurve);
              },
            ),
          ),
          ElevatedButton(
              onPressed: () {
                vm.saveSelected();
              },
              child: Text("Test")),
          Visibility(
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            visible: vm.canMoveNext(),
            child: FlatButton(
              child: Row(
                children: <Widget>[
                  Text(
                    "Weiter",
                    style: TextStyle(fontSize: 20),
                  ),
                  Icon(Icons.navigate_next)
                ],
              ),
              onPressed: () {
                setState(() {
                  _index++;
                });
                _controller.nextPage(duration: _kDuration, curve: _kCurve);
              },
            ),
          ),
        ],
      ),
    );
  }

  buildPageView() {
    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          Flexible(
            child: PageView.builder(
              controller: _controller,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _pages.length,
              itemBuilder: (context, index) {
                return _pages[index];
              },
            ),
          ),
          _buildBottomNavigation()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container(child: buildPageView()));
  }
}
