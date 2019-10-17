import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serene/locator.dart';
import 'package:serene/screens/goal_monitor_screen.dart';
import 'package:serene/screens/resource_links_screen.dart';
import 'package:serene/screens/timer_screen.dart';
import 'package:serene/services/data_service.dart';
import 'package:serene/shared/route_names.dart';
import 'package:serene/viewmodels/goal_monitoring_state.dart';
import 'package:serene/widgets/serene_drawer.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedPageIndex = 0;
  PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new PageController(initialPage: _selectedPageIndex);
  }

  buildMonitoringScreen() {
    return ChangeNotifierProvider<GoalMonitoringState>(
      builder: (_) => GoalMonitoringState(locator.get<DataService>()),
      child: GoalMonitorScreen(),
    );
  }

  void _onItemTapped(int index) {
    if (index == 3) return;
    this._controller.animateToPage(index,
        duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
  }

  buildAddGoalButton() {
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
    print("Build MAIN Screen");
    return Scaffold(
      appBar: AppBar(
        // title: Text("Serene"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      drawer: SereneDrawer(),
      floatingActionButton: buildAddGoalButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      body: PageView(
        controller: _controller,
        onPageChanged: (newPage) {
          setState(() {
            _selectedPageIndex = newPage;
          });
        },
        children: [
          buildMonitoringScreen(),
          TimerScreen(),
          ResourceLinksScreen(),
          ResourceLinksScreen(),
        ],
      ),
      // TODO: Change the navigation bar to: https://medium.com/coding-with-flutter/flutter-bottomappbar-navigation-with-fab-8b962bb55013
      bottomNavigationBar: BottomAppBar(
          elevation: 15.0,
          color: Colors.black,
          clipBehavior: Clip.antiAlias,
          shape: AutomaticNotchedShape(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(0))),
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            elevation: 15.0,
            selectedItemColor: Colors.white,
            selectedIconTheme: IconThemeData(color: Colors.white, size: 30),
            selectedLabelStyle:
                TextStyle(color: Colors.white, decorationColor: Colors.white),
            backgroundColor: Theme.of(context).primaryColor,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.view_list),
                title: Text("Ziele"),
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.terrain), title: Text("Timer")),
              BottomNavigationBarItem(
                  icon: Icon(Icons.wallpaper), title: Text("Resourcen")),
              BottomNavigationBarItem(
                  icon: Icon(Icons.expand_less), title: Text(""))
            ],
            currentIndex: _selectedPageIndex,
            onTap: (index) {
              _onItemTapped(index);
            },
          )),
    );
  }
}
