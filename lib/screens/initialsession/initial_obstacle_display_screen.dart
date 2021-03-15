import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serene/shared/ui_helpers.dart';
import 'package:serene/viewmodels/init_session_view_model.dart';

class InitialObstacleDisplayScreen extends StatelessWidget {
  const InitialObstacleDisplayScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var vm = Provider.of<InitSessionViewModel>(context);
    var text = vm.selectedObstacles.length > 0
        ? vm.selectedObstacles[0].description
        : "";
    return Container(
      child: Column(
        children: [
          Text("${vm.selectedObstacles[0].description}"),
          UIHelper.verticalSpaceMedium(),
          Text(
              "Was könntest du machen, um dieses Hindernis zu überwinden? Finde eine Handlung, die du ausführen kannst, oder einen Gedanken, den du denken kannst, um das Hindernis zu überwinden. Stelle dir dazu genau vor, wie du das Hindernis überwindest. Fasse diese Handlung oder den Gedanken in ein paar Stichworten zusammen. "),
          UIHelper.verticalSpaceMedium(),
          TextField(
            maxLines: 5,
            decoration: InputDecoration(hintText: 'Gib hier deinen Text ein'),
            onChanged: (String text) {
              vm.overcomeObstacleText = text;
            },
          )
        ],
      ),
    );
  }
}
