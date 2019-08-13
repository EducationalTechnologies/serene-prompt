import 'package:flutter/material.dart';
import 'package:implementation_intentions/models/goal_monitor_item_state.dart';
import 'package:provider/provider.dart';

enum ListItemMenu { delete, edit }

class ProgressListItem extends StatelessWidget {
  const ProgressListItem({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var goalMonitorItemState = Provider.of<GoalMonitorItemState>(context);

    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(children: <Widget>[
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(goalMonitorItemState.goal),
              )),
              PopupMenuButton<ListItemMenu>(
                onSelected: (ListItemMenu result) {},
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<ListItemMenu>>[
                  PopupMenuItem(value: ListItemMenu.edit, child: Text("Edit")),
                  PopupMenuItem(
                    value: ListItemMenu.delete,
                    child: Text("Delete"),
                  )
                ],
              ),
            ]),
            Slider(
              value: goalMonitorItemState.progress.toDouble(),
              min: 0,
              max: 100,
              onChanged: (double value) {
                goalMonitorItemState.progress = value.toInt();
              },
            )
          ],
        ),
      ),
    );
  }
}

// class ProgressListItem extends StatefulWidget {
//   final Goal goal;

//   @override
//   _ProgressListItemState createState() => _ProgressListItemState();

//   const ProgressListItem({Key key, this.goal}) : super(key: key);
// }

// class _ProgressListItemState extends State<ProgressListItem> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: <Widget>[
//             Row(children: <Widget>[
//               Expanded(child: Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: Text(widget.goal.goal),
//               )),
//               PopupMenuButton<ListItemMenu>(
//                 onSelected: (ListItemMenu result) {},
//                 itemBuilder: (BuildContext context) =>
//                     <PopupMenuEntry<ListItemMenu>>[
//                   PopupMenuItem(value: ListItemMenu.edit, child: Text("Edit")),
//                   PopupMenuItem(
//                     value: ListItemMenu.delete,
//                     child: Text("Delete"),
//                   )
//                 ],
//               ),
//             ]),
//             Slider(
//               value: widget.goal.progress.toDouble(),
//               min: 0,
//               max: 100,
//               onChanged: (double value) {
//                 setState(() {
//                   widget.goal.progress = value.toInt();
//                 });
//               },
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
