import 'package:flutter/material.dart';
import 'package:serene/widgets/serene_drawer.dart';

class HabitCreationScreen extends StatefulWidget {
  @override
  _HabitCreationScreenState createState() => _HabitCreationScreenState();
}

class _HabitCreationScreenState extends State<HabitCreationScreen> {
  _buildAddHabitButton() {
    return FloatingActionButton.extended(
      backgroundColor: Colors.blue[400],
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      icon: Icon(Icons.add),
      label: Text("Neues Ziel"),
      onPressed: () async {
        // await Navigator.pushNamed(context, RouteNames.ADD_GOAL);
        // await Navigator.pushNamed(context, RouteNames.MAIN);
        // setState(() {});
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Offene Aufgaben"),
        centerTitle: true,
        // backgroundColor: Colors.transparent,
        elevation: 1.0,
      ),
      drawer: SereneDrawer(),
      floatingActionButton: _buildAddHabitButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Container(
        child: Text("Habit UI"),
      ),
      // body: PageView(
      //   controller: _controller,
      //   onPageChanged: (newPage) {
      //     setState(() {
      //       _selectedPageIndex = newPage;
      //     });
      //   },
      //   children: [
      //     buildMonitoringScreen(),
      //     TimerScreen(),
      //     ResourceLinksScreen(),
      //     ResourceLinksScreen(),
      //   ],
      // ),
      // bottomNavigationBar: BottomAppBar(
      //     elevation: 15.0,
      //     color: Colors.black,
      //     clipBehavior: Clip.antiAlias,
      //     shape: AutomaticNotchedShape(
      //         RoundedRectangleBorder(
      //             borderRadius: BorderRadius.only(
      //                 topLeft: Radius.circular(30),
      //                 topRight: Radius.circular(0))),
      //         RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      //     child: BottomNavigationBar(
      //       type: BottomNavigationBarType.fixed,
      //       elevation: 15.0,
      //       selectedItemColor: Colors.white,
      //       selectedIconTheme: IconThemeData(color: Colors.white, size: 30),
      //       selectedLabelStyle:
      //           TextStyle(color: Colors.white, decorationColor: Colors.white),
      //       backgroundColor: Theme.of(context).primaryColor,
      //       items: [
      //         BottomNavigationBarItem(
      //           icon: Icon(Icons.view_list),
      //           title: Text("Ziele"),
      //         ),
      //         BottomNavigationBarItem(
      //             icon: Icon(Icons.timer), title: Text("Timer")),
      //         BottomNavigationBarItem(
      //             icon: Icon(Icons.bookmark), title: Text("Resourcen")),
      //         BottomNavigationBarItem(
      //             icon: Icon(Icons.expand_less), title: Text(""))
      //       ],
      //       currentIndex: _selectedPageIndex,
      //       onTap: (index) {
      //         _onItemTapped(index);
      //       },
      //     )),
    );
  }
}
