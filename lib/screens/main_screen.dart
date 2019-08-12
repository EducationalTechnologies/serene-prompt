import 'package:flutter/material.dart';
import 'package:implementation_intentions/screens/add_goal.dart';
import 'package:implementation_intentions/screens/goal_monitor_screen.dart';
import 'package:implementation_intentions/screens/reflect_screen.dart';
import 'package:implementation_intentions/widgets/serene_drawer.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = [
    AddGoal(),
    GoalMonitorScreen(),
    ReflectScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
      backgroundColor: Colors.amber,
      body: Container(
        child: _widgetOptions.elementAt(_selectedIndex),
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
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
