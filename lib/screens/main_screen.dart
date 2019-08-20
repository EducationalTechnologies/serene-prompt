import 'package:flutter/material.dart';
import 'package:implementation_intentions/screens/add_goal.dart';
import 'package:implementation_intentions/screens/goal_monitor_screen.dart';
import 'package:implementation_intentions/screens/reflect_screen.dart';
import 'package:implementation_intentions/services/data_service.dart';
import 'package:implementation_intentions/widgets/serene_drawer.dart';

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
    DataService().fetchData();
    super.initState();
  }

  static List<Widget> _widgetOptions = [
    // AddGoal(),
    // GoalMonitorScreen(),
    // ReflectScreen()
    Text("Eins"),
    Text("Zwei"),
    Text("Drei")
  ];

  void _onItemTapped(int index) {
    this._controller.animateToPage(index,
        duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Serene"),
      ),
      drawer: SereneDrawer(),
      backgroundColor: Colors.white,
      body: PageView(
        controller: _controller,
        onPageChanged: (newPage) {
          setState(() {
            _selectedPageIndex = newPage;
          });
        },
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), title: Text("Neues Ziel")),
          BottomNavigationBarItem(
              icon: Icon(Icons.view_list), title: Text("Ziele")),
          BottomNavigationBarItem(
              icon: Icon(Icons.wallpaper), title: Text("Statistiken"))
        ],
        currentIndex: _selectedPageIndex,
        selectedItemColor: Colors.amber[800],
        onTap: (index) {
          _onItemTapped(index);
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   tooltip: 'Increment',
      //   child: Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
