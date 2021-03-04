import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class InitialObstacleExplanationScreen extends StatelessWidget {
  const InitialObstacleExplanationScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MarkdownBody(
              data:
                  "Was sind typische **Hindernisse**, die dich davon abhalten, mit cabuu zu lernen oder die dich während des Lernens mit cabuu stören? Wähle aus der Liste die Hindernisse aus, die auf dich persönlich zutreffen. Auf der übernächsten Seite kannst du wieder ergänzen.")
        ],
      ),
    );
  }
}
