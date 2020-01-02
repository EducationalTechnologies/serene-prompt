import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serene/locator.dart';
import 'package:serene/screens/add_goal_screen.dart';
import 'package:serene/screens/goal_monitor_screen.dart';
import 'package:serene/services/data_service.dart';
import 'package:serene/viewmodels/add_goal_view_model.dart';
import 'package:serene/viewmodels/goal_monitoring_view_model.dart';
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

  _buildMonitoringScreen() {
    return GoalMonitorScreen();
    // return ChangeNotifierProvider<GoalMonitoringVielModel>(
    //   create: (_) => GoalMonitoringVielModel(locator.get<DataService>()),
    //   child: GoalMonitorScreen(),
    // );
  }

  void _onItemTapped(int index) {
    if (index == 3) return;
    this._controller.animateToPage(index,
        duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
  }

  _buildAddGoalButton() {
    return FloatingActionButton.extended(
      backgroundColor: Colors.blue[400],
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      icon: Icon(Icons.add),
      label: Text("Neues Ziel"),
      onPressed: () async {
        // await Navigator.pushNamed(context, RouteNames.ADD_GOAL);
        // await Navigator.pushNamed(context, RouteNames.MAIN);
        await showModalBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                color: Colors.green,
                // child: AddGoalScreen(),
                child: ChangeNotifierProvider(
                  create: (_) =>
                      AddGoalViewModel(dataService: locator.get<DataService>()),
                  child: AddGoalScreen(),
                ),
              );
            });
        // setState(() {});
        Provider.of<GoalMonitoringVielModel>(context, listen: false).refetchGoals();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print("Build MAIN Screen");
    return Scaffold(
      appBar: AppBar(
        title: Text("Offene Aufgaben"),
        centerTitle: true,
        // backgroundColor: Colors.transparent,
        elevation: 1.0,
      ),
      drawer: SereneDrawer(),
      floatingActionButton: _buildAddGoalButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: _buildMonitoringScreen(),
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
