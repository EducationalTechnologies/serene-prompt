import 'package:flutter/material.dart';
import 'package:serene/screens/goal_monitor_screen.dart';
import 'package:serene/screens/resource_links_screen.dart';
import 'package:serene/shared/route_names.dart';
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
    _controller = new PageController(initialPage: _selectedPageIndex);
    super.initState();
  }

  static List<Widget> _widgetOptions = [
    GoalMonitorScreen(),
    ResourceLinksScreen(),
    ResourceLinksScreen()
  ];

  void _onItemTapped(int index) {
    this._controller.animateToPage(index,
        duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
  }

  buildAddGoalButton() {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).accentColor,
      child: Icon(Icons.add),
      onPressed: () async {
        await Navigator.pushNamed(context, RouteNames.ADD_GOAL);
        // Provider.of<GoalMonitoringState>(context).fetchData();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Serene"),
        elevation: 0.0,
      ),
      drawer: SereneDrawer(),
      floatingActionButton: buildAddGoalButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: PageView(
        controller: _controller,
        onPageChanged: (newPage) {
          setState(() {
            _selectedPageIndex = newPage;
          });
        },
        children: _widgetOptions,
      ),
      // TODO: Change the navigation bar to: https://medium.com/coding-with-flutter/flutter-bottomappbar-navigation-with-fab-8b962bb55013
      bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          child: BottomNavigationBar(
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
                  icon: Icon(Icons.terrain), title: Text("Statistiken")),
              BottomNavigationBarItem(
                  icon: Icon(Icons.wallpaper), title: Text("Resourcen"))
            ],
            currentIndex: _selectedPageIndex,
            onTap: (index) {
              _onItemTapped(index);
            },
          )),
    );
  }
}
