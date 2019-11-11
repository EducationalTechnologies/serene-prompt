import 'package:flutter/material.dart';
import 'package:serene/screens/goal_shielding/goal_selection_screen.dart';
import 'package:serene/screens/goal_shielding/goal_shielding_internalisation_screen.dart';
import 'package:serene/screens/goal_shielding/goal_shielding_selection_screen.dart';
import 'package:serene/shared/route_names.dart';
import 'package:serene/widgets/serene_drawer.dart';

class GoalShieldingScreen extends StatefulWidget {
  @override
  _GoalShieldingScreenState createState() => _GoalShieldingScreenState();
}

class _GoalShieldingScreenState extends State<GoalShieldingScreen> {
  int _index;
  final _controller = new PageController();
  final _kDuration = const Duration(milliseconds: 300);
  final _kCurve = Curves.ease;

  final List<Widget> _goalShieldingPages = [
    GoalSelectionScreen(),
    GoalShieldingSelectionScreen(),
    GoalShieldingInternalisationScreen()
  ];

  @override
  void initState() {
    super.initState();
    _index = 1;
  }

  _buildBackgroundImage() {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/illustrations/undraw_dream_world_cin1.png"),
        fit: BoxFit.scaleDown,
      )),
    );
  }

  _buildBottomNavigation() {
    print("index is $_index ");
    print("length is ${_goalShieldingPages.length} ");
    return Container(
      // color: Colors.lightBlue[50],

      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Visibility(
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            visible: _index > 1,
            child: FlatButton(
              child: Row(
                children: <Widget>[
                  Icon(Icons.navigate_before),
                  Text("Zurück"),
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
          Visibility(
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            visible: _index < _goalShieldingPages.length,
            child: FlatButton(
              child: Row(
                children: <Widget>[Text("Weiter"), Icon(Icons.navigate_next)],
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

  _buildAddGoalButton() {
    if(_index != 1) {
      return null;
    }
    return FloatingActionButton(
      // backgroundColor: Theme.of(context).accentColor,
      backgroundColor: Colors.blue[400],
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: Icon(Icons.add),
      onPressed: () async {
        Navigator.pushNamed(context, RouteNames.ADD_GOAL);
        // Provider.of<GoalMonitoringState>(context).fetchData();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print("Calling Build In Goal Shielding Screen");
    if (_goalShieldingPages?.length == 0) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          textTheme:
              TextTheme(title: TextStyle(color: Colors.black, fontSize: 22)),
          centerTitle: true,

          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(""),
        ),
        floatingActionButton: _buildAddGoalButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        drawer: SereneDrawer(),
        // backgroundColor: Colors.amber,
        body: Stack(
          children: <Widget>[
            // _buildBackgroundImage(),
            Container(
              margin: EdgeInsets.all(10),
              child: Column(
                children: [
                  Flexible(
                    child: PageView.builder(
                      controller: _controller,
                      itemCount: _goalShieldingPages.length,
                      itemBuilder: (context, index) {
                        return _goalShieldingPages[index];
                      },
                    ),
                  ),
                  _buildBottomNavigation()
                ],
              ),
            ),
          ],
        )
        // body: Container(
        //   decoration: BoxDecoration(
        //       image: DecorationImage(
        //     image: AssetImage("assets/illustrations/undraw_dream_world_cin1.png"),
        //     fit: BoxFit.scaleDown,
        //   )),
        //   margin: EdgeInsets.all(10),
        //   child: Column(
        //     children: [
        //       Flexible(
        //         child: PageView.builder(
        //           controller: _controller,
        //           itemCount: _goalShieldingPages.length,
        //           itemBuilder: (context, index) {
        //             return _goalShieldingPages[index];
        //           },
        //         ),
        //       ),
        //       _buildBottomNavigation()
        //     ],
        //   ),
        // ),
        );
  }
}
