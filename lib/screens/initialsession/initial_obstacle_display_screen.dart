import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:prompt/shared/ui_helpers.dart';
import 'package:prompt/viewmodels/init_session_view_model.dart';

class InitialObstacleDisplayScreen extends StatelessWidget {
  const InitialObstacleDisplayScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var vm = Provider.of<InitSessionViewModel>(context);
    var text = vm.selectedObstacles.length > 0
        ? vm.selectedObstacles[0].description
        : "";
    return Container(
      child: ListView(
        children: [
          MarkdownBody(
              data:
                  "### Wenn du regelmäßig Vokabeln lernst, dann wäre dein größtes Hindernis:"),
          UIHelper.verticalSpaceMedium(),
          Center(
            child: MarkdownBody(data: "### _${text}_"),
          ),
          UIHelper.verticalSpaceMedium(),
          MarkdownBody(
              data:
                  "### Was könntest du machen, um dieses Hindernis zu überwinden? Finde eine Handlung, die du ausführen kannst, oder einen Gedanken, den du denken kannst, um das Hindernis zu überwinden. Stelle dir dazu genau vor, wie du das Hindernis überwindest. Fasse diese Handlung oder den Gedanken in ein paar Stichworten zusammen. "),
          UIHelper.verticalSpaceMedium(),
          Theme(
            data: Theme.of(context).copyWith(splashColor: Colors.white),
            child: TextField(
              maxLines: 5,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText:
                      'Gib hier ein, was du denken oder tun könntest, um das Hindernis zu überwinden.'),
              onChanged: (String text) {
                vm.overcomeObstacleText = text;
              },
            ),
          )
        ],
      ),
    );
  }
}
