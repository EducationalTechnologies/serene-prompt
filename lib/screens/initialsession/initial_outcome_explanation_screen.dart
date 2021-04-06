import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:serene/shared/ui_helpers.dart';
import 'package:serene/viewmodels/init_session_view_model.dart';

class InitialOutcomeExplanationScreen extends StatelessWidget {
  const InitialOutcomeExplanationScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var daysOfLearning =
        Provider.of<InitSessionViewModel>(context).numberOfDaysLearningGoal;
    return Container(
      child: Column(
        children: [
          MarkdownBody(
              data:
                  "### Denke jetzt einmal darüber nach, was für dich persönlich das **Beste** daran wäre, wenn du es schaffen würdest, an **$daysOfLearning Tagen pro Woche** Vokabeln zu lernen."),
          UIHelper.verticalSpaceMedium(),
          MarkdownBody(
              data:
                  "### Auf der nächsten Seite siehst du ein paar Vorschläge von uns. Wähle alles aus der Liste aus, was **auf dich zutrifft** Sollte nichts darunter sein oder noch etwas Wichtiges fehlen, kannst du es auf der übernächsten Seite ergänzen."),
          UIHelper.verticalSpaceMedium(),
        ],
      ),
    );
  }
}
