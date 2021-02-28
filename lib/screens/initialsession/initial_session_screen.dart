import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:serene/screens/initialsession/initial_explanation_screen.dart';
import 'package:serene/screens/initialsession/obstacle_enter_screen.dart';
import 'package:serene/screens/initialsession/obstacle_selection_screen.dart';
import 'package:serene/screens/initialsession/obstacle_sorting_screen.dart';
import 'package:serene/screens/initialsession/outcome_enter_screen.dart';
import 'package:serene/screens/initialsession/outcome_selection_screen.dart';
import 'package:serene/screens/initialsession/outcome_sorting_screen.dart';
import 'package:serene/screens/initialsession/video_screen.dart';
import 'package:serene/screens/initialsession/welcome_screen.dart';
import 'package:serene/screens/initialsession/cabuu_link_screen.dart';
import 'package:serene/shared/route_names.dart';
import 'package:serene/viewmodels/init_session_view_model.dart';
import 'package:serene/widgets/full_width_button.dart';

class InitialSessionScreen extends StatefulWidget {
  InitialSessionScreen({Key key}) : super(key: key);

  @override
  _InitialSessionScreenState createState() => _InitialSessionScreenState();
}

class _InitialSessionScreenState extends State<InitialSessionScreen> {
  final _controller = new PageController();
  final _kDuration = const Duration(milliseconds: 300);
  final _kCurve = Curves.ease;

  final List<Widget> _pages = [
    WelcomeScreen(), // 0
    VideoScreen("Erstes Video"),
    CabuuLinkScreen(),
    OutcomeSelectionScreen(),
    OutcomeEnterScreen(),
    OutcomeSortingScreen(),
    ObstacleSelectionScreen(),
    ObstacleEnterScreen(),
    ObstacleSortingScreen(),
    InitialExplanationScreen(),
  ];

  @override
  void initState() {
    super.initState();

    /// Attach a listener which will update the state and refresh the page index
    _controller.addListener(() {
      var vm = Provider.of<InitSessionViewModel>(context, listen: false);
      if (_controller.page.round() != vm.step) {
        setState(() {
          vm.step = _controller.page.round();
        });
      }
    });
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
            visible:
                vm.canMoveBack(), // _index > 1 && _index < _pages.length - 1,
            child: TextButton(
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
                _controller.previousPage(duration: _kDuration, curve: _kCurve);
              },
            ),
          ),
          Visibility(
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            visible: vm.canMoveNext(),
            child: ElevatedButton(
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
                if (vm.canMoveNext()) {
                  // _controller.jumpToPage(vm.getNextPage());
                  _controller.animateToPage(vm.getNextPage(),
                      duration: _kDuration, curve: _kCurve);
                  // _controller.nextPage(duration: _kDuration, curve: _kCurve);
                }
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }

  buildSubmitButton() {
    var vm = Provider.of<InitSessionViewModel>(context, listen: false);
    return FullWidthButton(onPressed: () async {
      await vm.submit();
      Navigator.pushNamed(context, RouteNames.INTERNALISATION);
    });
  }

  buildPageView() {
    var vm = Provider.of<InitSessionViewModel>(context);
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
          if (vm.step < _pages.length - 1) _buildBottomNavigation(),
          if (vm.step == _pages.length - 1) buildSubmitButton()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(body: Container(child: buildPageView())));
  }
}
