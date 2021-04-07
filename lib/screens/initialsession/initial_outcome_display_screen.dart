import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:serene/shared/ui_helpers.dart';
import 'package:serene/viewmodels/init_session_view_model.dart';

class InitialOutcomeDisplayScreen extends StatelessWidget {
  const InitialOutcomeDisplayScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var vm = Provider.of<InitSessionViewModel>(context);
    var text = vm.selectedOutcomes.length > 0
        ? vm.selectedOutcomes[0].description
        : "";
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          MarkdownBody(
              data:
                  "### Wenn du regelmäßig Vokabeln lernst, dann wäre das beste Ergebnis für dich:"),
          UIHelper.verticalSpaceMedium(),
          Center(child: MarkdownBody(data: "### '_${text}_'")),
          UIHelper.verticalSpaceMedium(),
          MarkdownBody(
              data:
                  "### Nimm dir jetzt einen kurzen Moment Zeit, um dir dieses beste Ergebnis so lebhaft wie möglich vorzustellen. Wie fühlt es sich an? Versetze dich ganz in die Situation hinein. Du kannst dafür auch kurz die Augen schließen. Wenn du fertig bist, drücke auf 'Weiter'"),
          UIHelper.verticalSpaceMedium(),
        ],
      ),
    );
  }
}
