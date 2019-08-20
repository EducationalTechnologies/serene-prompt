import 'package:flutter/material.dart';
import 'package:implementation_intentions/models/goal.dart';
import 'package:implementation_intentions/state/goal_monitor_item_state.dart';
import 'package:implementation_intentions/state/goal_state.dart';
import 'package:implementation_intentions/widgets/list_items.dart';
import 'package:provider/provider.dart';

class GoalMonitorScreen extends StatefulWidget {
  @override
  _GoalMonitorScreenState createState() => _GoalMonitorScreenState();
}

class _GoalMonitorScreenState extends State<GoalMonitorScreen> {
  @override
  void initState() async {}

  // buildListView(List<Goal> goals) {
  //   return ListView.builder(
  //     itemCount: goals.length,
  //     itemBuilder: (context, index) {
  //       return Card(
  //         child: ChangeNotifierProvider<GoalMonitorItemState>(
  //             builder: (_) => GoalMonitorItemState(goals.elementAt(index)),
  //             child: Column(
  //               children: <Widget>[ProgressListItem()],
  //             )),
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // final appState = Provider.of<GoalState>(context);
    return Container(child: Column(
      children: <Widget>[
        Text("Hier"),
      ],
    ));
    // return FutureBuilder(
    //   future: appState.goals,
    //   builder: (BuildContext context, snapshot) {
    //     if (snapshot.hasData) {
    //       if (snapshot.connectionState == ConnectionState.done) {
    //         return Container(
    //           child: buildListView(snapshot.data),
    //         );
    //       }
    //     }
    //     return Center(child: CircularProgressIndicator());
    //   },
    // );
  }
}
